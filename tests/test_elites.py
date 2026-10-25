"""Champion discovery and merged-pool probability/eligibility regression checks."""
import copy
from fractions import Fraction
import json
from pathlib import Path
import re
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
import discover_veterans as scan
import generate_variants as gen
import natural_spawns as spawns
from dbr import DBR
from validate_config import reference_path
from test_natural_spawns import catalog


class EliteTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.families, cls.tiers = catalog()
        cls.files = gen.configured_plan(include_spawns=True)
        cls.elites = next(f for f in cls.families if f['id'] == 'discovered_elites')

    def test_complete_merged_catalog_preserves_every_other_field_and_probability(self):
        """Independent oracle over final output, including pools shared by both tiers."""
        by_pool = {}
        for family in self.families:
            variants = {v['id']: v for v in family['variants']}
            for pool in family['pools']:
                for entry in pool['promotions']:
                    variant = variants[entry['variant']]
                    group = '' if variant['tier'] == 'veteran' else 'Champion'
                    by_pool.setdefault(pool['record'], {}).setdefault(group, []).append((entry, variant))
        shared = 0
        for record, groups in by_pool.items():
            with self.subTest(pool=record):
                original = scan.Index(gen.REFERENCE).read(record)
                output = DBR(self.files[gen.game_location(record)])
                expected = dict(original)
                shared += len(groups) == 2
                for group, entries in groups.items():
                    ratio = Fraction(1, 5) if not group else Fraction(33, 100)
                    slots = [int(m.group(1)) for k in original if (m := re.fullmatch('name' + group + r'(\d+)', k))]
                    old_total = sum(int(original[f'weight{group}{i}']) for i in slots)
                    for i in slots:
                        expected[f'weight{group}{i}'] = str(int(original[f'weight{group}{i}']) * ratio.denominator)
                    for entry, variant in entries:
                        a, b = entry['source_slot'], entry['output_slot']
                        weight = int(original[f'weight{group}{a}'])
                        expected[f'weight{group}{a}'] = str(weight * (ratio.denominator - ratio.numerator))
                        expected[f'weight{group}{b}'] = str(weight * ratio.numerator)
                        expected[f'name{group}{b}'] = variant['output_record']
                        for stem in ('levelVarianceEquation', 'minPlayerLevel', 'maxPlayerLevel'):
                            if f'{stem}{group}{a}' in original:
                                expected[f'{stem}{group}{b}'] = original[f'{stem}{group}{a}']
                        promoted = int(output.get(f'weight{group}{b}'))
                        retained = int(output.get(f'weight{group}{a}'))
                        self.assertEqual(Fraction(promoted, promoted + retained), ratio)
                        self.assertEqual(Fraction(promoted + retained, old_total * ratio.denominator), Fraction(weight, old_total))
                values = {line.split(',')[0]: line.split(',')[1] for line in output.lines if ',' in line}
                self.assertEqual(values, expected)
        self.assertEqual(shared, 212)

    def test_veteran_records_and_regular_selections_preserved_in_combined_build(self):
        veterans = [f for f in self.families if f['id'] != 'discovered_elites']
        old = gen.build_plan(veterans, self.tiers, include_spawns=True)
        for path, text in old.items():
            if path.name == 'manifest.json':
                continue
            if '/proxies/' not in str(path):
                self.assertEqual(self.files[path], text, str(path))
            else:
                now = DBR(self.files[path])
                for line in DBR(text).lines:
                    key = line.split(',')[0]
                    if not re.fullmatch(r'weightChampion\d+', key):
                        self.assertEqual(now.get(key), line.split(',')[1], str(path))

    def test_elite_stats_skills_classification_and_golden_particle(self):
        variant = self.elites['variants'][0]
        monster = DBR(self.files[gen.game_location(variant['output_record'])])
        parent = gen.read_game_dbr(variant['source_record'])
        self.assertEqual(monster.get('monsterClassification'), 'Champion')
        self.assertEqual(monster.get('description'), parent.get('description'))
        bio = DBR(self.files[gen.game_location(monster.get('characterAttributeEquations'))])
        original_bio = gen.read_game_dbr(parent.get('characterAttributeEquations'))
        self.assertEqual(bio.get('characterLife'), '(' + original_bio.get('characterLife') + ')*1.3')
        self.assertEqual(bio.get('characterDefensiveAbility'), '(' + original_bio.get('characterDefensiveAbility') + ')*1.12')
        for key in ('actorRadius', 'actorHeight'):
            self.assertEqual(monster.get(key), parent.get(key))
        for line in parent.lines:
            key, value = line.split(',')[:2]
            if key.startswith('skillName') and value != variant['damage_skill_source_record']:
                self.assertEqual(monster.get(key), value)
        self.assertAlmostEqual(float(monster.get('scale')), float(parent.get('scale')) * 1.1)
        prefix = self.elites['id'] + '_' + variant['id']
        damage = DBR(self.files[Path(f'database/records/skills/nonplayerskills/monsterexpansion/{prefix}_damage.dbr')])
        source_damage = gen.read_game_dbr(variant['damage_skill_source_record'])
        for key in ('offensivePhysicalMin', 'offensivePhysicalMax'):
            for before, after in zip(source_damage.get(key).split(';'), damage.get(key).split(';')):
                self.assertAlmostEqual(float(after), float(before) * 1.18, places=5)
        effect = DBR(self.files[Path(f'database/records/fx/monsterexpansion/{prefix}_cosmetic_fx.dbr')])
        self.assertEqual(effect.get('effectFile'), 'fx/particlesystems/creature/pfx_goldenglow01_large.pfx')

    def test_conflicting_shared_mappings_rejected_and_disabling_elites_keeps_veterans(self):
        elite_pool = next(p for p in self.elites['pools'] if any(p['record'] == q['record'] for f in self.families if f != self.elites for q in f['pools']))
        others = [(f, p) for f in self.families if f != self.elites for p in f['pools'] if p['record'] == elite_pool['record']]
        with self.assertRaises(ValueError):
            spawns.build_merged_pool([(self.elites, elite_pool), (self.elites, elite_pool)], self.tiers, gen.REFERENCE)
        disabled = dict(elite_pool, enabled=False)
        _, merged, _ = spawns.build_merged_pool(others + [(self.elites, disabled)], self.tiers, gen.REFERENCE)
        _, original, _ = spawns.build_merged_pool(others, self.tiers, gen.REFERENCE)
        self.assertEqual(merged, original)
        wrong = copy.deepcopy(self.elites); wrong['variants'][0]['expected_classification'] = 'Common'
        with self.assertRaises(gen.GenerationError):
            gen.build_variant(wrong, wrong['variants'][0], self.tiers['elite'])

    def test_discovery_is_exact_parent_and_refuses_quotas_unknown_rules_and_full_slots(self):
        policy = json.loads((gen.REPO / 'config/discovery_elites.json').read_text())
        source = self.elites['variants'][0]['source_record']
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            def put(record, text):
                path = root / record.removeprefix('records/'); path.parent.mkdir(parents=True, exist_ok=True); path.write_text(text)
            index = scan.Index(gen.REFERENCE)
            todo, seen = [source], set()
            # Copy just the referenced monster, bio and skills for the compatibility check.
            while todo:
                record = todo.pop()
                if record in seen: continue
                seen.add(record); data = index.read(record)
                put(record, reference_path(record, gen.REFERENCE).read_text())
                if record == source:
                    todo += [v for k, v in data.items() if k == 'characterAttributeEquations' or re.fullmatch(r'skillName\d+', k)]
            pool = 'records/proxies/pools/p_test.dbr'
            proxy = 'records/proxies/area001/test.dbr'
            put(proxy, f'templateName,database/templates/proxy.tpl,\npool1,{pool},\n')
            base = f'templateName,database/templates/proxypool.tpl,\nnameChampion1,{source},\nweightChampion1,100,\n'
            put(pool, base)
            run = lambda: scan.discover(root, [], policy)
            report = run(); self.assertEqual(report['summary']['candidate_sources'], 1)
            self.assertEqual(scan.draft_config(report)['variants'][0]['expected_classification'], 'Champion')
            for field, reason in [('limitChampion1', 'limited_or_forced_entry'), ('alwaysSpawnChampion1', 'limited_or_forced_entry'), ('unknownChampion1', 'unsupported_slot_rule_fields')]:
                put(pool, base + f'{field},1,\n')
                self.assertIn(reason, run()['entries'][0]['reasons'])
            put(pool, base + ''.join(f'minPlayerLevelChampion{i},1,\n' for i in range(2, 16)))
            self.assertIn('no_free_pool_slot', run()['entries'][0]['reasons'])
            put(pool, base)
            for classification in ('Common', 'Hero', 'Quest', 'Boss'):
                put(source, reference_path(source, gen.REFERENCE).read_text().replace('monsterClassification,Champion,', f'monsterClassification,{classification},'))
                self.assertIn('not_champion', run()['entries'][0]['reasons'])
