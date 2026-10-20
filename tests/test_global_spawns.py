import json
from pathlib import Path
import sys
import tempfile
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from global_spawns import load_settings, build_global_spawn, OUTPUT_RECORD
from dbr import DBR
import generate_variants as gen


class GlobalSpawnTests(unittest.TestCase):
    def test_only_regular_equations_change_and_disable_restores_exact_source(self):
        source = (gen.REFERENCE / 'proxies/proxypoolequation_01.dbr').read_text()
        settings = {'enabled': True, 'pack_size_multiplier': 1.5}
        expected = source.replace('spawnMaxEquation,poolValue * 1,', 'spawnMaxEquation,poolValue * 1.5,').replace('spawnMinEquation,poolValue * 1,', 'spawnMinEquation,poolValue * 1.5,')
        self.assertEqual(build_global_spawn(settings, gen.REFERENCE), expected)
        settings['enabled'] = False
        self.assertEqual(build_global_spawn(settings, gen.REFERENCE), source)

    def test_invalid_global_values_rejected(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); (root / 'config').mkdir()
            for value in [True, '1.5', 0, -1, float('nan'), float('inf'), 11]:
                (root / 'config/master.json').write_text(json.dumps({'schema_version': 1, 'monster_spawning': {'enabled': True, 'pack_size_multiplier': value}}))
                with self.subTest(value=value), self.assertRaises(ValueError):
                    load_settings(root)

    def test_global_equation_requires_spawn_flag_and_leaves_family_outputs_intact(self):
        ordinary = gen.configured_plan('boar')
        expanded = gen.configured_plan('boar', True)
        self.assertNotIn(OUTPUT_RECORD, ordinary)
        self.assertIn(OUTPUT_RECORD, expanded)
        for path, text in ordinary.items():
            if path.name != 'manifest.json':
                self.assertEqual(expanded[path], text)
