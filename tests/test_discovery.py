"""Discovery is read-only, deterministic and conservative about special/limited content."""
import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / 'scripts'))
import discover_veterans as scan

POLICY = json.loads((REPO / 'config/discovery.json').read_text())


class DiscoveryTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(); self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / 'ReferenceFiles'; self.root.mkdir()
        self.source = 'records/creatures/enemies/test_a01.dbr'
        self.pool = 'records/proxies/pools/p_test.dbr'
        self.proxy = 'records/proxies/area001/test.dbr'
        self.put(self.source, 'templateName,database/templates/monster.tpl,\nmonsterClassification,Common,\n'
                 'description,tagTest,\nscale,1.000000,\n'
                 'characterAttributeEquations,records/creatures/enemies/bios/test.dbr,\n'
                 'skillName1,records/skills/nonplayerskills/passive/test.dbr,\n')
        self.put('records/creatures/enemies/bios/test.dbr',
                 'templateName,database/templates/characterattributeequations.tpl,\n'
                 'characterLife,charLevel*10,\ncharacterDefensiveAbility,charLevel*2,\n')
        self.put('records/skills/nonplayerskills/passive/test.dbr',
                 'templateName,database/templates/skill_passive.tpl,\n'
                 'offensivePhysicalMin,5;6,\noffensivePhysicalMax,8;9,\n')
        self.put(self.pool, f'templateName,database/templates/proxypool.tpl,\nname1,{self.source},\n'
                 'weight1,100,\nmaxPlayerLevel1,5,\nchampionChance,15,\n')
        self.put(self.proxy, f'templateName,database/templates/proxy.tpl,\npool1,{self.pool},\n')

    def put(self, record, text):
        path = self.root / record.removeprefix('records/')
        path.parent.mkdir(parents=True, exist_ok=True); path.write_text(text)
        return path

    def run_scan(self, families=None, tags=None):
        return scan.discover(self.root, families or [], POLICY, tags)

    def test_candidate_has_stable_disabled_config_and_scan_changes_nothing(self):
        before = {p: p.read_bytes() for p in self.root.rglob('*') if p.is_file()}
        report = self.run_scan(tags={'tagTest': 'Known Creature'})
        self.assertEqual(report['summary']['candidate_sources'], 1)
        self.assertEqual(report['entries'][0]['output_slot'], 2)
        draft = scan.draft_config(report)
        self.assertFalse(draft['enabled'])
        self.assertEqual(draft['variants'][0]['display_name'], 'Known Creature')
        self.assertEqual(draft, scan.draft_config(self.run_scan(tags={'tagTest': 'Known Creature'})))
        self.assertEqual(before, {p: p.read_bytes() for p in self.root.rglob('*') if p.is_file()})

    def test_shared_pool_is_one_config_and_repeated_sources_one_variant(self):
        path = self.root / self.pool.removeprefix('records/')
        path.write_text(path.read_text() + f'name2,{self.source},\nweight2,30,\n')
        draft = scan.draft_config(self.run_scan())
        self.assertEqual(len(draft['variants']), 1)
        self.assertEqual(len(draft['pools']), 1)
        self.assertEqual(len(draft['pools'][0]['promotions']), 2)
        self.assertEqual([p['output_slot'] for p in draft['pools'][0]['promotions']], [3, 4])
        self.assertNotIn('display_name', draft['variants'][0])

    def test_limited_and_forced_entries_require_review(self):
        path = self.root / self.pool.removeprefix('records/')
        for field in ('limit1', 'alwaysSpawn1'):
            original = path.read_text(); path.write_text(original + f'{field},1,\n')
            self.assertIn('limited_or_forced_entry', self.run_scan()['entries'][0]['reasons'])
            path.write_text(original)

    def test_champion_never_becomes_veteran_and_special_proxies_block_pool(self):
        path = self.root / self.source.removeprefix('records/')
        original = path.read_text(); path.write_text(original.replace('Common', 'Champion'))
        self.assertIn('not_common', self.run_scan()['entries'][0]['reasons'])
        path.write_text(original)
        self.put('records/proxies/boss&quest/test.dbr',
                 f'templateName,database/templates/proxy.tpl,\npool1,{self.pool},\n')
        self.assertIn('pool_also_used_by_special_proxy', self.run_scan()['entries'][0]['reasons'])

    def test_missing_dependency_initial_slots_and_pool_capacity_reported(self):
        path = self.root / self.source.removeprefix('records/')
        original = path.read_text(); path.write_text(original + 'initialSkillName,one,\ninitial2SkillName,two,\n')
        self.assertIn('no_free_initial_slot', self.run_scan()['entries'][0]['reasons'])
        path.write_text(original.replace('/bios/test.dbr', '/bios/missing.dbr'))
        self.assertIn('missing_or_invalid_dependency', self.run_scan()['entries'][0]['reasons'])
        path.write_text(original)
        pool_path = self.root / self.pool.removeprefix('records/')
        pool_path.write_text(pool_path.read_text() + ''.join(f'minPlayerLevel{i},1,\n' for i in range(2, 16)))
        self.assertIn('no_free_pool_slot', self.run_scan()['entries'][0]['reasons'])

    def test_existing_config_is_reported_not_duplicated_or_overwritten(self):
        family = {'variants': [{'source_record': self.source}],
                  'pools': [{'record': self.pool, 'promotions': [{'source_slot': 1}]}]}
        original = copy.deepcopy(family)
        report = self.run_scan([family]); self.assertEqual(report['entries'][0]['status'], 'already_mapped')
        self.assertEqual(scan.draft_config(report)['variants'], [])
        self.assertEqual(family, original)
        family['pools'][0]['promotions'] = []
        self.assertIn('existing_pool_merge_review', self.run_scan([family])['entries'][0]['reasons'])

    def test_ambiguous_tags_omitted_and_bom_encodings_supported(self):
        root = Path(self.temp.name) / 'Text_EN'; root.mkdir()
        (root / 'one.txt').write_text('tagTest=Known\ntagOther=Other\n', encoding='utf-8-sig')
        (root / 'two.txt').write_text('tagTest=Conflict\ntagUtf=Example\n', encoding='utf-16')
        tags, meta = scan.text_tags(root)
        self.assertNotIn('tagTest', tags); self.assertEqual(tags['tagUtf'], 'Example')
        self.assertEqual(meta['ambiguous_tags'], ['tagTest'])

    def test_write_output_never_accepts_traversal_or_symlinks(self):
        out = Path(self.temp.name) / 'generated/discovery'
        with patch.object(scan, 'OUTPUT', out):
            with self.assertRaises(ValueError): scan.write_outputs({'../config.json': 'bad'})
            scan.write_outputs({'coverage.md': 'report'})
            target = Path(self.temp.name) / 'untouched'; target.write_text('original')
            (out / 'draft.json').symlink_to(target)
            with self.assertRaises(ValueError): scan.write_outputs({'draft.json': 'bad'})
            self.assertEqual(target.read_text(), 'original')

    def test_missing_weight_in_other_slot_blocks_whole_pool(self):
        path = self.root / self.pool.removeprefix('records/')
        path.write_text(path.read_text() + f'name2,{self.source},\n')
        report = self.run_scan()
        self.assertEqual(report['summary']['candidate_entries'], 0)
        self.assertIn('invalid_or_overflow_pool_weights', report['entries'][0]['reasons'])

    def test_slot_reservation_uses_whole_numeric_suffix(self):
        self.assertEqual(scan.occupied_regular_slots({'name11': 'x', 'weightChampion3': '1'}, 15), {11})

    def test_faction_and_quest_sources_are_review_only(self):
        path = self.root / self.source.removeprefix('records/')
        path.write_text(path.read_text() + 'quest,1,\n')
        self.assertIn('quest_marked_source', self.run_scan()['entries'][0]['reasons'])
        excluded = __import__('re').compile(POLICY['excluded_path_pattern'])
        self.assertTrue(excluded.search('records/creatures/enemies/faction/blacklegion_a01.dbr'))
        self.assertTrue(excluded.search('records/proxies/pools/p_faction_blacklegion_n.dbr'))

    def test_wrong_tier_policy_and_malformed_reference_fail_clearly(self):
        policy = dict(POLICY, target_tier='elite')
        with self.assertRaises(ValueError): scan.discover(self.root, [], policy)
        path = self.root / self.source.removeprefix('records/')
        path.write_text(path.read_text() + 'scale,2,\n')
        self.assertIn('missing_or_invalid_dependency', self.run_scan()['entries'][0]['reasons'])
