"""Pool composition, safe scope, inheritance and rollback for ME3."""
import copy
import hashlib
import json
import sys
import tempfile
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / 'scripts'))
import generate_variants as gen
import prepare_console_test as staging
import natural_spawns as spawns
from dbr import DBR


class NaturalSpawnTests(unittest.TestCase):
    def setUp(self):
        self.family = json.loads((REPO / 'config/families/boar.json').read_text())
        self.tier = next(t for t in json.loads((REPO / 'config/tiers.json').read_text())['tiers']
                         if t['id'] == 'veteran')

    def test_preserves_all_original_fields_and_only_adds_regular_variant(self):
        source = REPO / 'ReferenceFiles/proxies/pools/p_beasts_boar_n.dbr'
        before = hashlib.sha256(source.read_bytes()).hexdigest()
        files = gen.build_variant(self.family, self.tier, include_spawns=True)
        baseline = gen.build_variant(self.family, self.tier)
        path = gen.game_location(spawns.POOL)
        self.assertEqual(set(files) - set(baseline), {path})
        for old in baseline:
            if old != Path('manifest.json'):
                self.assertEqual(files[old], baseline[old])
        pool = DBR(files[path]); original = DBR.from_file(source)
        for line in original.lines:
            key = line.split(',')[0]
            self.assertEqual(pool.get(key), original.get(key))
        self.assertEqual(pool.get('name5'), spawns.MONSTER)
        self.assertEqual(pool.get('weight5'), '25')
        self.assertEqual(pool.get('levelVarianceEquation5'), original.get('levelVarianceEquation1'))
        self.assertEqual(before, hashlib.sha256(source.read_bytes()).hexdigest())
        report = json.loads(files[Path('manifest.json')])['natural_spawns']
        self.assertEqual(report['regular_selection_share'], .2)
        self.assertFalse(report['ratio_verified'])
        self.assertEqual(report['target_veterans_per_champion'], 2.5)
        self.assertFalse(any('area001' in str(p) for p in files))

    def test_disabled_emits_vanilla_pool_for_safe_rollback(self):
        self.family['natural_spawns']['enabled'] = False
        files = gen.build_variant(self.family, self.tier, include_spawns=True)
        self.assertEqual(files[gen.game_location(spawns.POOL)],
                         (REPO / 'ReferenceFiles/proxies/pools/p_beasts_boar_n.dbr').read_text())

    def test_invalid_weights_ratios_and_scopes_rejected(self):
        for key, value in [('regular_pool_weight', -1), ('regular_pool_weight', 100),
                           ('regular_pool_weight', True), ('regular_pool_weight', 2.5),
                           ('target_veterans_per_champion', float('nan'))]:
            tier = copy.deepcopy(self.tier); tier['prototype']['natural_spawns'][key] = value
            with self.subTest(key=key, value=value), self.assertRaises(ValueError):
                gen.build_variant(self.family, tier, include_spawns=True)
        self.family['spawn_pool_record'] = 'records/proxies/pools/unreviewed.dbr'
        with self.assertRaises(ValueError):
            gen.build_variant(self.family, self.tier, include_spawns=True)

    def test_seven_record_staging_and_partial_or_unrelated_sets_rejected(self):
        files = gen.build_variant(self.family, self.tier, include_spawns=True)
        files.pop(Path('manifest.json'))
        self.assertEqual(len(files), 7)
        with tempfile.TemporaryDirectory() as tmp:
            repo = Path(tmp) / 'mods' / staging.MOD_NAME
            repo.mkdir(parents=True)
            staging.stage(files, repo=repo)
            self.assertEqual((repo / gen.game_location(spawns.POOL)).read_text(),
                             files[gen.game_location(spawns.POOL)])
            missing = dict(files); missing.pop(next(p for p in files if p.name.endswith('_cosmetic_fx.dbr')))
            with self.assertRaises(gen.GenerationError):
                staging.stage(missing, repo=repo)
            with self.assertRaises(gen.GenerationError):
                staging.stage({**files, Path('database/records/proxies/unreviewed.dbr'): 'bad'}, repo=repo)
