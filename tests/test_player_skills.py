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

    def test_sigil_of_consumption_scales_every_radius_rank_and_only_timing(self):
        name = "records/skills/playerclass03/sigilofdestruction1.dbr"
        source = DBR.from_file(resolve(name, gen.REFERENCE))
        result = self.record("playerclass03/sigilofdestruction1.dbr")
        old_radii = list(map(float, source.get("projectileExplosionRadius").split(";")))
        new_radii = list(map(float, result.get("projectileExplosionRadius").split(";")))
        self.assertEqual(len(old_radii), 22)
        self.assertEqual(len(new_radii), len(old_radii))
        for old, new in zip(old_radii, new_radii):
            self.assertAlmostEqual(new, old * 1.15, places=5)
        self.assertEqual(result.get("skillActiveDuration"), "7.200000")
        self.assertEqual(result.get("skillCooldownTime"), "2.700000")
        # The only differences are radius, duration and cooldown.
        expected = DBR.from_file(resolve(name, gen.REFERENCE))
        expected.set("projectileExplosionRadius", result.get("projectileExplosionRadius"))
        expected.set("skillActiveDuration", "7.200000")
        expected.set("skillCooldownTime", "2.700000")
        self.assertEqual(result.render(), expected.render())
        self.assertEqual(result.get("skillManaCost"), source.get("skillManaCost"))
        self.assertEqual(result.get("offensiveLifeLeechMin"), source.get("offensiveLifeLeechMin"))

    def test_sigil_independent_rollback_restores_original(self):
        settings = copy.deepcopy(self.settings)
        entry = next(item for item in settings["records"]
                     if item["record"] == "records/skills/playerclass03/sigilofdestruction1.dbr")
        entry["enabled"] = False
        files, report = build_skills(settings, gen.REFERENCE)
        record_path = Path("database") / entry["record"]
        self.assertEqual(files[record_path],
                         DBR.from_file(resolve(entry["record"], gen.REFERENCE)).render())
        self.assertFalse(next(item["changed"] for item in report if item["record"] == entry["record"]))

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
