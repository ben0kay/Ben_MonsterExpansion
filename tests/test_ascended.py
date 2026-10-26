"""Ascended quota bounds, exact-parent discovery and combined-catalog invariants."""
import copy
from fractions import Fraction
import json
from pathlib import Path
import re
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
import discover_veterans as scan
import generate_variants as gen
import natural_spawns as spawn
from dbr import DBR
from validate_config import reference_path
from test_natural_spawns import catalog


class AscendedTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.families, cls.tiers = catalog()
        cls.family = next(f for f in cls.families if f['id'] == 'discovered_ascended')
        cls.files = gen.configured_plan(include_spawns=True)

    def test_every_activated_hero_preserves_combined_quota_and_exact_probability(self):
        variants = {v['id']: v for v in self.family['variants']}
        for config in self.family['pools']:
            original = scan.Index(gen.REFERENCE).read(config['record'])
            output = DBR(self.files[gen.game_location(config['record'])])
            self.assertEqual(original['championMax'], output.get('championMax'))
            self.assertEqual(original['championMin'], output.get('championMin'))
            maximum = int(original['championMax'])
            original_total = sum(int(v) for k, v in original.items() if re.fullmatch(r'weightChampion\d+', k))
            final_total = sum(int(line.split(',')[1]) for line in output.lines if re.fullmatch(r'weightChampion\d+', line.split(',')[0]))
            for entry in config['promotions']:
                a, b = entry['source_slot'], entry['output_slot']
                limit = int(original.get(f'limitChampion{a}', '0'))
                if limit:
                    self.assertLessEqual(maximum, limit)
                    self.assertEqual(output.get(f'limitChampion{b}'), str(limit))
                    equation = scan.Index(gen.REFERENCE).read(original['proxyPoolEquation'])
                    self.assertEqual(re.sub(r'\s+', '', equation['championMaxEquation']), 'poolValue*1')
                retained, promoted = int(output.get(f'weightChampion{a}')), int(output.get(f'weightChampion{b}'))
                self.assertEqual(Fraction(promoted, retained + promoted), Fraction(33, 100))
                self.assertEqual(Fraction(retained + promoted, final_total), Fraction(int(original[f'weightChampion{a}']), original_total))
                self.assertEqual(output.get(f'nameChampion{b}'), variants[entry['variant']]['output_record'])
                for stem in ('levelVarianceEquation', 'minPlayerLevel', 'maxPlayerLevel'):
                    if f'{stem}Champion{a}' in original:
                        self.assertEqual(output.get(f'{stem}Champion{b}'), original[f'{stem}Champion{a}'])

    def test_previous_variants_settings_and_unrelated_fields_preserved(self):
        previous = [f for f in self.families if f['id'] != 'discovered_ascended']
        old = gen.build_plan(previous, self.tiers, include_spawns=True)
        asc_pools = {p['record']: p for p in self.family['pools']}
        for path, text in old.items():
            if path.name == 'manifest.json': continue
            if '/proxies/pools' not in path.as_posix():
                self.assertEqual(self.files[path], text, str(path)); continue
            record = path.as_posix().removeprefix('database/')
            output = DBR(self.files[path])
            # Previously unmapped Hero source weights may split; all other old fields stay equal.
            promotions = {p['source_slot']: p['output_slot'] for p in asc_pools.get(record, {}).get('promotions', [])}
            old_data = DBR(text)
            old_total = sum(int(line.split(',')[1]) for line in old_data.lines if re.fullmatch(r'weightChampion\d+', line.split(',')[0]))
            new_total = sum(int(line.split(',')[1]) for line in output.lines if re.fullmatch(r'weightChampion\d+', line.split(',')[0]))
            for line in old_data.lines:
                key, value = line.split(',')[:2]
                match = re.fullmatch(r'weightChampion(\d+)', key)
                if match and old_total:
                    slot = int(match.group(1))
                    mass = int(output.get(key))
                    if slot in promotions:
                        mass += int(output.get(f'weightChampion{promotions[slot]}'))
                    self.assertEqual(Fraction(mass, new_total), Fraction(int(value), old_total))
                else:
                    self.assertEqual(output.get(key), value, str(path) + ':' + key)
        self.assertEqual(gen.configured_plan(include_spawns=True)[Path('database/records/creatures/pc/playerlevels.dbr')],
                         self.files[Path('database/records/creatures/pc/playerlevels.dbr')])

    def test_ascended_stats_violet_effect_and_hero_identity(self):
        variant = self.family['variants'][0]
        parent = gen.read_game_dbr(variant['source_record'])
        monster = DBR(self.files[gen.game_location(variant['output_record'])])
        self.assertEqual(monster.get('monsterClassification'), 'Hero')
        self.assertEqual(monster.get('description'), parent.get('description'))
        bio = DBR(self.files[gen.game_location(monster.get('characterAttributeEquations'))])
        source_bio = gen.read_game_dbr(parent.get('characterAttributeEquations'))
        self.assertEqual(bio.get('characterLife'), '(' + source_bio.get('characterLife') + ')*1.4')
        self.assertEqual(bio.get('characterDefensiveAbility'), '(' + source_bio.get('characterDefensiveAbility') + ')*1.15')
        self.assertAlmostEqual(float(monster.get('scale')), float(parent.get('scale')) * 1.15)
        for line in parent.lines:
            key, value = line.split(',')[:2]
            if key.startswith('skillName') and value != variant['damage_skill_source_record']:
                self.assertEqual(monster.get(key), value)
        prefix = self.family['id'] + '_' + variant['id']
        damage = DBR(self.files[Path(f'database/records/skills/nonplayerskills/monsterexpansion/{prefix}_damage.dbr')])
        source = gen.read_game_dbr(variant['damage_skill_source_record'])
        for key in ('offensivePhysicalMin', 'offensivePhysicalMax'):
            for a, b in zip(source.get(key).split(';'), damage.get(key).split(';')):
                self.assertAlmostEqual(float(b), float(a) * 1.22, places=5)
        effect = DBR(self.files[Path(f'database/records/fx/monsterexpansion/{prefix}_cosmetic_fx.dbr')])
        self.assertEqual(effect.get('effectFile'), 'fx/particlesystems/creature/pfx_glowpurple_01_lg.pfx')

    def test_unsupported_quota_equations_and_forced_group_refused(self):
        tier = self.tiers['ascended']
        data = {'championMax': '1', 'championMin': '0', 'limitChampion1': '1', 'proxyPoolEquation': 'equation'}
        equation = {'templateName': 'database/templates/proxypoolequation.tpl', 'championMaxEquation': 'poolValue * 1', 'championMinEquation': 'poolValue * 1'}
        read = lambda _: equation
        self.assertIsNone(spawn.limit_policy_error(data, 'Champion', 1, tier, read))
        for change, reason in [({'championMax': '2'}, 'finite_quota_exceeds_supported_group_bound'),
                               ({'alwaysSpawnChampion2': '1'}, 'forced_champion_group_needs_review'),
                               ({'alwaysSpawnChampion1': '1'}, 'limited_or_forced_entry')]:
            self.assertEqual(spawn.limit_policy_error(dict(data, **change), 'Champion', 1, tier, read), reason)
        self.assertEqual(spawn.limit_policy_error(data, 'Champion', 1, self.tiers['elite'], read), 'limited_or_forced_entry')
        equation['championMaxEquation'] = 'poolValue * 2'
        self.assertEqual(spawn.limit_policy_error(data, 'Champion', 1, tier, read), 'unsupported_champion_count_equation')

    def test_elite_and_ascended_chances_are_independent_and_rollback_keeps_elites(self):
        elite = next(f for f in self.families if f['id'] == 'discovered_elites')
        shared = next(p for p in self.family['pools'] if any(q['record'] == p['record'] for q in elite['pools']))
        others = [(f, p) for f in self.families if f['id'] != self.family['id'] for p in f['pools'] if p['record'] == shared['record']]
        tiers = copy.deepcopy(self.tiers); tiers['ascended']['prototype']['natural_spawns']['conversion_share'] = .25
        mappings = others + [(self.family, shared)]
        _, text, _ = spawn.build_merged_pool(mappings, tiers, gen.REFERENCE); result = DBR(text)
        for f, pool in mappings:
            for entry in pool['promotions']:
                v = next(v for v in f['variants'] if v['id'] == entry['variant'])
                group = '' if v['tier'] == 'veteran' else 'Champion'
                a, b = entry['source_slot'], entry['output_slot']
                expected = {'veteran': Fraction(1, 5), 'elite': Fraction(33, 100), 'ascended': Fraction(1, 4)}[v['tier']]
                kept, promoted = int(result.get(f'weight{group}{a}')), int(result.get(f'weight{group}{b}'))
                self.assertEqual(Fraction(promoted, kept + promoted), expected)
        _, rollback, _ = spawn.build_merged_pool(others + [(self.family, dict(shared, enabled=False))], self.tiers, gen.REFERENCE)
        _, old, _ = spawn.build_merged_pool(others, self.tiers, gen.REFERENCE)
        self.assertEqual(rollback, old)
        tiers['ascended']['prototype']['natural_spawns']['conversion_share'] = .123
        _, rollback, _ = spawn.build_merged_pool(others + [(self.family, dict(shared, enabled=False))], tiers, gen.REFERENCE)
        self.assertEqual(rollback, old)

    def test_discovery_snapshot_reserves_elite_slots_and_is_repeatable(self):
        policy = json.loads((gen.REPO / 'config/discovery_ascended.json').read_text())
        previous = [f for f in self.families if f['id'] != 'discovered_ascended']
        report = scan.discover(gen.REFERENCE, previous, policy)
        self.assertEqual(report['summary']['read_errors'], 0)
        self.assertEqual(report['summary']['candidate_entries'], 241)
        draft = scan.draft_config(report)
        self.assertEqual(draft['variants'], self.family['variants'])
        self.assertEqual(draft['pools'], self.family['pools'])
        elite = next(f for f in previous if f['id'] == 'discovered_elites')
        for pool in draft['pools']:
            occupied = {e['output_slot'] for p in elite['pools'] if p['record'] == pool['record'] for e in p['promotions']}
            self.assertTrue(occupied.isdisjoint(e['output_slot'] for e in pool['promotions']))
