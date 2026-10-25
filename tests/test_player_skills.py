import copy
from pathlib import Path
import sys
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from player_skills import build_skills, load_settings
from references import resolve, records
from dbr import DBR
import generate_variants as gen

class PlayerSkillTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.settings = load_settings(gen.REPO)
        cls.files, _ = build_skills(cls.settings, gen.REFERENCE)

    def record(self, name):
        return DBR(self.files[Path("database/records/skills") / name])

    def test_all_uploaded_mastery_exclusives_removed(self):
        for name in records(gen.REFERENCE, "skills"):
            if "/playerclass" in name and "exclusiveSkill,1," in resolve(name, gen.REFERENCE).read_text():
                self.assertEqual(DBR(self.files[Path("database")/name]).get("exclusiveSkill"), "0")

    def test_pet_rank_milestone_and_health(self):
        for pet in ("raven", "hellhound"):
            limit = self.record(f"playerclass03/summon_{pet}1.dbr").get("petLimit").split(";")
            self.assertEqual(limit[:7], ["1"]*7)
            self.assertEqual(limit[7:], ["2"]*19)
            for rank in (1, 8, 26):
                self.assertEqual(float(self.record(f"playerclass03/pets/pet_{pet}_a{rank:02}.dbr").get("characterLifeModifier")), 10+2*(rank-1))

    def test_damage_curve_scales_more_with_investment(self):
        name = "records/skills/playerclass05/aetherray1.dbr"
        source = DBR.from_file(resolve(name, gen.REFERENCE))
        result = DBR(self.files[Path("database")/name])
        a = list(map(float, source.get("offensiveAetherMin").split(";")))
        b = list(map(float, result.get("offensiveAetherMin").split(";")))
        self.assertAlmostEqual(b[0]/a[0], 1.15)
        self.assertAlmostEqual(b[-1]/a[-1], 1.525)
        self.assertEqual(len(a), len(b))

    def test_toggles_are_bounded_and_heal_not_repeated(self):
        mirror = self.record("playerclass05/arcaneshield.dbr")
        self.assertEqual(mirror.get("Class"), "Skill_BuffSelfToggled")
        self.assertLessEqual(max(map(float, mirror.get("damageAbsorptionPercent").split(";"))),20)
        self.assertEqual(self.record("playerclass03/bloodofdreeg1_buff.dbr").get("skillLifePercent"), "0")

    def test_disable_restores_exact_sources(self):
        settings = copy.deepcopy(self.settings)
        settings["enabled"] = False
        files, report = build_skills(settings, gen.REFERENCE)
        self.assertTrue(all(not item["changed"] for item in report))
        for entry in settings["records"]:
            self.assertEqual(files[Path("database")/entry["record"]], DBR.from_file(resolve(entry["record"], gen.REFERENCE)).render())

    def test_missing_fields_rejected(self):
        settings = copy.deepcopy(self.settings)
        settings["records"][0]["set"]["inventedSkillField"] = "1"
        with self.assertRaises(ValueError):
            build_skills(settings, gen.REFERENCE)

if __name__ == "__main__":
    unittest.main()
