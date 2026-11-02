"""Inquisitor Vire's Might / Blade Spirit tree, UI and isolated rollback."""
import copy
import json
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))

from dbr import DBR
from references import resolve
from player_skills import build_skills, load_settings as load_skill_settings
from inquisitor_attachment import (
    build_attachment, load_settings, DONORS, TREE, PANEL, BLADE_SOURCE
)
import generate_variants as gen


class InquisitorAttachmentTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.settings = load_settings(gen.REPO)
        cls.skill_files, _ = build_skills(load_skill_settings(gen.REPO), gen.REFERENCE)
        cls.files, cls.report = build_attachment(cls.settings, gen.REFERENCE, cls.skill_files)

    def native(self, logical):
        return DBR.from_file(resolve(logical, gen.REFERENCE))

    def result(self, logical):
        return DBR(self.files[Path("database") / logical])

    def test_both_mastery_skills_attached_to_free_tree_slots(self):
        tree = self.result(TREE)
        panel = self.result(PANEL)
        source_tree = self.native(TREE)
        source_panel = self.native(PANEL)
        self.assertEqual(self.report["active_skills"], ["vires_might", "blade_spirit"])
        for index, key in enumerate(("vires_might", "blade_spirit")):
            donor = DONORS[key]
            slot = 35 + index
            self.assertEqual(tree.get(f"skillName{slot}"), donor["target"])
            self.assertEqual(tree.get(f"skillLevel{slot}"), "0")
            self.assertIn(donor["button_target"], panel.get("tabSkillButtons").split(";"))
            button = self.result(donor["button_target"])
            self.assertEqual(button.get("skillName"), donor["target"])
            self.assertEqual(
                [int(button.get("bitmapPositionX")), int(button.get("bitmapPositionY"))],
                donor["position"],
            )
        original_buttons = source_panel.get("tabSkillButtons").split(";")
        modified_buttons = panel.get("tabSkillButtons").split(";")
        self.assertEqual(modified_buttons[:len(original_buttons)], original_buttons)
        expected = self.native(TREE)
        expected.set("skillLevel35", "0")
        expected.set("skillLevel36", "0")
        expected.lines.append(f'skillName35,{DONORS["vires_might"]["target"]},\n')
        expected.lines.append(f'skillName36,{DONORS["blade_spirit"]["target"]},\n')
        self.assertEqual(tree.render(), expected.render())
        self.assertEqual(source_tree.get("skillName34"), tree.get("skillName34"))

    def test_vire_matches_native_rush_other_than_orphaned_connectors(self):
        source = self.native(DONORS["vires_might"]["source"])
        clone = self.result(DONORS["vires_might"]["target"])
        expected = self.native(DONORS["vires_might"]["source"])
        expected.set("skillConnectionOff", "")
        expected.set("skillConnectionOn", "")
        self.assertEqual(clone.render(), expected.render())
        self.assertEqual(clone.get("Class"), "Skill_AttackPathCharge")
        self.assertEqual(clone.get("skillSpecialAnimationName"), "Rush")
        self.assertEqual(clone.get("skillCooldownTime"), source.get("skillCooldownTime"))

    def test_blade_spirit_inherits_exact_nightblade_improvements(self):
        clone = self.result(DONORS["blade_spirit"]["target"])
        balanced = DBR(self.skill_files[Path("database") / BLADE_SOURCE])
        self.assertEqual(clone.render(), balanced.render())
        self.assertEqual(
            list(map(int, clone.get("petLimit").split(";"))),
            [2]*15+[4]*8+[5]*3
        )
        self.assertEqual(clone.get("petBurstSpawn"), clone.get("petLimit"))
        self.assertEqual(clone.get("skillCooldownTime"),
                         self.native(BLADE_SOURCE).get("skillCooldownTime"))

    def test_independent_disable_keeps_the_other_and_full_rollback_is_vanilla(self):
        for off in ("vires_might", "blade_spirit"):
            with self.subTest(off=off):
                config = copy.deepcopy(self.settings)
                next(e for e in config["skills"] if e["id"] == off)["enabled"] = False
                files, report = build_attachment(config, gen.REFERENCE, self.skill_files)
                self.assertEqual(len(report["active_skills"]), 1)
                other = next(e for e in config["skills"] if e["id"] != off)
                self.assertEqual(report["active_skills"], [other["id"]])
                self.assertEqual(DBR(files[Path("database") / TREE]).get("skillName35"),
                                 other["target"])
                self.assertFalse(DBR(files[Path("database") / TREE])._locations("skillName36"))
        config = copy.deepcopy(self.settings)
        config["enabled"] = False
        files, report = build_attachment(config, gen.REFERENCE, self.skill_files)
        self.assertEqual(report["active_skills"], [])
        self.assertEqual(files[Path("database") / TREE], self.native(TREE).render())
        self.assertEqual(files[Path("database") / PANEL], self.native(PANEL).render())

    def test_config_refuses_unknown_donors_or_unverified_ui_layout(self):
        for field, value in (
            ("target", "records/skills/playerclass02/unsafe.dbr"),
            ("position", [406, 459]),
            ("button_target", "records/ui/skills/class07/skill01.dbr")
        ):
            with self.subTest(field=field):
                config = copy.deepcopy(self.settings)
                config["skills"][0][field] = value
                with self.assertRaises(ValueError):
                    build_attachment(config, gen.REFERENCE, self.skill_files)


if __name__ == "__main__":
    unittest.main()
