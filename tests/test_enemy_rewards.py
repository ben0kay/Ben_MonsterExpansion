"""XP term scaling, rollback and catalog-wide isolation from every other generated field."""
import copy
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path
import sys
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from dbr import DBR
from enemy_rewards import scaled_experience_points, validate_settings
import generate_variants as gen
from test_natural_spawns import catalog


class EnemyRewardTests(unittest.TestCase):
    def test_scales_xp_formula_term_and_rounds_to_integer(self):
        self.assertEqual(scaled_experience_points('30', 1.3), '69')
        self.assertEqual(scaled_experience_points('750', 1.4), '1090')
        self.assertEqual(scaled_experience_points('0', 1.3), '30')
        self.assertEqual(scaled_experience_points('5', 1.3), '37')
        self.assertEqual(scaled_experience_points('30', 1), '30')

    def test_invalid_values_rejected(self):
        for raw, factor in [('1.5', 1.3), ('-1', 1.3), ('', 1.3), ('30', float('nan')), ('30', 0.9), ('2147483647', 1.4)]:
            with self.subTest(raw=raw, factor=factor), self.assertRaises(ValueError):
                scaled_experience_points(raw, factor)
        for settings in [{'enabled': 'yes'}, {'enabled': True, 'unknown': 1}, []]:
            with self.assertRaises(ValueError): validate_settings(settings)

    def test_all_409_variants_change_only_xp_and_preserve_reward_flags(self):
        families, tiers = catalog()
        count = 0
        for family in families:
            if not family['enabled']: continue
            for variant in family['variants']:
                tier = tiers[variant['tier']]
                enabled = gen.build_variant(family, variant, tier)
                disabled_tier = copy.deepcopy(tier)
                disabled_tier['prototype']['experience_reward']['enabled'] = False
                disabled = gen.build_variant(family, variant, disabled_tier)
                monster_path = gen.game_location(variant['output_record'])
                parent = gen.read_game_dbr(variant['source_record'])
                output = DBR(enabled[monster_path])
                expected = ((Decimal(parent.get('experiencePoints')) + 100) * Decimal(str(tier['prototype']['stats_vs_parent']['health'])) - 100).quantize(Decimal(1), rounding=ROUND_HALF_UP)
                self.assertEqual(output.get('experiencePoints'), str(int(expected)))
                self.assertEqual(output.get('giveXP'), parent.get('giveXP'))
                output.set('experiencePoints', parent.get('experiencePoints'))
                enabled[monster_path] = output.render()
                self.assertEqual(enabled, disabled, variant['id'])
                count += 1
        self.assertEqual(count, 409)
