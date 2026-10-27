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


    def test_nightblade_balance_rank_curves_and_exact_record_diffs(self):
        entries = [entry for entry in self.settings["records"]
                   if entry["record"].startswith("records/skills/playerclass04/")]
        self.assertEqual(len(entries), 18)
        for entry in entries:
            name = entry["record"]
            source = DBR.from_file(resolve(name, gen.REFERENCE))
            updated = DBR(self.files[Path("database") / name])
            with self.subTest(record=name):
                baseline = DBR.from_file(resolve(name, gen.REFERENCE))
                changed = set(entry["set"]) | set(entry["curves"])
                for field in changed:
                    baseline.set(field, updated.get(field))
                self.assertEqual(updated.render(), baseline.render())
                for field, rule in entry["curves"].items():
                    original = [float(x) for x in source.get(field).split(";")]
                    new = [float(x) for x in updated.get(field).split(";")]
                    self.assertEqual(len(original), len(new))
                    for old, actual in zip(original, new):
                        self.assertAlmostEqual(actual, old * rule["multiplier"], places=5)
                # None of the existing Nightblade records marked as exclusive
                # may be made exclusive by this pass.
                if source._locations("exclusiveSkill"):
                    self.assertEqual(updated.get("exclusiveSkill"), "0")

    def test_amarastas_blade_burst_preserves_native_rank_curves(self):
        name = "records/skills/playerclass04/eviscerate1.dbr"
        source = DBR.from_file(resolve(name, gen.REFERENCE))
        improved = self.record("playerclass04/eviscerate1.dbr")
        self.assertEqual(source.get("skillCooldownTime"), "1.800000")
        self.assertEqual(improved.get("skillCooldownTime"), "1.500000")
        for field, factor in (
            ("offensiveColdMin", 1.15),
            ("offensiveColdMax", 1.15),
            ("offensiveSlowColdMin", 1.15),
            ("skillTargetRadius", 1.20),
        ):
            original = list(map(float, source.get(field).split(";")))
            updated = list(map(float, improved.get(field).split(";")))
            self.assertEqual(len(original), 26, field)
            self.assertEqual(len(updated), len(original), field)
            for old, new in zip(original, updated):
                self.assertAlmostEqual(new, old * factor, places=5)
        self.assertAlmostEqual(
            float(improved.get("skillTargetRadius").split(";")[0]), 3.6)
        self.assertAlmostEqual(
            float(improved.get("skillTargetRadius").split(";")[-1]), 6.6)
        for unchanged in ("weaponDamagePct", "offensiveFreezeChance",
                          "skillManaCost", "skillMaxLevel", "skillUltimateLevel"):
            self.assertEqual(improved.get(unchanged), source.get(unchanged))

        settings = copy.deepcopy(self.settings)
        next(entry for entry in settings["records"] if entry["record"] == name)["enabled"] = False
        files, report = build_skills(settings, gen.REFERENCE)
        self.assertEqual(files[Path("database") / name], source.render())
        self.assertFalse(next(entry["changed"] for entry in report
                              if entry["record"] == name))

    def test_nightblade_specific_radius_cooldown_pets_and_rollback(self):
        ring = self.record("playerclass04/ringofsteel.dbr")
        self.assertAlmostEqual(float(ring.get("skillTargetRadius")), 5.4)
        strike = self.record("playerclass04/shadowstrike.dbr")
        self.assertAlmostEqual(float(strike.get("skillCooldownTime")), 2.975)
        pneumatic = self.record("playerclass04/nightbladeenchant1.dbr")
        self.assertAlmostEqual(float(pneumatic.get("skillActiveDuration")), 72)
        veil = self.record("playerclass04/veilofshadows1_buff.dbr")
        radii = list(map(float, veil.get("skillTargetRadius").split(";")))
        self.assertAlmostEqual(radii[0], 3.6)
        self.assertAlmostEqual(radii[-1], 9.0)
        trap = self.record("playerclass04/bladetrap1_buff.dbr")
        source_trap = DBR.from_file(resolve(
            "records/skills/playerclass04/bladetrap1_buff.dbr", gen.REFERENCE))
        for field, factor in (("projectileExplosionRadius", 1.20),
                              ("skillActiveDuration", 1.15)):
            src = list(map(float, source_trap.get(field).split(";")))
            new = list(map(float, trap.get(field).split(";")))
            self.assertEqual(len(src), len(new))
            for old, actual in zip(src, new):
                self.assertAlmostEqual(actual, old * factor, places=5)

        spirit = self.record("playerclass04/summon_bladespirit.dbr")
        limits = list(map(int, spirit.get("petLimit").split(";")))
        burst = list(map(int, spirit.get("petBurstSpawn").split(";")))
        self.assertEqual(limits, [2]*15 + [4]*8 + [5]*3)
        self.assertEqual(burst, limits)

        for name in ("summon_bladespirit",
                     "pets/petskill_bladeswarm_bladeaura1",
                     "pets/petskill_showerofblades1"):
            record = "records/skills/playerclass04/" + name + ".dbr"
            settings = copy.deepcopy(self.settings)
            entry = next(x for x in settings["records"] if x["record"] == record)
            entry["enabled"] = False
            output, report = build_skills(settings, gen.REFERENCE)
            self.assertEqual(output[Path("database") / record],
                             DBR.from_file(resolve(record, gen.REFERENCE)).render())
            self.assertFalse(next(x["changed"] for x in report if x["record"] == record))

    def test_arcanist_second_pass_is_moderate_and_preserves_original_rank_curves(self):
        names = {
            "passive01", "passive02", "passive03", "passive04",
            "elementalinfusion1_buff", "elementalinfusion2", "elementalinfusion3",
            "arcanemissile", "arcanemissile2", "arcanemissile3", "arcanemissile4",
            "skyshard1", "skyshard2", "skyshard3",
            "razorwind1", "razorwind2", "chillingsurge_buff", "chillingsurge2",
        }
        entries = [entry for entry in self.settings["records"]
                   if entry["record"].rsplit("/", 1)[-1].removesuffix(".dbr") in names
                   and "/playerclass05/" in entry["record"]]
        self.assertEqual(len(entries), 18)
        for entry in entries:
            name = entry["record"]
            original = DBR.from_file(resolve(name, gen.REFERENCE))
            updated = DBR(self.files[Path("database") / name])
            changed = set(entry.get("curves", {})) | set(entry.get("set", {}))
            self.assertTrue(changed, name)
            with self.subTest(record=name):
                # The rest of the record must remain byte-for-byte the same.
                baseline = DBR.from_file(resolve(name, gen.REFERENCE))
                for key in changed:
                    baseline.set(key, updated.get(key))
                self.assertEqual(baseline.render(), updated.render())
                for field, rule in entry.get("curves", {}).items():
                    source = list(map(float, original.get(field).split(";")))
                    output = list(map(float, updated.get(field).split(";")))
                    self.assertEqual(len(source), len(output), (name, field))
                    factor = rule["multiplier"]
                    self.assertGreaterEqual(factor, 1.05)
                    self.assertLessEqual(factor, 1.10)
                    for old, new in zip(source, output):
                        self.assertAlmostEqual(new, old * factor, places=5)

    def test_panetti_main_missile_fragment_counts_by_rank(self):
        missile = self.record("playerclass05/arcanemissile.dbr")
        minimum = list(map(int, missile.get("projectileFragmentsLaunchNumberMin").split(";")))
        maximum = list(map(int, missile.get("projectileFragmentsLaunchNumberMax").split(";")))
        self.assertEqual(minimum, [5] * 26)
        self.assertEqual(maximum, [5] * 3 + [6] * 8 + [7] * 15)
        self.assertTrue(all(low <= high for low, high in zip(minimum, maximum)))
        self.assertEqual(missile.get("skillProjectileNumber"), "1")

        # These counts belong to the base missile, not Proliferation's
        # separate Aether fragmentation modifier.
        modifier_name = "records/skills/playerclass05/arcanemissile4.dbr"
        original = DBR.from_file(resolve(modifier_name, gen.REFERENCE))
        modifier = self.record("playerclass05/arcanemissile4.dbr")
        for field in ("projectileFragmentsLaunchNumberMin",
                      "projectileFragmentsLaunchNumberMax"):
            self.assertEqual(modifier.get(field), original.get(field))

    def test_panetti_missile_fragment_rollback_restores_vanilla(self):
        settings = copy.deepcopy(self.settings)
        name = "records/skills/playerclass05/arcanemissile.dbr"
        entry = next(x for x in settings["records"] if x["record"] == name)
        entry["enabled"] = False
        files, report = build_skills(settings, gen.REFERENCE)
        self.assertEqual(files[Path("database") / name],
                         DBR.from_file(resolve(name, gen.REFERENCE)).render())
        self.assertFalse(next(x["changed"] for x in report if x["record"] == name))

    def test_arcanist_offensive_coverage_and_cooldown_are_bounded(self):
        for name, field, base_first, base_last, factor in (
            ("skyshard1", "projectileExplosionRadius", 1.4, 3.3, 1.10),
            ("razorwind1", "skillTargetRadius", 4.2, 5.8, 1.10),
            ("chillingsurge_buff", "skillTargetRadius", 5.0, 18.0, 1.08),
        ):
            record = self.record(f"playerclass05/{name}.dbr")
            values = list(map(float, record.get(field).split(";")))
            self.assertAlmostEqual(values[0], base_first * factor)
            self.assertAlmostEqual(values[-1], base_last * factor)
        sky = self.record("playerclass05/skyshard1.dbr")
        self.assertEqual(sky.get("skillCooldownTime"), "2.850000")
        self.assertEqual(
            self.record("playerclass05/chillingsurge_buff.dbr").get("skillCooldownTime"),
            DBR.from_file(resolve("records/skills/playerclass05/chillingsurge_buff.dbr",
                                  gen.REFERENCE)).get("skillCooldownTime"))

    def test_arcanist_second_pass_record_disable_is_exact_rollback(self):
        settings = copy.deepcopy(self.settings)
        targets = {"records/skills/playerclass05/passive01.dbr",
                   "records/skills/playerclass05/skyshard1.dbr"}
        for entry in settings["records"]:
            if entry["record"] in targets:
                entry["enabled"] = False
        files, report = build_skills(settings, gen.REFERENCE)
        for name in targets:
            self.assertEqual(files[Path("database") / name],
                             DBR.from_file(resolve(name, gen.REFERENCE)).render())
            self.assertFalse(next(x["changed"] for x in report if x["record"] == name))


    def test_occultist_offensive_passive_pass_has_exact_record_field_diffs(self):
        names = {
            "curse1_buff", "curse2", "pox1_buff", "pox2", "pox3",
            "evileye1", "evileye1b", "evileye2", "evileye3", "evileye4",
            "sigilofdestruction2", "witchfire1", "witchfire2",
            "bloodofdreeg2", "bondsofbysmiel1_petbonus",
            "bondsofbysmiel2_petbonus", "possession1",
        }
        entries = [entry for entry in self.settings["records"]
                   if entry["record"].startswith("records/skills/playerclass03/")
                   and entry["record"].rsplit("/", 1)[-1].removesuffix(".dbr") in names]
        self.assertEqual(len(entries), 17)  # 16 new records + existing Possession
        for entry in entries:
            name = entry["record"]
            source = DBR.from_file(resolve(name, gen.REFERENCE))
            new = DBR(self.files[Path("database") / name])
            changed = set(entry.get("set", {})) | set(entry.get("curves", {}))
            with self.subTest(record=name):
                expected = DBR.from_file(resolve(name, gen.REFERENCE))
                for key in changed:
                    expected.set(key, new.get(key))
                self.assertEqual(new.render(), expected.render())
                for field, rule in entry.get("curves", {}).items():
                    original = list(map(float, source.get(field).split(";")))
                    output = list(map(float, new.get(field).split(";")))
                    self.assertEqual(len(output), len(original), field)
                    self.assertGreaterEqual(rule["multiplier"], 1.05)
                    self.assertLessEqual(rule["multiplier"], 1.10)
                    for before, after in zip(original, output):
                        self.assertAlmostEqual(after, before * rule["multiplier"], places=5)
        self.assertEqual(self.record("playerclass03/possession1.dbr").get("exclusiveSkill"), "0")

    def test_occultist_skill_coverage_duration_cooldowns_and_fragments(self):
        curse = self.record("playerclass03/curse1_buff.dbr")
        self.assertAlmostEqual(float(curse.get("skillTargetRadius").split(";")[0]), 3.3)
        self.assertAlmostEqual(float(curse.get("skillTargetRadius").split(";")[15]), 12.98)
        self.assertAlmostEqual(float(curse.get("skillActiveDuration").split(";")[0]), 5.5)
        self.assertEqual(self.record("playerclass03/pox1_buff.dbr").get("skillActiveDuration"), "5.500000")
        self.assertEqual(self.record("playerclass03/evileye1b.dbr").get("skillCooldownTime"), "3.800000")
        self.assertEqual(self.record("playerclass03/evileye1.dbr").get("projectileExplosionRadius"), "0.550000")
        fragments_name = "records/skills/playerclass03/evileye4.dbr"
        original = DBR.from_file(resolve(fragments_name, gen.REFERENCE))
        new = self.record("playerclass03/evileye4.dbr")
        old_max = list(map(int, original.get("projectileFragmentsLaunchNumberMax").split(";")))
        new_max = list(map(int, new.get("projectileFragmentsLaunchNumberMax").split(";")))
        self.assertEqual(len(old_max), 22)
        self.assertEqual(new_max[:11], old_max[:11])
        self.assertEqual(new_max[11:], [value + 1 for value in old_max[11:]])
        self.assertEqual(new.get("projectileFragmentsLaunchNumberMin"),
                         original.get("projectileFragmentsLaunchNumberMin"))
        self.assertEqual(self.record("playerclass03/sigilofdestruction1.dbr").get("skillActiveDuration"),
                         "7.200000")  # Previous Sigil pass untouched.
        self.assertEqual(self.record("playerclass03/bloodofdreeg1_buff.dbr").get("skillLifePercent"), "0")

    def test_occultist_new_skill_individual_rollback(self):
        settings = copy.deepcopy(self.settings)
        chosen = {
            "records/skills/playerclass03/curse1_buff.dbr",
            "records/skills/playerclass03/evileye4.dbr",
            "records/skills/playerclass03/bondsofbysmiel1_petbonus.dbr",
        }
        for entry in settings["records"]:
            if entry["record"] in chosen:
                entry["enabled"] = False
        files, report = build_skills(settings, gen.REFERENCE)
        for name in chosen:
            self.assertEqual(files[Path("database") / name],
                             DBR.from_file(resolve(name, gen.REFERENCE)).render())
            self.assertFalse(next(item["changed"] for item in report if item["record"] == name))

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
