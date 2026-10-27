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
        self.assertEqual(build_player_stats(settings, gen.REFERENCE), expected)
        self.assertIn('maxPlayerLevel,150,', expected)
        self.assertIn('maxDevotionPoints,85,', expected)
        self.assertEqual(settings['attribute_points_per_level'], 2)
        awards = DBR(expected).get('skillModifierPoints').split(';')
        native_awards = DBR(source).get('skillModifierPoints').split(';')
        self.assertEqual(awards, native_awards)
        self.assertGreaterEqual(len(awards), 149)
        self.assertEqual(awards[149], '1')

    def test_disable_emits_exact_effective_vanilla(self):
        settings = load_settings(gen.REPO); settings['enabled'] = False
        settings['devotion']['enabled'] = False
        settings['level_cap']['enabled'] = False
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
        self.assertEqual(len(manifest['player_level_cap_records']), 2)
        self.assertEqual(DBR(files[OUTPUT_RECORD]).get('maxPlayerLevel'), '150')
        for name in PLAYER_RECORDS:
            path = Path('database') / name
            self.assertIn(path, files)
            self.assertIn(path.as_posix(), manifest['files'])
            self.assertEqual(DBR(files[path]).get('maxLevel'), '150')
