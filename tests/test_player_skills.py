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
            self.assertEqual(limit, ["2"]*7 + ["3"]*7 + ["4"]*12)
            self.assertEqual(len(limit), 26)
            self.assertEqual(limit[7], "3")  # Rank 8
            self.assertEqual(limit[14], "4")  # Rank 15, before the native 16-rank cap
            for rank in (1, 8, 26):
                old_health_bonus = 10 + 2*(rank-1)
                expected = 20 + 1.2 * old_health_bonus
                self.assertAlmostEqual(
                    float(self.record(f"playerclass03/pets/pet_{pet}_a{rank:02}.dbr").get("characterLifeModifier")),
                    expected)

    def test_all_52_occultist_pet_ranks_gain_20_percent_effective_health(self):
        for pet in ("raven", "hellhound"):
            for rank in range(1, 27):
                logical = f"records/skills/playerclass03/pets/pet_{pet}_a{rank:02}.dbr"
                actual = DBR(self.files[Path("database") / logical])
                source = DBR.from_file(resolve(logical, gen.REFERENCE))
                old_bonus = 10 + 2 * (rank - 1)
                new_bonus = float(actual.get("characterLifeModifier"))
                # Compare HP multipliers, not just percent-point bonuses.
                self.assertAlmostEqual((100 + new_bonus) / (100 + old_bonus), 1.20)
                expected = DBR.from_file(resolve(logical, gen.REFERENCE))
                expected.set("characterLifeModifier", actual.get("characterLifeModifier"))
                self.assertEqual(actual.render(), expected.render())
                self.assertEqual(source.get("characterLife"), actual.get("characterLife"))

    def test_all_skeleton_types_share_health_and_damage_scaling_and_rollback(self):
        name = "records/skills/playerclass08/pets/petskill_skeleton_basescaling.dbr"
        source = DBR.from_file(resolve(name, gen.REFERENCE))
        output = DBR(self.files[Path("database") / name])

        # Additive percentage-point bonuses in the source are not the same
        # as a relative 20% HP / 15% damage increase.
        for field, multiplier in (("characterLifeModifier", 1.20),
                                  ("offensiveTotalDamageModifier", 1.15)):
            native = [float(x) for x in source.get(field).split(";")]
            modded = [float(x) for x in output.get(field).split(";")]
            self.assertEqual(len(native), 26)
            self.assertEqual(len(modded), len(native))
            for old, new in zip(native, modded):
                self.assertAlmostEqual((100 + new) / (100 + old),
                                       multiplier, places=6)
        expected = DBR.from_file(resolve(name, gen.REFERENCE))
        for field in ("characterLifeModifier", "offensiveTotalDamageModifier"):
            expected.set(field, output.get(field))
        self.assertEqual(output.render(), expected.render())

        # All four skeleton variants, including caster and advanced skeletons,
        # use the same base-scaling passive at both ends of the rank curve.
        for rank in (1, 26):
            for suffix in ("", "b", "c", "d"):
                actor = ("records/skills/playerclass08/pets/"
                         f"skeleton_{rank:02}{suffix}.dbr")
                native_pet = DBR.from_file(resolve(actor, gen.REFERENCE))
                self.assertEqual(native_pet.get("skillName1"), name)

        settings = copy.deepcopy(self.settings)
        next(e for e in settings["records"] if e["record"] == name)["enabled"] = False
        files, report = build_skills(settings, gen.REFERENCE)
        self.assertEqual(files[Path("database") / name], source.render())
        self.assertFalse(next(e["changed"] for e in report if e["record"] == name))

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

    def test_phantasmal_blades_more_projectiles_damage_and_rollback(self):
        name = "records/skills/playerclass04/phantomblade.dbr"
        original = DBR.from_file(resolve(name, gen.REFERENCE))
        updated = self.record("playerclass04/phantomblade.dbr")
        counts = [4]*7 + [5]*8 + [6]*8 + [7]*3
        self.assertEqual(len(counts), 26)
        self.assertEqual(
            [int(x) for x in updated.get("projectileLaunchNumber").split(";")],
            counts)
        native = [int(x) for x in original.get("projectileLaunchNumber").split(";")]
        self.assertEqual(
            [a-b for a, b in zip(counts, native)], [1]*26)
        expected = DBR.from_file(resolve(name, gen.REFERENCE))
        expected.set("projectileLaunchNumber", updated.get("projectileLaunchNumber"))
        for field in ("offensivePierceMin", "offensivePierceMax",
                      "offensiveSlowBleedingMin"):
            before = [float(x) for x in original.get(field).split(";")]
            after = [float(x) for x in updated.get(field).split(";")]
            self.assertEqual(len(before), 26)
            self.assertEqual(len(after), 26)
            for old, new in zip(before, after):
                self.assertAlmostEqual(new, old * 1.25, places=5)
            expected.set(field, updated.get(field))
        self.assertEqual(updated.render(), expected.render())
        self.assertEqual(updated.get("weaponDamagePct"),
                         original.get("weaponDamagePct"))
        self.assertEqual(updated.get("projectileLaunchRotation"),
                         original.get("projectileLaunchRotation"))

        settings = copy.deepcopy(self.settings)
        next(e for e in settings["records"] if e["record"] == name)["enabled"] = False
        files, report = build_skills(settings, gen.REFERENCE)
        self.assertEqual(files[Path("database") / name], original.render())
        self.assertFalse(next(e["changed"] for e in report if e["record"] == name))

    def test_phantasmal_blades_fx_range_scale_and_rollback(self):
        name = "records/fx/skillclass04/phantomblade1_projectile_fx01.dbr"
        original = DBR.from_file(resolve(name, gen.REFERENCE))
        output = DBR(self.files[Path("database") / name])
        self.assertEqual(original.get("projectileDistance"), "16.000000")
        self.assertEqual(original.get("scale"), "0.750000")
        self.assertEqual(output.get("projectileDistance"), "20.000000")
        self.assertEqual(output.get("scale"), "0.900000")
        expected = DBR.from_file(resolve(name, gen.REFERENCE))
        expected.set("projectileDistance", "20.000000")
        expected.set("scale", "0.900000")
        self.assertEqual(output.render(), expected.render())

        settings = copy.deepcopy(self.settings)
        next(e for e in settings["records"] if e["record"] == name)["enabled"] = False
        files, report = build_skills(settings, gen.REFERENCE)
        self.assertEqual(files[Path("database") / name], original.render())
        self.assertFalse(next(e["changed"] for e in report if e["record"] == name))

    def test_skill_fx_paths_remain_restricted_to_class_fx(self):
        settings = copy.deepcopy(self.settings)
        fx = next(e for e in settings["records"]
                  if e["record"] == "records/fx/skillclass04/phantomblade1_projectile_fx01.dbr")
        for invalid in ("records/fx/environments/unrelated.dbr",
                        "records/fx/skillclass04/../unrelated.dbr",
                        "records/fx/skillclass04/unrelated.txt"):
            with self.subTest(record=invalid):
                fx["record"] = invalid
                with self.assertRaises(ValueError):
                    build_skills(settings, gen.REFERENCE)

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

    def test_demolition_first_pass_preserves_native_fields_and_rank_curves(self):
        factors = {
            "stunjacks1": {"projectileExplosionRadius": 1.10},
            "stunjacks2": {},
            "flamestrike2": {"skillTargetRadius": 1.10},
            "grenado1": {"projectileExplosionRadius": 1.10},
            "canisterbomb1": {"projectileExplosionRadius": 1.10},
            "canisterbomb2": {"explosionRadius": 1.10},
            "blackwater1": {
                "projectileExplosionRadius": 1.12,
                "skillActiveDuration": 1.10,
            },
            "flashbang1": {"projectileExplosionRadius": 1.10},
        }
        entries = {
            item["record"]: item for item in self.settings["records"]
            if item["record"].startswith("records/skills/playerclass02/")
        }
        self.assertTrue(
            {f"records/skills/playerclass02/{name}.dbr" for name in factors}.issubset(set(entries))
        )
        for name, multipliers in factors.items():
            path = f"records/skills/playerclass02/{name}.dbr"
            entry = entries[path]
            native = DBR.from_file(resolve(path, gen.REFERENCE))
            modified = self.record(f"playerclass02/{name}.dbr")
            expected = DBR.from_file(resolve(path, gen.REFERENCE))
            changed = set(entry["set"]) | set(entry["curves"])
            for field in changed:
                expected.set(field, modified.get(field))
            with self.subTest(skill=name):
                self.assertEqual(modified.render(), expected.render())
                for field, multiplier in multipliers.items():
                    before = list(map(float, native.get(field).split(";")))
                    after = list(map(float, modified.get(field).split(";")))
                    self.assertEqual(len(before), len(after))
                    for old, new in zip(before, after):
                        self.assertAlmostEqual(new, old * multiplier, places=5)

        full_spread = self.record("playerclass02/stunjacks2.dbr")
        old_spread = DBR.from_file(resolve(
            "records/skills/playerclass02/stunjacks2.dbr", gen.REFERENCE))
        old_counts = list(map(int, old_spread.get("projectileLaunchNumber").split(";")))
        new_counts = list(map(int, full_spread.get("projectileLaunchNumber").split(";")))
        self.assertEqual(len(old_counts), 22)
        self.assertEqual([n - o for o, n in zip(old_counts, new_counts)],
                         [0] * 13 + [1] * 9)
        self.assertEqual(new_counts[-1], 6)

        canister_path = "records/skills/playerclass02/canisterbomb1.dbr"
        original = DBR.from_file(resolve(canister_path, gen.REFERENCE))
        improved = self.record("playerclass02/canisterbomb1.dbr")
        for field in ("projectileFragmentsLaunchNumberMin",
                      "projectileFragmentsLaunchNumberMax"):
            old = list(map(int, original.get(field).split(";")))
            new = list(map(int, improved.get(field).split(";")))
            self.assertEqual(len(old), 22)
            self.assertEqual([n - o for o, n in zip(old, new)],
                             [0] * 7 + [1] * 10 + [2] * 5)
        mins = list(map(int, improved.get("projectileFragmentsLaunchNumberMin").split(";")))
        maxs = list(map(int, improved.get("projectileFragmentsLaunchNumberMax").split(";")))
        self.assertTrue(all(low <= high for low, high in zip(mins, maxs)))
        self.assertEqual((mins[0], maxs[0], mins[-1], maxs[-1]),
                         (4, 6, 11, 13))
        self.assertEqual(improved.get("skillProjectileNumber"),
                         original.get("skillProjectileNumber"))

    def test_demolition_deployables_rank_scaling(self):
        mortar_name = "records/skills/playerclass02/mortartrap1.dbr"
        mine_name = "records/skills/playerclass02/thermitemines1.dbr"
        mortar = self.record("playerclass02/mortartrap1.dbr")
        mines = self.record("playerclass02/thermitemines1.dbr")
        mortar_limit = list(map(int, mortar.get("petLimit").split(";")))
        mine_limit = list(map(int, mines.get("petLimit").split(";")))
        mine_burst = list(map(int, mines.get("petBurstSpawn").split(";")))
        self.assertEqual(mortar_limit, [1]*11 + [2]*6 + [3]*6 + [4]*3)
        self.assertEqual(mine_burst, [3]*15 + [4]*11)
        self.assertEqual(mine_limit, [6]*15 + [8]*7 + [9]*4)
        self.assertEqual(float(mortar.get("spawnObjectsTimeToLive")), 27.6)
        self.assertEqual(float(mines.get("spawnObjectsTimeToLive")), 20.7)
        self.assertTrue(all(burst <= limit for burst, limit in zip(mine_burst, mine_limit)))

        for record, keys in (
            (mortar_name, ("petLimit", "spawnObjectsTimeToLive")),
            (mine_name, ("petBurstSpawn", "petLimit", "spawnObjectsTimeToLive")),
        ):
            base = DBR.from_file(resolve(record, gen.REFERENCE))
            edited = self.record(record.removeprefix("records/skills/"))
            for key in keys:
                base.set(key, edited.get(key))
            self.assertEqual(edited.render(), base.render())

        for name, field, multiplier in (
            ("playerclass02/mortartrap2.dbr", "explosionRadius", 1.10),
            ("playerclass02/pets/mortartrap_firemortar1.dbr", "projectileExplosionRadius", 1.10),
            ("playerclass02/pets/thermitemine_skill_radius.dbr", "skillTargetRadius", 1.10),
        ):
            with self.subTest(name=name):
                path = "records/skills/" + name
                before = DBR.from_file(resolve(path, gen.REFERENCE))
                after = self.record(name)
                original = list(map(float, before.get(field).split(";")))
                result = list(map(float, after.get(field).split(";")))
                self.assertEqual(len(result), len(original))
                for old, new in zip(original, result):
                    self.assertAlmostEqual(new, old * multiplier, places=5)
                before.set(field, after.get(field))
                self.assertEqual(after.render(), before.render())

    def test_demolition_deployables_individual_rollback(self):
        for name in ("mortartrap1", "mortartrap2",
                     "pets/mortartrap_firemortar1", "thermitemines1",
                     "pets/thermitemine_skill_radius"):
            path = f"records/skills/playerclass02/{name}.dbr"
            with self.subTest(name=name):
                settings = copy.deepcopy(self.settings)
                next(entry for entry in settings["records"]
                     if entry["record"] == path)["enabled"] = False
                files, report = build_skills(settings, gen.REFERENCE)
                original = DBR.from_file(resolve(path, gen.REFERENCE))
                self.assertEqual(files[Path("database") / path], original.render())
                self.assertFalse(next(entry["changed"] for entry in report
                                      if entry["record"] == path))

    def test_demolition_first_pass_individual_rollback(self):
        for skill in ("stunjacks2", "canisterbomb1", "blackwater1"):
            name = f"records/skills/playerclass02/{skill}.dbr"
            with self.subTest(skill=skill):
                settings = copy.deepcopy(self.settings)
                next(e for e in settings["records"]
                     if e["record"] == name)["enabled"] = False
                files, report = build_skills(settings, gen.REFERENCE)
                original = DBR.from_file(resolve(name, gen.REFERENCE))
                self.assertEqual(files[Path("database") / name], original.render())
                self.assertFalse(next(e["changed"] for e in report
                                      if e["record"] == name))

    def test_occultist_pyromancer_fire_synergy_preserves_native_damage(self):
        profiles = (
            ("doombolt1", 0.08, ("offensiveChaosMin", "offensiveLifeMin")),
            ("evileye1", 0.15, ("offensivePoisonMin",)),
        )
        for name, factor, source_fields in profiles:
            path = f"records/skills/playerclass03/{name}.dbr"
            with self.subTest(skill=name):
                native = DBR.from_file(resolve(path, gen.REFERENCE))
                modified = self.record(f"playerclass03/{name}.dbr")
                settings_entry = next(e for e in self.settings["records"]
                                      if e["record"] == path)
                native_fire = list(map(float, native.get("offensiveFireMin").split(";")))
                self.assertEqual(native_fire, [0.0])
                new_fire = list(map(float, modified.get("offensiveFireMin").split(";")))
                source_curves = [list(map(float, native.get(field).split(";")))
                                 for field in source_fields]
                self.assertEqual(len(new_fire), 22)
                self.assertTrue(all(len(values) == 22 for values in source_curves))
                for index, value in enumerate(new_fire):
                    expected = sum(values[index] for values in source_curves) * factor
                    self.assertAlmostEqual(value, expected, places=5)
                    self.assertGreater(value, 0)
                # The new Fire field is the only addition to the already
                # configured damage/area/cooldown overrides.
                expected_record = DBR.from_file(resolve(path, gen.REFERENCE))
                for field in set(settings_entry["set"]) | set(settings_entry["curves"]):
                    expected_record.set(field, modified.get(field))
                self.assertEqual(modified.render(), expected_record.render())
                for field in source_fields:
                    self.assertEqual(settings_entry["curves"].get(field),
                                     {"multiplier": 1.15, "multiplier_per_rank": 0.015}
                                     if name == "doombolt1" else
                                     {"multiplier": 1.1})
                self.assertEqual(native.get("skillMaxLevel"),
                                 modified.get("skillMaxLevel"))

    def test_occultist_pyromancer_fire_individual_rollback(self):
        for name in ("doombolt1", "evileye1"):
            path = f"records/skills/playerclass03/{name}.dbr"
            with self.subTest(skill=name):
                settings = copy.deepcopy(self.settings)
                next(e for e in settings["records"]
                     if e["record"] == path)["enabled"] = False
                files, report = build_skills(settings, gen.REFERENCE)
                original = DBR.from_file(resolve(path, gen.REFERENCE))
                self.assertEqual(files[Path("database") / path], original.render())
                self.assertFalse(next(r["changed"] for r in report
                                      if r["record"] == path))

    def test_pyromancer_witchfire_and_hellfire_rank_scaling(self):
        witch_name = "records/skills/playerclass03/witchfire1.dbr"
        native_witch = DBR.from_file(resolve(witch_name, gen.REFERENCE))
        mod_witch = self.record("playerclass03/witchfire1.dbr")
        original_chaos = [float(v) for v in native_witch.get("offensiveChaosMin").split(";")]
        fire = [float(v) for v in mod_witch.get("offensiveFireMin").split(";")]
        self.assertEqual(len(original_chaos), 22)
        self.assertEqual(len(fire), 22)
        self.assertEqual(native_witch.get("offensiveFireMin"), "0.000000")
        for old, new in zip(original_chaos, fire):
            self.assertAlmostEqual(new, old * 0.20, places=5)
        # Retain the previously configured +8% Chaos and +5% attack speed.
        new_chaos = [float(v) for v in mod_witch.get("offensiveChaosMin").split(";")]
        self.assertEqual(len(new_chaos), 22)
        for old, new in zip(original_chaos, new_chaos):
            self.assertAlmostEqual(new, old * 1.08, places=5)
        entry = next(e for e in self.settings["records"] if e["record"] == witch_name)
        self.assertEqual(entry["curves"]["characterAttackSpeedModifier"],
                         {"multiplier": 1.05})
        exact_witch = DBR.from_file(resolve(witch_name, gen.REFERENCE))
        for field in set(entry["set"]) | set(entry["curves"]):
            exact_witch.set(field, mod_witch.get(field))
        self.assertEqual(mod_witch.render(), exact_witch.render())

        hell_name = ("records/skills/playerclass03/pets/"
                     "petskill_hellhound_hellfireaura_buff.dbr")
        native_hell = DBR.from_file(resolve(hell_name, gen.REFERENCE))
        mod_hell = self.record(
            "playerclass03/pets/petskill_hellhound_hellfireaura_buff.dbr")
        for field in ("offensiveFireMin", "offensiveFireModifier"):
            original = [float(v) for v in native_hell.get(field).split(";")]
            improved = [float(v) for v in mod_hell.get(field).split(";")]
            self.assertEqual(len(original), 22)
            self.assertEqual(len(improved), 22)
            for old, new in zip(original, improved):
                self.assertAlmostEqual(new, old * 1.08, places=5)
        for field in ("offensiveChaosMin", "offensiveChaosModifier",
                      "skillTargetRadius", "skillMaxLevel", "skillUltimateLevel"):
            self.assertEqual(mod_hell.get(field), native_hell.get(field))
        exact_hell = DBR.from_file(resolve(hell_name, gen.REFERENCE))
        for field in ("offensiveFireMin", "offensiveFireModifier"):
            exact_hell.set(field, mod_hell.get(field))
        self.assertEqual(mod_hell.render(), exact_hell.render())
        # The real Hellhound aura must reference this buff: no dead/unattached DBR.
        wrapper = DBR.from_file(resolve(
            "records/skills/playerclass03/pets/petskill_hellhound_hellfireaura.dbr",
            gen.REFERENCE))
        self.assertEqual(wrapper.get("buffSkillName"), hell_name)

    def test_pyromancer_witchfire_and_hellfire_individual_rollback(self):
        for name in ("records/skills/playerclass03/witchfire1.dbr",
                     "records/skills/playerclass03/pets/"
                     "petskill_hellhound_hellfireaura_buff.dbr"):
            with self.subTest(name=name):
                settings = copy.deepcopy(self.settings)
                entry = next(e for e in settings["records"] if e["record"] == name)
                entry["enabled"] = False
                files, report = build_skills(settings, gen.REFERENCE)
                native = DBR.from_file(resolve(name, gen.REFERENCE))
                self.assertEqual(files[Path("database") / name], native.render())
                self.assertFalse(next(r["changed"] for r in report
                                      if r["record"] == name))

    def test_soldier_offensive_and_defensive_pass_preserves_unrelated_fields(self):
        # The Soldier pass changes only these fourteen original skill DBRs.
        changes = {
            "shieldhammer1": {"waveDistance", "waveStartWidth", "waveEndWidth",
                               "offensivePhysicalMin", "offensivePhysicalMax"},
            "bladearc1": {"skillTargetAngle", "skillTargetNumber",
                          "offensivePhysicalMin"},
            "blitz1": {"skillCooldownTime", "skillTargetNumber",
                       "offensivePhysicalMin"},
            "warcry1": {"skillTargetRadius"},
            "counterstrike1": {"skillTargetRadius", "offensivePhysicalMin"},
            "weaponpool2": {"skillTargetNumber"},
            "cadence1": {"offensivePhysicalMin"},
            "cadence3_buff": {"skillActiveDuration"},
            "overguard1": {"skillActiveDuration", "characterLifeRegenModifier"},
            "willtolive1": {"skillActiveDuration", "characterLifeRegen"},
            "fightingspirit1": {"skillActiveDuration"},
            "passive1": {"characterLifeModifier", "characterStrengthModifier"},
            "passiveshield": {"defensiveBlockModifier"},
            "passive3": {"defensiveElementalResistance",
                         "offensivePhysicalModifier", "offensivePierceModifier"},
        }
        soldier = {e["record"].rsplit("/", 1)[-1].removesuffix(".dbr"): e
                   for e in self.settings["records"]
                   if e["record"].startswith("records/skills/playerclass01/")}
        self.assertEqual(set(soldier) - {"stancedefensive", "stanceoffensive"},
                         set(changes))
        for name, fields in changes.items():
            with self.subTest(skill=name):
                path = f"records/skills/playerclass01/{name}.dbr"
                entry = soldier[name]
                self.assertEqual(set(entry["set"]) | set(entry["curves"]), fields)
                native = DBR.from_file(resolve(path, gen.REFERENCE))
                modified = self.record(f"playerclass01/{name}.dbr")
                expected = DBR.from_file(resolve(path, gen.REFERENCE))
                for field, exact in entry["set"].items():
                    self.assertEqual(modified.get(field), exact)
                    expected.set(field, exact)
                for field, rule in entry["curves"].items():
                    original = [float(v) for v in native.get(field).split(";")]
                    actual = [float(v) for v in modified.get(field).split(";")]
                    self.assertEqual(len(actual), rule.get("ranks", len(original)))
                    for i, got in enumerate(actual):
                        old = original[min(i, len(original) - 1)]
                        value = (old * (rule.get("multiplier", 1) +
                                        i * rule.get("multiplier_per_rank", 0)) +
                                 rule.get("add", 0) + i * rule.get("add_per_rank", 0))
                        self.assertAlmostEqual(got, value, places=5)
                    expected.set(field, modified.get(field))
                self.assertEqual(modified.render(), expected.render())
                self.assertEqual(modified.get("skillMaxLevel"),
                                 native.get("skillMaxLevel"))
                self.assertEqual(modified.get("skillUltimateLevel"),
                                 native.get("skillUltimateLevel"))

        # Rank 12 is the first extra Zolhan target; earlier ranks are native.
        native = DBR.from_file(resolve(
            "records/skills/playerclass01/weaponpool2.dbr", gen.REFERENCE))
        original = list(map(int, native.get("skillTargetNumber").split(";")))
        upgraded = list(map(int, self.record(
            "playerclass01/weaponpool2.dbr").get("skillTargetNumber").split(";")))
        self.assertEqual(len(original), 22)
        self.assertEqual(upgraded, original[:11] +
                         [value + 1 for value in original[11:]])
        self.assertEqual(upgraded[-1], original[-1] + 1)
        # Preserve Cadence's original high-impact weapon percentage.
        self.assertEqual(self.record("playerclass01/cadence1.dbr").get("weaponDamagePct"),
                         DBR.from_file(resolve(
                             "records/skills/playerclass01/cadence1.dbr",
                             gen.REFERENCE)).get("weaponDamagePct"))

    def test_soldier_first_pass_each_skill_can_rollback_independently(self):
        names = ("shieldhammer1", "bladearc1", "blitz1", "warcry1",
                 "counterstrike1", "weaponpool2", "cadence1", "cadence3_buff",
                 "overguard1", "willtolive1", "fightingspirit1",
                 "passive1", "passiveshield", "passive3")
        for name in names:
            with self.subTest(skill=name):
                path = f"records/skills/playerclass01/{name}.dbr"
                settings = copy.deepcopy(self.settings)
                chosen = next(e for e in settings["records"] if e["record"] == path)
                chosen["enabled"] = False
                files, report = build_skills(settings, gen.REFERENCE)
                native = DBR.from_file(resolve(path, gen.REFERENCE))
                self.assertEqual(files[Path("database") / path], native.render())
                self.assertFalse(next(r["changed"] for r in report
                                      if r["record"] == path))
                # An unrelated Soldier offensive skill remains enabled.
                other = "blitz1" if name != "blitz1" else "bladearc1"
                other_path = f"records/skills/playerclass01/{other}.dbr"
                self.assertEqual(files[Path("database") / other_path],
                                 self.files[Path("database") / other_path])

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
