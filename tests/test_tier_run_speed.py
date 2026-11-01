"""Permanent per-tier monster movement speed: preserve native variation and rollback."""
import copy
from decimal import Decimal
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))

import generate_variants as gen
from dbr import DBR
from test_natural_spawns import catalog


class TierRunSpeedTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.families, cls.tiers = catalog()

    def representative(self, tier_id):
        for family in self.families:
            if family["enabled"]:
                for variant in family["variants"]:
                    if variant["tier"] == tier_id:
                        return family, variant
        self.fail("Missing configured family with variant tier: " + tier_id)

    def test_configured_three_tiers_have_15_percent_extra_run_speed(self):
        for tier_id in ("veteran", "elite", "ascended"):
            with self.subTest(tier=tier_id):
                family, variant = self.representative(tier_id)
                tier = self.tiers[tier_id]
                self.assertEqual(tier["prototype"]["run_speed_vs_parent"], 1.15)
                original = gen.read_game_dbr(variant["source_record"])
                generated = gen.build_variant(family, variant, tier)
                result = DBR(generated[gen.game_location(variant["output_record"])])
                expected = Decimal(original.get("characterRunSpeed")) * Decimal("1.15")
                self.assertEqual(result.get("characterRunSpeed"), f"{expected:.6f}")
                self.assertEqual(result.get("characterRunSpeedModifier"),
                                 original.get("characterRunSpeedModifier"))
                self.assertEqual(result.get("characterRunSpeedJitter"),
                                 original.get("characterRunSpeedJitter"))
                self.assertEqual(result.get("controller"), original.get("controller"))
                self.assertEqual(result.get("scale"),
                                 f"{Decimal(original.get('scale')) * Decimal('1.2'):.6f}")

    def test_disabling_tier_speed_restores_base_and_changes_no_other_output(self):
        for tier_id in ("veteran", "elite", "ascended"):
            with self.subTest(tier=tier_id):
                family, variant = self.representative(tier_id)
                tier = self.tiers[tier_id]
                boosted = gen.build_variant(family, variant, tier)
                native_tier = copy.deepcopy(tier)
                native_tier["prototype"]["run_speed_vs_parent"] = 1
                restored = gen.build_variant(family, variant, native_tier)
                self.assertEqual(set(boosted), set(restored))
                path = gen.game_location(variant["output_record"])
                before = gen.read_game_dbr(variant["source_record"])
                after = DBR(restored[path])
                self.assertEqual(Decimal(after.get("characterRunSpeed")),
                                 Decimal(before.get("characterRunSpeed")))
                # Inspect only the one allowed difference in the emitted actor
                # and require all support records (bio, damage, rage, FX, AI)
                # to stay identical.
                raised = DBR(boosted[path])
                raised.set("characterRunSpeed", after.get("characterRunSpeed"))
                self.assertEqual(raised.render(), after.render())
                for record in boosted:
                    if record != path:
                        self.assertEqual(boosted[record], restored[record])

    def test_speed_field_can_be_omitted_for_backwards_compatible_parent_speed(self):
        family, variant = self.representative("veteran")
        tier = copy.deepcopy(self.tiers["veteran"])
        del tier["prototype"]["run_speed_vs_parent"]
        result = gen.build_variant(family, variant, tier)
        actor = DBR(result[gen.game_location(variant["output_record"])])
        original = gen.read_game_dbr(variant["source_record"])
        self.assertEqual(Decimal(actor.get("characterRunSpeed")),
                         Decimal(original.get("characterRunSpeed")))


if __name__ == "__main__":
    unittest.main()
