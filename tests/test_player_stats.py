import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from player_stats import load_settings, build_player_stats, RECORD, OUTPUT_RECORD
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
        self.assertEqual(build_player_stats(settings, gen.REFERENCE), expected)
        self.assertIn('maxPlayerLevel,100,', expected)
        self.assertIn('maxDevotionPoints,85,', expected)

    def test_disable_emits_exact_effective_vanilla(self):
        settings = load_settings(gen.REPO); settings['enabled'] = False
        settings['devotion']['enabled'] = False
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

    def test_player_record_is_in_manifest_and_generated_without_spawn_flag(self):
        files = gen.configured_plan('boar')
        self.assertIn(OUTPUT_RECORD, files)
        manifest = json.loads(files[Path('manifest.json')])
        self.assertIn(OUTPUT_RECORD.as_posix(), manifest['files'])
        self.assertEqual(manifest['player_stats']['attribute_points_per_level'], 2)
