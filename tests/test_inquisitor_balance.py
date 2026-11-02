"""Inquisitor first-pass balance: native field safety, rank preservation and rollback."""
import copy
import math
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))

from dbr import DBR
from player_skills import load_settings, build_skills
from references import resolve
import generate_variants as gen


BASE = "records/skills/playerclass07/"
NAMES = (
    "wpattack01", "wpattack02", "wpattack03", "passive01", "passive02",
    "wordofpain1_buff", "wordofpain2", "wordofpain3", "lightningnet2",
    "icerune", "concussiverune1", "arcaneseal1", "purifyingflame1",
    "auracensure1_buff",
)


class InquisitorBalanceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.settings = load_settings(gen.REPO)
        cls.files, cls.report = build_skills(cls.settings, gen.REFERENCE)
        cls.entries = {e["record"]: e for e in cls.settings["records"]}

    def path(self, short):
        return BASE + short + ".dbr"

    def record(self, short):
        return DBR(self.files[Path("database") / self.path(short)])

    def native(self, short):
        return DBR.from_file(resolve(self.path(short), gen.REFERENCE))

    def test_fourteen_inquisitor_records_and_only_explicit_dbr_fields_change(self):
        for short in NAMES:
            with self.subTest(skill=short):
                name = self.path(short)
                self.assertIn(name, self.entries)
                entry = self.entries[name]
                self.assertTrue(entry.get("enabled", True))
                self.assertTrue(entry["set"] or entry["curves"])
                original = self.native(short)
                output = self.record(short)
                expected = self.native(short)
                touched = set(entry["set"]) | set(entry["curves"])
                self.assertFalse(set(entry["set"]) & set(entry["curves"]))
                for field in touched:
                    self.assertTrue(original._locations(field), name + ":" + field)
                    expected.set(field, output.get(field))
                self.assertEqual(output.render(), expected.render())
                for field in entry["curves"]:
                    native_ranks = original.get(field).split(";")
                    modified_ranks = output.get(field).split(";")
                    self.assertEqual(len(native_ranks), len(modified_ranks))
                    factor = entry["curves"][field]["multiplier"]
                    for old, new in zip(native_ranks, modified_ranks):
                        self.assertTrue(math.isclose(float(new), float(old)*factor,
                                                     abs_tol=0.00001))

    def test_storm_spread_adds_one_projectile_at_every_native_rank(self):
        before = list(map(int, self.native("wpattack03").get("projectileLaunchNumber").split(";")))
        after = list(map(int, self.record("wpattack03").get("projectileLaunchNumber").split(";")))
        self.assertEqual(before, [3]*6 + [4]*14)
        self.assertEqual(after, [4]*6 + [5]*14)
        self.assertEqual(len(after), 20)
        for field in ("projectileLaunchRotation", "weaponDamagePct"):
            self.assertEqual(self.record("wpattack03").get(field),
                             self.native("wpattack03").get(field))

    def test_runes_seal_cone_tether_and_word_of_pain_values(self):
        for skill in ("icerune", "concussiverune1"):
            with self.subTest(skill=skill):
                self.assertEqual(self.native(skill).get("petLimit"), "5")
                self.assertEqual(self.record(skill).get("petLimit"), "6")
                self.assertEqual(self.record(skill).get("skillCooldownTime"), "3.600000")
                self.assertEqual(self.native(skill).get("skillCooldownTime"), "4.000000")
        self.assertEqual(self.record("arcaneseal1").get("spawnObjectsTimeToLive"), "28.000000")
        self.assertEqual(self.record("arcaneseal1").get("skillCooldownTime"), "4.500000")
        self.assertEqual(self.record("lightningnet2").get("maxRange"), "19.800000")
        self.assertEqual(self.record("purifyingflame1").get("maxRange"), "10.010000")
        self.assertEqual(self.record("wordofpain1_buff").get("skillActiveDuration"), "9.200000")
        self.assertEqual(self.record("wordofpain1_buff").get("skillTargetRadius"), "3.300000")
        # Keep the previous non-exclusive Inquisitor aura behavior intact.
        self.assertEqual(self.record("auracensure1_buff").get("exclusiveSkill"), "0")
        self.assertEqual(self.record("auraconviction1_buff").get("exclusiveSkill"), "0")

    def test_every_inquisitor_change_can_roll_back_independently(self):
        for short in NAMES:
            with self.subTest(skill=short):
                name = self.path(short)
                settings = copy.deepcopy(self.settings)
                next(e for e in settings["records"] if e["record"] == name)["enabled"] = False
                rolled, _ = build_skills(settings, gen.REFERENCE)
                key = Path("database") / name
                self.assertEqual(rolled[key], self.native(short).render())
                for other in NAMES:
                    if other != short:
                        self.assertEqual(rolled[Path("database") / self.path(other)],
                                         self.files[Path("database") / self.path(other)])

    def test_previous_non_inquisitor_skills_preserved_by_this_pass(self):
        # The main config contains other mastery edits; ensure the new pass
        # does not depend on, or rewrite, their existing override settings.
        for e in self.settings["records"]:
            if not e["record"].startswith(BASE):
                self.assertIn(Path("database") / e["record"], self.files)


if __name__ == "__main__":
    unittest.main()
