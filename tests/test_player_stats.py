import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from player_stats import load_settings, build_player_stats, build_player_level_cap, RECORD, OUTPUT_RECORD
from player_movement import load_settings as load_movement, build_player_movement, PLAYER_RECORDS
from player_basics import load_settings as load_basics, build_player_basics
from dbr import DBR
from references import resolve
import generate_variants as gen


class PlayerStatTests(unittest.TestCase):
    def test_attributes_and_devotion_cap_compose_without_other_progression_changes(self):
        settings = load_settings(gen.REPO)
        source = resolve(RECORD, gen.REFERENCE).read_text()
        expected = source.replace('characterModifierPoints,1,', 'characterModifierPoints,2,')
        for field in ('strengthIncrement', 'dexterityIncrement', 'intelligenceIncrement'):
            expected = expected.replace(field+',8,', field+',6,')
        expected = expected.replace('maxDevotionPoints,55,', 'maxDevotionPoints,85,')
        expected = expected.replace('maxPlayerLevel,100,', 'maxPlayerLevel,150,')
        native_awards = DBR(source).get('skillModifierPoints').split(';')
        self.assertGreaterEqual(len(native_awards), 149)
        adjusted_awards = native_awards.copy()
        adjusted_awards[:149] = ['3']*59 + ['2']*40 + ['1']*50
        expected = expected.replace(
            'skillModifierPoints,'+';'.join(native_awards)+',',
            'skillModifierPoints,'+';'.join(adjusted_awards)+',')
        self.assertEqual(build_player_stats(settings, gen.REFERENCE), expected)
        self.assertIn('maxPlayerLevel,150,', expected)
        self.assertIn('maxDevotionPoints,85,', expected)
        self.assertEqual(settings['attribute_points_per_level'], 2)
        awards = DBR(expected).get('skillModifierPoints').split(';')
        self.assertEqual(awards[:149], adjusted_awards[:149])
        self.assertEqual(awards[149:], native_awards[149:])
        self.assertEqual(sum(map(int, awards[:149])), 307)
        self.assertEqual(sum(map(int, native_awards[:149])), 287)

    def test_disable_emits_exact_effective_vanilla(self):
        settings = load_settings(gen.REPO); settings['enabled'] = False
        settings['devotion']['enabled'] = False
        settings['level_cap']['enabled'] = False
        settings['skill_points_per_level']['enabled'] = False
        self.assertEqual(build_player_stats(settings, gen.REFERENCE), resolve(RECORD, gen.REFERENCE).read_text())

    def test_invalid_values_are_rejected(self):
        settings = load_settings(gen.REPO)
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); (root/'config').mkdir()
            for value in (True, 0, -1, 1.5, '2'):
                for target in ('attribute_points_per_level', 'physique'):
                    bad = copy.deepcopy(settings)
                    if target == 'physique': bad['attribute_gain_per_point'][target] = value
                    else: bad[target] = value
                    (root/'config/player_stats.json').write_text(json.dumps(bad))
                    with self.subTest(value=value, target=target), self.assertRaises(ValueError): load_settings(root)

    def test_skill_points_brackets_3_2_1_totals_rollback_and_field_isolation(self):
        settings = load_settings(gen.REPO)
        native = DBR.from_file(resolve(RECORD, gen.REFERENCE))
        modified = DBR(build_player_stats(settings, gen.REFERENCE))
        old = [int(v) for v in native.get('skillModifierPoints').split(';')]
        new = [int(v) for v in modified.get('skillModifierPoints').split(';')]
        self.assertEqual(len(old), len(new))
        self.assertEqual(new[:149], [3]*59 + [2]*40 + [1]*50)
        self.assertEqual(new[149:], old[149:])
        for level, reward in ((2, 3), (50, 3), (51, 3), (60, 3),
                              (61, 2), (90, 2), (91, 2), (100, 2),
                              (101, 1), (150, 1)):
            with self.subTest(level=level):
                self.assertEqual(new[level-2], reward)
        self.assertEqual(sum(old[:149]), 287)
        self.assertEqual(sum(new[:149]), 307)
        self.assertEqual(sum(new[:149]) - sum(old[:149]), 20)
        self.assertEqual(sum(new[:99]), 257)

        no_skill_changes = copy.deepcopy(settings)
        no_skill_changes['skill_points_per_level']['enabled'] = False
        restored = DBR(build_player_stats(no_skill_changes, gen.REFERENCE))
        self.assertEqual(restored.get('skillModifierPoints'),
                         native.get('skillModifierPoints'))
        self.assertEqual(restored.get('maxPlayerLevel'), '150')
        self.assertEqual(restored.get('maxDevotionPoints'), '85')
        self.assertEqual(restored.get('characterModifierPoints'), '2')
        expected = DBR(build_player_stats(no_skill_changes, gen.REFERENCE))
        expected.set('skillModifierPoints', modified.get('skillModifierPoints'))
        self.assertEqual(modified.render(), expected.render())

    def test_invalid_skill_point_brackets_are_rejected(self):
        settings = load_settings(gen.REPO)
        cases = [
            {'enabled': True, 'ranges': []},
            {'enabled': True, 'ranges': [{'start_level': 3, 'end_level': 150, 'points': 3}]},
            {'enabled': True, 'ranges': [{'start_level': 2, 'end_level': 60, 'points': 3},
                                         {'start_level': 62, 'end_level': 150, 'points': 2}]},
            {'enabled': True, 'ranges': [{'start_level': 2, 'end_level': 150, 'points': True}]},
            {'enabled': True, 'ranges': [{'start_level': 2, 'end_level': 150, 'points': 0}]},
            {'enabled': True, 'ranges': [{'start_level': 2, 'end_level': 100, 'points': 3}]},
            {'enabled': True, 'ranges': [{'start_level': 2, 'end_level': 201, 'points': 3}]},
            {'enabled': 'yes', 'ranges': [{'start_level': 2, 'end_level': 150, 'points': 3}]},
        ]
        for schedule in cases:
            with tempfile.TemporaryDirectory() as tmp:
                root = Path(tmp)
                (root / 'config').mkdir()
                invalid = copy.deepcopy(settings)
                invalid['skill_points_per_level'] = schedule
                (root / 'config/player_stats.json').write_text(json.dumps(invalid))
                with self.subTest(schedule=schedule), self.assertRaises(ValueError):
                    load_settings(root)

    def test_level_cap_composes_with_speed_health_energy_and_rolls_back(self):
        settings = load_settings(gen.REPO)
        movement, _ = build_player_movement(load_movement(gen.REPO), gen.REFERENCE)
        basics, _ = build_player_basics(load_basics(gen.REPO), gen.REFERENCE, movement)
        modded, report = build_player_level_cap(settings, gen.REFERENCE, basics)
        self.assertEqual(len(modded), 2)
        self.assertEqual(len(report), 2)
        for name in PLAYER_RECORDS:
            path = Path('database') / name
            expected = basics[path].replace('maxLevel,100,', 'maxLevel,150,')
            self.assertEqual(modded[path], expected)
            actor = DBR(modded[path])
            self.assertEqual(actor.get('maxLevel'), '150')
            self.assertEqual(actor.get('characterLife'), '300.000000')
            self.assertEqual(actor.get('characterMana'), '300.000000')
            self.assertEqual(actor.get('characterRunSpeed'), '1.069500')

        rollback = copy.deepcopy(settings)
        rollback['level_cap']['enabled'] = False
        restored, _ = build_player_level_cap(rollback, gen.REFERENCE, basics)
        for name in PLAYER_RECORDS:
            self.assertEqual(restored[Path('database') / name],
                             basics[Path('database') / name])
        unchanged_level_record = build_player_stats(rollback, gen.REFERENCE)
        self.assertIn('maxPlayerLevel,100,', unchanged_level_record)
        self.assertIn('characterModifierPoints,2,', unchanged_level_record)

    def test_invalid_level_cap_is_rejected(self):
        settings = load_settings(gen.REPO)
        for cap in ({'enabled': True, 'max_level': 99},
                    {'enabled': True, 'max_level': 201},
                    {'enabled': True, 'max_level': True},
                    {'enabled': 'true', 'max_level': 150},
                    {'enabled': True, 'max_level': 150.0},
                    {'enabled': True}):
            with tempfile.TemporaryDirectory() as tmp:
                root = Path(tmp)
                (root / 'config').mkdir()
                wrong = copy.deepcopy(settings)
                wrong['level_cap'] = cap
                (root / 'config/player_stats.json').write_text(json.dumps(wrong))
                with self.subTest(cap=cap), self.assertRaises(ValueError):
                    load_settings(root)

    def test_player_record_is_in_manifest_and_generated_without_spawn_flag(self):
        files = gen.configured_plan('boar')
        self.assertIn(OUTPUT_RECORD, files)
        manifest = json.loads(files[Path('manifest.json')])
        self.assertIn(OUTPUT_RECORD.as_posix(), manifest['files'])
        self.assertEqual(manifest['player_stats']['attribute_points_per_level'], 2)
        self.assertEqual(manifest['player_stats']['level_cap']['max_level'], 150)
        self.assertTrue(manifest['player_stats']['skill_points_per_level']['enabled'])
        self.assertEqual(sum(map(int, DBR(files[OUTPUT_RECORD]).get('skillModifierPoints').split(';')[:149])), 307)
        self.assertEqual(len(manifest['player_level_cap_records']), 2)
        self.assertEqual(DBR(files[OUTPUT_RECORD]).get('maxPlayerLevel'), '150')
        for name in PLAYER_RECORDS:
            path = Path('database') / name
            self.assertIn(path, files)
            self.assertIn(path.as_posix(), manifest['files'])
            self.assertEqual(DBR(files[path]).get('maxLevel'), '150')
