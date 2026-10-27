"""Preserve the approved baseline and prove variants require config, not branches."""
import copy
import hashlib
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / 'scripts'))
import generate_variants as gen
from dbr import DBR
from validate_config import check_configs
from test_natural_spawns import catalog


class DataDrivenTests(unittest.TestCase):
    def test_approved_original_boar_six_records_unchanged_with_xp_disabled(self):
        hashes = json.loads((REPO / 'tests/fixtures/boar_veteran_01_baseline.json').read_text())
        families, tiers = catalog()
        tiers["veteran"]["prototype"]["experience_reward"]["enabled"] = False
        files = gen.build_plan([f for f in families if f["id"] == "boar"], tiers, include_spawns=True)
        for path, digest in hashes.items():
            self.assertEqual(hashlib.sha256(files[Path(path)].encode()).hexdigest(), digest, path)

    def test_zombie_starter_keeps_own_bio_and_existing_skills(self):
        families, tiers = catalog(); zombie = next(f for f in families if f['id'] == 'zombie')
        for variant in zombie['variants']:
            files = gen.build_variant(zombie, variant, tiers[variant['tier']])
            monster = DBR(files[gen.game_location(variant['output_record'])])
            original = gen.read_game_dbr(variant['source_record'])
            self.assertEqual(monster.get('monsterClassification'), 'Common')
            self.assertEqual(monster.get('description'), gen.display_tag(zombie, variant))
            self.assertEqual(monster.get('actorRadius'), original.get('actorRadius'))
            self.assertEqual(monster.get('skillName3'), original.get('skillName3'))
            self.assertEqual(monster.get('initialSkillName'), monster.get('skillName4'))
            bio = DBR(files[gen.game_location(monster.get('characterAttributeEquations'))])
            source_bio = gen.read_game_dbr(original.get('characterAttributeEquations'))
            self.assertEqual(bio.get('characterLife'), f"({source_bio.get('characterLife')})*1.3")

    def test_new_family_can_be_generated_by_config_only(self):
        families, tiers = catalog(); family = copy.deepcopy(next(f for f in families if f['id'] == 'zombie'))
        family['id'] = 'configuration_test'
        family['pools'] = []
        for v in family['variants']:
            v['output_record'] = f"records/creatures/enemies/monsterexpansion/configuration_test_{v['id']}.dbr"
        files = gen.build_plan([family], tiers)
        self.assertEqual(len(files), 14)
        self.assertTrue(all('configuration_test' in str(p) for p in files if p.name != 'manifest.json' and p != gen.TEXT_SOURCE))

    def test_tier_aura_disable_applies_to_both_families(self):
        families, tiers = catalog(); tiers['veteran']['prototype']['cosmetic_aura']['enabled'] = False
        files = gen.build_plan([f for f in families if all(v["tier"] == "veteran" for v in f["variants"])], tiers)
        self.assertEqual(len(files), 446)
        self.assertFalse(any('_cosmetic' in str(p) for p in files))

    def test_deterministic_plans_and_no_proxy_or_asset_outputs(self):
        first = gen.configured_plan(include_spawns=True)
        self.assertEqual(first, gen.configured_plan(include_spawns=True))
        self.assertEqual(len(first), 3013)
        for p in first:
            if p.name != 'manifest.json' and p != gen.TEXT_SOURCE:
                self.assertTrue(p.as_posix().startswith('database/records/'))
                self.assertFalse('area001' in str(p) or 'Resources' in str(p))

    def test_colliding_output_sets_rejected(self):
        families, tiers = catalog()
        with self.assertRaises(gen.GenerationError):
            gen.build_plan([families[0], families[0]], tiers)

    def test_invalid_config_share_mapping_and_paths_rejected(self):
        for mutation in ('share', 'slot', 'path', 'variant'):
            with self.subTest(mutation=mutation), tempfile.TemporaryDirectory() as tmp:
                root = Path(tmp); config = root / 'config'; (config / 'families').mkdir(parents=True)
                tiers = json.loads((REPO / 'config/tiers.json').read_text())
                family = json.loads((REPO / 'config/families/boar.json').read_text())
                if mutation == 'share': tiers['tiers'][1]['prototype']['natural_spawns']['common_conversion_share'] = float('nan')
                if mutation == 'slot': family['pools'][0]['promotions'][0]['output_slot'] = 16
                if mutation == 'path': family['variants'][0]['source_record'] = 'records/../bad.dbr'
                if mutation == 'variant': family['pools'][0]['promotions'][0]['variant'] = 'missing'
                (config / 'tiers.json').write_text(json.dumps(tiers))
                (config / 'families/boar.json').write_text(json.dumps(family))
                self.assertTrue(check_configs(repo=root))

    def test_writer_replacement_is_explicit_and_idempotent(self):
        files = gen.configured_plan('boar')
        with tempfile.TemporaryDirectory() as tmp:
            output = Path(tmp) / 'generated/MonsterExpansion'
            with patch.object(gen, 'OUTPUT', output):
                gen.write_staged(files, output); gen.write_staged(files, output)
                changed = dict(files); changed[Path('manifest.json')] = 'changed'
                with self.assertRaises(gen.GenerationError):
                    gen.write_staged(changed, output)
                gen.write_staged(changed, output, overwrite=True)
