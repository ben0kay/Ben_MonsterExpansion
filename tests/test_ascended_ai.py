"""AI1 focused tests: exact two-variant native AI controller cloning."""
import copy
import json
import sys
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "scripts"))
import generate_variants as gen
from dbr import DBR


class AscendedAITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.family = json.loads(
            (REPO / "config/families/discovered_ascended.json").read_text(encoding="utf-8"))
        tiers = json.loads((REPO / "config/tiers.json").read_text(encoding="utf-8"))["tiers"]
        cls.ascended = next(t for t in tiers if t["id"] == "ascended")
        cls.ai = cls.ascended["prototype"]["smart_ai"]

    def variant(self, name):
        return next(v for v in self.family["variants"]
                    if Path(v["source_record"]).stem == name)

    def test_prototype_profiles_and_native_source_mapping(self):
        targets = {stem for p in self.ai["profiles"].values()
                   for stem in p["hero_stems"]}
        self.assertTrue(self.ai["enabled"])
        self.assertEqual(targets, {"boar_h01", "gazer_h01"})
        self.assertEqual(self.ai["profiles"]["support"]["hero_stems"], [])
        self.assertEqual(self.ai["profiles"]["support"]["adjustments"], {})
        self.assertEqual(gen.smart_ai_profile(
            self.variant("boar_h01")["source_record"], self.ai), "aggressive")
        self.assertEqual(gen.smart_ai_profile(
            self.variant("gazer_h01")["source_record"], self.ai), "evasive")
        self.assertIsNone(gen.smart_ai_profile(
            self.variant("boar_h02")["source_record"], self.ai))

    def assert_controller_clone(self, stem, role, expected):
        v = self.variant(stem)
        original_monster = gen.read_game_dbr(v["source_record"])
        original_path = original_monster.get("controller")
        original_controller = gen.read_game_dbr(original_path)
        original_content = original_controller.render()
        files = gen.build_variant(self.family, v, self.ascended)
        monster = DBR(files[gen.game_location(v["output_record"])])
        prefix = self.family["id"] + "_" + v["id"]
        cloned_path = (f"records/controllers/enemy/monsterexpansion/"
                       f"{prefix}_ai.dbr")
        self.assertEqual(monster.get("controller"), cloned_path)
        self.assertIn(gen.game_location(cloned_path), files)
        self.assertNotIn(gen.game_location(original_path), files)
        controller = DBR(files[gen.game_location(cloned_path)])
        self.assertEqual(controller.get("templateName"),
                         "database/templates/controllermonster.tpl")
        self.assertEqual(controller.get("Class"), "ControllerMonster")
        self.assertIn("MonsterExpansion AI1 " + role,
                      controller.get("FileDescription"))
        self.assertEqual(original_controller.render(), original_content)
        # Every other source controller property survives exactly unchanged.
        for line in original_content.splitlines():
            key = line.split(",", 1)[0]
            if key not in expected and key != "FileDescription":
                self.assertEqual(controller.get(key), original_controller.get(key),
                                 "AI1 unexpectedly changed native field " + key)
        for key, value in expected.items():
            self.assertEqual(controller.get(key), value)
        self.assertEqual(monster.get("monsterClassification"), "Hero")
        # The whole existing skill roster, including the Hero's native combat
        # skills, stays put (only the mod's existing damage override differs).
        for i in range(1, 61):
            field = f"skillName{i}"
            if original_monster._locations(field):
                original_skill = original_monster.get(field)
                if original_skill != v["damage_skill_source_record"]:
                    self.assertEqual(monster.get(field), original_skill)
        self.assertIn(gen.game_location(
            f"records/skills/nonplayerskills/monsterexpansion/"
            f"{prefix}_rage.dbr"), files)
        return files

    def test_aggressive_boar_improves_pursuit_and_ally_response(self):
        files = self.assert_controller_clone(
            "boar_h01", "aggressive",
            {"MaxPursuitDistance": "85.000000",
             "ChanceToRespondToDistressCall": "85"})
        actor = DBR(files[gen.game_location(self.variant("boar_h01")["output_record"])])
        self.assertEqual(actor.get("monsterClassification"), "Hero")

    def test_evasive_gazer_improves_reposition_not_dodge(self):
        self.assert_controller_clone(
            "gazer_h01", "evasive",
            {"RepositionChance": "55", "randomRepositionChance": "25"})

    def test_unselected_variants_preserve_their_own_controller(self):
        for stem in ("boar_h02", "gazer_h02"):
            with self.subTest(stem=stem):
                v = self.variant(stem)
                source = gen.read_game_dbr(v["source_record"])
                files = gen.build_variant(self.family, v, self.ascended)
                actor = DBR(files[gen.game_location(v["output_record"])])
                self.assertEqual(actor.get("controller"), source.get("controller"))
                self.assertFalse(any(p.name.endswith("_ai.dbr") for p in files))

    def test_off_switch_preserves_original_ai_and_other_mechanics(self):
        tier = copy.deepcopy(self.ascended)
        tier["prototype"]["smart_ai"]["enabled"] = False
        v = self.variant("boar_h01")
        source = gen.read_game_dbr(v["source_record"])
        files = gen.build_variant(self.family, v, tier)
        actor = DBR(files[gen.game_location(v["output_record"])])
        self.assertEqual(actor.get("controller"), source.get("controller"))
        self.assertFalse(any(p.name.endswith("_ai.dbr") for p in files))
        self.assertTrue(any(p.name.endswith("_rage.dbr") for p in files))
        self.assertTrue(any(p.name.endswith("_retaliation.dbr") for p in files))

    def test_unsafe_controller_delta_is_rejected(self):
        tier = copy.deepcopy(self.ascended)
        tier["prototype"]["smart_ai"]["profiles"]["evasive"]["adjustments"][
            "RepositionChance"] = 1000
        monster = gen.read_game_dbr(self.variant("gazer_h01")["source_record"])
        original = monster.render()
        with self.assertRaises(gen.GenerationError):
            gen.build_smart_ai_controller(
                monster, tier["prototype"], self.variant("gazer_h01")["source_record"],
                "invalid_test")
        self.assertEqual(monster.render(), original)

    def test_manifest_reports_only_prototype_targets(self):
        chosen = copy.deepcopy(self.family)
        chosen["variants"] = [self.variant("boar_h01"),
                              self.variant("gazer_h01"),
                              self.variant("boar_h02")]
        chosen["pools"] = []
        tier_by_id = {self.ascended["id"]: self.ascended}
        files = gen.build_plan([chosen], tier_by_id, include_spawns=False)
        report = json.loads(files[Path("manifest.json")])["ai_coverage"]["ascended"]
        self.assertEqual(report["mapped"], 2)
        self.assertEqual(report["attached"], 2)
        self.assertEqual(report["unmapped"], 1)
        self.assertEqual(report["by_profile"], {"aggressive": 1, "evasive": 1})


if __name__ == "__main__":
    unittest.main()
