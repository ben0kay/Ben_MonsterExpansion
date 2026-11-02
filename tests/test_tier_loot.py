"""Tier-only loot quality bonuses: native weights, rare-affix path isolation and rollback."""
import copy
from decimal import Decimal
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))

from dbr import DBR
from references import resolve
from tier_loot import (
    enhance_monster_loot, validate_settings, _scale_category_weights,
    _private_rare_master, _equipment_quality, AFFIX_RARE, AFFIX_OTHER
)
from test_natural_spawns import catalog
import generate_variants as gen


class TierLootTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.families, cls.tiers = catalog()

    def source_variant(self, tier_id):
        for family in self.families:
            if not family["enabled"]:
                continue
            for variant in family["variants"]:
                if variant["tier"] == tier_id:
                    return family, variant
        self.fail("No representative " + tier_id + " variant")

    def test_config_relative_quality_multipliers_are_exact(self):
        expected = {
            "veteran":(1.15, 1.05, 1.0),
            "elite":(1.30, 1.20, 1.10),
            "ascended":(1.50, 1.30, 1.15),
        }
        for tier, three in expected.items():
            config = self.tiers[tier]["prototype"]["loot_rewards"]
            self.assertTrue(config["enabled"])
            validate_settings(config)
            self.assertEqual(
                tuple(config[k] for k in (
                    "rare_multiplier", "epic_multiplier", "legendary_multiplier")),
                three
            )
        for invalid in (
            {"enabled":True, "rare_multiplier":1.0,
             "epic_multiplier":1.0, "legendary_multiplier":float("nan")},
            {"enabled":True, "rare_multiplier":1.0,
             "epic_multiplier":1.0, "legendary_multiplier":1.0, "extra":1},
            {"enabled":"yes", "rare_multiplier":1,
             "epic_multiplier":1, "legendary_multiplier":1},
        ):
            with self.assertRaises(ValueError):
                validate_settings(invalid)

    def test_relative_weight_math_keeps_denominator_and_unboosted_chance(self):
        boar = gen.read_game_dbr("records/creatures/enemies/boar_a01.dbr")
        original = {f"chanceToEquipMisc2Item{i}":
                    int(boar.get(f"chanceToEquipMisc2Item{i}"))
                    for i in range(1, 7)}
        categories = {
            "chanceToEquipMisc2Item1":"a",
            "chanceToEquipMisc2Item2":"c",
            "chanceToEquipMisc2Item3":"d"
        }
        boosted = _scale_category_weights(
            original, categories,
            {"b":Decimal("1.15"), "c":Decimal("1.05"), "d":Decimal("1")}
        )
        before = sum(original.values())
        after = sum(boosted.values())
        # Epic receives ~5% relative probability (weight quantisation < 1%).
        ep = "chanceToEquipMisc2Item2"
        self.assertAlmostEqual(
            (boosted[ep]/after)/(original[ep]/before), 1.05, delta=0.01
        )
        leg = "chanceToEquipMisc2Item3"
        self.assertAlmostEqual(
            (boosted[leg]/after)/(original[leg]/before), 1.0, delta=0.01
        )
        self.assertEqual(boosted["chanceToEquipMisc2Item4"],
                         original["chanceToEquipMisc2Item4"]*100)

    def test_veteran_beast_uses_private_rare_affix_chain_and_untouched_material(self):
        family = next(f for f in self.families if f["id"] == "boar")
        variant = next(v for v in family["variants"] if v["tier"] == "veteran")
        tier = self.tiers["veteran"]
        files = gen.build_variant(family, variant, tier)
        original = gen.read_game_dbr(variant["source_record"])
        monster = DBR(files[gen.game_location(variant["output_record"])])
        # Ordinary gear inherits private green-affix tables; shared original
        # components, constitution and boar fur MUST NOT change.
        gear = monster.get("lootMisc2Item1")
        self.assertTrue(gear.startswith(
            "records/items/loottables/monsterexpansion/veteran/"))
        self.assertIn(Path("database") / gear, files)
        self.assertEqual(monster.get("lootMisc1Item1"), original.get("lootMisc1Item1"))
        self.assertEqual(monster.get("lootMisc1Item2"), original.get("lootMisc1Item2"))
        self.assertEqual(monster.get("lootMisc2Item4"), original.get("lootMisc2Item4"))
        self.assertEqual(monster.get("chanceToEquipMisc2"),
                         original.get("chanceToEquipMisc2"))
        self.assertEqual(monster.get("monsterClassification"),
                         original.get("monsterClassification"))
        affixes = [DBR(text) for path, text in files.items()
                   if "items/loottables/monsterexpansion" in path.as_posix()
                   and DBR(text)._locations("rarePrefixOnly")]
        self.assertTrue(affixes, "Expected generated rare-affix dynamic tables")
        self.assertTrue(any(sum(int(a.get(k)) for k in AFFIX_RARE) > 0
                            for a in affixes))

    def test_feature_off_restores_exact_parent_loot_data(self):
        for tierid in ("veteran", "elite", "ascended"):
            with self.subTest(tier=tierid):
                family, variant = self.source_variant(tierid)
                config = copy.deepcopy(self.tiers[tierid])
                config["prototype"]["loot_rewards"]["enabled"] = False
                files = gen.build_variant(family, variant, config)
                parent = gen.read_game_dbr(variant["source_record"])
                child = DBR(files[gen.game_location(variant["output_record"])])
                for source_line in parent.lines:
                    field = source_line.split(",", 1)[0]
                    if field.startswith("loot") or field.startswith("chanceToEquip"):
                        if parent._locations(field) and child._locations(field):
                            self.assertEqual(parent.get(field), child.get(field))
                self.assertFalse(any(
                    "items/loottables/monsterexpansion" in p.as_posix()
                    for p in files
                ))

    def test_non_gear_rare_components_not_treated_as_green_equipment(self):
        path = "records/items/loottables/mastertables/mt_comp_rare_a01.dbr"
        self.assertIsNone(_equipment_quality(path, gen.REFERENCE))
        path = "records/items/loottables/mastertables/mt_hu_miscconstitution_b01.dbr"
        self.assertIsNone(_equipment_quality(path, gen.REFERENCE))

    def test_private_rare_master_is_deterministic_and_shared_by_same_tier(self):
        path = "records/items/loottables/mastertables/mt_beast_small_a01.dbr"
        a = _private_rare_master(path, "veteran", "1.15", str(gen.REFERENCE))
        b = _private_rare_master(path, "veteran", "1.15", str(gen.REFERENCE))
        self.assertIsNotNone(a)
        self.assertEqual(a, b)
        target, output = a
        self.assertTrue(target.startswith(
            "records/items/loottables/monsterexpansion/veteran/"))
        self.assertTrue(all("/monsterexpansion/veteran/" in x
                            for x, _ in output))
        self.assertEqual(len(output), len(set(x for x, _ in output)))


if __name__ == "__main__":
    unittest.main()
