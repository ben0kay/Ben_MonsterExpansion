"""Arcanist skeleton + Guardian mastery tree: accurate donors, layout and rollback."""
import copy
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))

from dbr import DBR
from references import resolve
from arcanist_attachment import (
    TREE, PANEL, MOVES, SKELETON_SOURCES, SKELETON_TARGETS,
    SKELETON_BUTTON_TARGETS, GUARDIAN_SOURCE, GUARDIAN_TARGET,
    GUARDIAN_BUTTON_TARGET, NATIVE_BUTTON_POSITIONS,
    build_attachment, load_settings
)
import generate_variants as gen


class ArcanistAttachmentTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.settings = load_settings(gen.REPO)
        cls.files, cls.report = build_attachment(cls.settings, gen.REFERENCE)

    def native(self, logical):
        return DBR.from_file(resolve(logical, gen.REFERENCE))

    def result(self, logical, files=None):
        return DBR((files or self.files)[Path("database") / logical])

    def test_full_arcanist_tree_has_three_skeleton_buttons_plus_guardian(self):
        tree = self.result(TREE)
        panel = self.result(PANEL)
        base_tree = self.native(TREE)
        base_panel = self.native(PANEL)
        targets = SKELETON_TARGETS + [GUARDIAN_TARGET]
        buttons = SKELETON_BUTTON_TARGETS + [GUARDIAN_BUTTON_TARGET]
        self.assertEqual(self.report["active_skills"], targets)
        for slot, (name, button) in enumerate(zip(targets, buttons), 32):
            self.assertEqual(tree.get(f"skillName{slot}"), name)
            self.assertEqual(tree.get(f"skillLevel{slot}"), "0")
            self.assertIn(button, panel.get("tabSkillButtons").split(";"))
            self.assertEqual(self.result(button).get("skillName"), name)
        expected_buttons = base_panel.get("tabSkillButtons").split(";")
        self.assertEqual(panel.get("tabSkillButtons").split(";"),
                         expected_buttons + buttons)
        self.assertEqual(base_tree.get("skillName31"), tree.get("skillName31"))

    def test_skeleton_base_is_four_but_undead_legion_remains_additive(self):
        first = self.result(SKELETON_TARGETS[0])
        base = self.native(SKELETON_SOURCES[0])
        self.assertEqual(base.get("petBurstSpawn"), "3")
        self.assertEqual(first.get("petBurstSpawn"), "4")
        self.assertEqual(first.get("petLimit"), "4")
        expected = self.native(SKELETON_SOURCES[0])
        expected.set("petBurstSpawn", "4")
        expected.set("petLimit", "4")
        self.assertEqual(first.render(), expected.render())
        # Native Necromancer modifiers, pet spawn lists and pet actors are reused.
        for source, target in zip(SKELETON_SOURCES[1:], SKELETON_TARGETS[1:]):
            self.assertEqual(self.result(target).render(), self.native(source).render())
        undead_legion = self.result(SKELETON_TARGETS[1])
        self.assertEqual(undead_legion.get("petLimit").split(";")[11], "5")
        self.assertEqual(self.result(SKELETON_TARGETS[2]).get("petSkillName"),
                         self.native(SKELETON_SOURCES[2]).get("petSkillName"))

    def test_guardian_preserves_native_summon_and_only_clears_orphaned_connectors(self):
        source = self.native(GUARDIAN_SOURCE)
        clone = self.result(GUARDIAN_TARGET)
        expected = self.native(GUARDIAN_SOURCE)
        expected.set("skillConnectionOff", "")
        expected.set("skillConnectionOn", "")
        self.assertEqual(clone.render(), expected.render())
        self.assertEqual(clone.get("Class"), "Skill_TargetedSpawnPet")
        self.assertEqual(clone.get("petBurstSpawn").split(";"),
                         ["2"]*23 + ["3"]*3)
        self.assertEqual(clone.get("petLimit"), source.get("petLimit"))
        self.assertEqual(clone.get("spawnObjects"), source.get("spawnObjects"))
        self.assertEqual(clone.get("skillCooldownTime"), "20.000000")

    def test_original_arcanist_buttons_move_only_when_skeletons_active(self):
        self.assertEqual(self.report["original_buttons_moved"], 5)
        panel = self.native(PANEL)
        original_names = [p for p in panel.get("tabSkillButtons").split(";")
                          if p.startswith("records/ui/skills/class05/skill")]
        all_coords = []
        for path in original_names:
            result = (self.result(path) if path in MOVES else self.native(path))
            num = int(Path(path).stem.removeprefix("skill"))
            xy = (int(result.get("bitmapPositionX")), int(result.get("bitmapPositionY")))
            all_coords.append(xy)
            self.assertEqual(xy, MOVES.get(path, NATIVE_BUTTON_POSITIONS[num]))
            if path in MOVES:
                original = self.native(path)
                self.assertEqual(result.get("skillName"), original.get("skillName"))
                self.assertEqual(result.get("bitmapPositionX"),
                                 original.get("bitmapPositionX"))
        for button in SKELETON_BUTTON_TARGETS + [GUARDIAN_BUTTON_TARGET]:
            record = self.result(button)
            all_coords.append((int(record.get("bitmapPositionX")),
                               int(record.get("bitmapPositionY"))))
        for i, (x, y) in enumerate(all_coords):
            for a, b in all_coords[i+1:]:
                self.assertFalse(abs(x-a)<60 and abs(y-b)<60)

    def test_independent_switches_and_full_native_rollback(self):
        for group in ("skeletons", "guardian"):
            with self.subTest(group=group):
                setting = copy.deepcopy(self.settings)
                setting[group]["enabled"] = False
                files, report = build_attachment(setting, gen.REFERENCE)
                tree = self.result(TREE, files)
                panel = self.result(PANEL, files)
                self.assertEqual(len(report["active_skills"]), 1 if group == "skeletons" else 3)
                if group == "skeletons":
                    self.assertEqual(tree.get("skillName32"), GUARDIAN_TARGET)
                    self.assertEqual(panel.get("tabSkillButtons").split(";")[-1],
                                     GUARDIAN_BUTTON_TARGET)
                    for original in MOVES:
                        self.assertEqual(files[Path("database") / original],
                                         self.native(original).render())
                else:
                    self.assertEqual(tree.get("skillName34"), SKELETON_TARGETS[2])
                    self.assertEqual(panel.get("tabSkillButtons").split(";")[-3:],
                                     SKELETON_BUTTON_TARGETS)
        disabled = copy.deepcopy(self.settings)
        disabled["enabled"] = False
        files, report = build_attachment(disabled, gen.REFERENCE)
        self.assertEqual(report["active_skills"], [])
        self.assertEqual(files[Path("database") / TREE], self.native(TREE).render())
        self.assertEqual(files[Path("database") / PANEL], self.native(PANEL).render())
        for original in MOVES:
            self.assertEqual(files[Path("database") / original],
                             self.native(original).render())

    def test_unreviewed_config_is_rejected(self):
        for action in ("rename_donor", "collide_button", "change_move"):
            with self.subTest(action=action):
                setting = copy.deepcopy(self.settings)
                if action == "rename_donor":
                    setting["guardian"]["source"] = SKELETON_SOURCES[0]
                elif action == "collide_button":
                    setting["guardian"]["position"] = [566,459]
                else:
                    next(iter(setting["relocated_buttons"].values()))[1] = 39
                with self.assertRaises(ValueError):
                    build_attachment(setting, gen.REFERENCE)


if __name__ == "__main__":
    unittest.main()
