"""Focused TM2 Ascended on-hit elemental counterattack tests (no native compile)."""
import copy
import json
import sys
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "scripts"))
import generate_variants as gen
from dbr import DBR


class ElementalRetaliationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.family = json.loads((REPO / "config/families/discovered_ascended.json").read_text())
        tiers = json.loads((REPO / "config/tiers.json").read_text())["tiers"]
        cls.ascended = next(t for t in tiers if t["id"] == "ascended")
        cls.config = cls.ascended["prototype"]["elemental_retaliation"]

    def variant(self, stem):
        return next(v for v in self.family["variants"]
                    if Path(v["source_record"]).stem == stem)

    def assert_counterattack(self, stem, element):
        variant = self.variant(stem)
        files = gen.build_variant(self.family, variant, self.ascended)
        actor = DBR(files[gen.game_location(variant["output_record"])])
        prefix = self.family["id"] + "_" + variant["id"]
        path = ("records/skills/nonplayerskills/monsterexpansion/"
                + prefix + "_retaliation.dbr")
        skill = DBR(files[gen.game_location(path)])
        self.assertEqual(skill.get("templateName"),
                         "database/templates/skill_onhitattackradius.tpl")
        self.assertEqual(skill.get("Class"), "Skill_OnHitAttackRadius")
        self.assertEqual(skill.get("onHitActivationChance"), "15.000000")
        self.assertEqual(skill.get("skillCooldownTime"), "8.000000")
        self.assertEqual(skill.get("skillTargetRadius"), "3.000000")
        self.assertEqual(skill.get("radiusEffectName"),
                         self.config["profiles"][element]["radius_effect_record"])
        self.assertIn(path, [actor.get(f"skillName{i}") for i in range(1, 61)
                              if actor._locations(f"skillName{i}")])
        self.assertIn("charLevel/4+1",
                      [actor.get(f"skillLevel{i}") for i in range(1, 61)
                       if actor._locations(f"skillLevel{i}")])
        original = gen.read_game_dbr(variant["source_record"])
        self.assertEqual(actor.get("monsterClassification"), "Hero")
        for i in range(1, 61):
            key = f"skillName{i}"
            if original._locations(key) and original.get(key) != variant["damage_skill_source_record"]:
                self.assertEqual(actor.get(key), original.get(key))
        self.assertIn(gen.game_location(
            "records/skills/nonplayerskills/monsterexpansion/" + prefix + "_rage.dbr"), files)
        return skill

    def test_each_profile_produces_distinct_element_and_native_fx(self):
        for stem, element in (("aetherialcolossus_h01", "aether"),
                              ("prawn_h01", "poison"),
                              ("rifthound_h01", "fire"),
                              ("yeti_h01", "cold"),
                              ("gazer_h01", "lightning"),
                              ("thornedhorror_h01", "chaos")):
            with self.subTest(element=element):
                skill = self.assert_counterattack(stem, element)
                native_field = gen.RETALIATION_DAMAGE_FIELDS[element]
                damage = skill.get(native_field)
                self.assertGreater(len(damage.split(";")), 20)
                self.assertGreater(float(damage.split(";")[0]), 0)
                if element not in ("aether", "poison"):
                    self.assertEqual(skill.get("offensiveAetherMin"), "0.000000")

    def test_unmapped_preserved_and_no_unwanted_retaliation(self):
        v = self.variant("boar_h01")
        files = gen.build_variant(self.family, v, self.ascended)
        self.assertFalse(any(p.name.endswith("_retaliation.dbr") for p in files))
        self.assertTrue(any(p.name.endswith("_rage.dbr") for p in files))

    def test_off_switch_keeps_rage(self):
        tier = copy.deepcopy(self.ascended)
        tier["prototype"]["elemental_retaliation"]["enabled"] = False
        v = self.variant("gazer_h01")
        files = gen.build_variant(self.family, v, tier)
        self.assertFalse(any(p.name.endswith("_retaliation.dbr") for p in files))
        self.assertTrue(any(p.name.endswith("_rage.dbr") for p in files))

    def test_existing_onhit_skips_without_overwriting(self):
        monster = gen.read_game_dbr("records/creatures/enemies/hero/prawn_h01.dbr")
        gen.set_or_append(monster, "skillName60",
                          "records/skills/nonplayerskills/passivelyactivated/prawn_poisonnova_onhit01.dbr")
        gen.set_or_append(monster, "skillLevel60", "1")
        original = monster.render()
        result = gen.build_elemental_retaliation(
            monster, self.ascended["prototype"], "records/creatures/enemies/hero/prawn_h01.dbr",
            "test_onhit")
        self.assertEqual(result, {})
        self.assertEqual(monster.render(), original)


if __name__ == "__main__":
    unittest.main()
