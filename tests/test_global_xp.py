"""Global monster-kill XP equation scaling and exact vanilla rollback."""
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from dbr import DBR
from references import resolve
from global_xp import load_settings, build_global_xp, EQUATIONS, RECORD, OUTPUT_RECORD
import generate_variants as gen


class GlobalXPTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.original = DBR.from_file(resolve(RECORD, gen.REFERENCE))

    def test_x1_and_disabled_restore_exact_original_record(self):
        native = self.original.render()
        for settings in (
                {"enabled": True, "multiplier": 1},
                {"enabled": True, "multiplier": 1.0},
                {"enabled": False, "multiplier": 2.5}):
            with self.subTest(settings=settings):
                self.assertEqual(build_global_xp(settings, gen.REFERENCE), native)

    def test_xp_multiplier_wraps_only_four_native_kill_equations(self):
        for factor in (0.5, 1.25, 1.5, 2, 3):
            with self.subTest(multiplier=factor):
                modified = DBR(build_global_xp({"enabled": True,
                                                "multiplier": factor},
                                               gen.REFERENCE))
                expected = DBR.from_file(resolve(RECORD, gen.REFERENCE))
                for field in EQUATIONS:
                    previous = self.original.get(field)
                    self.assertIn("monsterExperience", previous)
                    self.assertEqual(modified.get(field),
                                     f"({previous}) * {format(factor, '.12g')}")
                    expected.set(field, modified.get(field))
                # All other XP fields including death penalty and
                # redemption stay byte-for-byte equivalent to originals.
                self.assertEqual(modified.render(), expected.render())

    def test_global_xp_config_rejects_bad_values_and_schema(self):
        base = {"schema_version": 1,
                "monster_spawning": {"enabled": True,
                                     "pack_size_multiplier": 2}}
        with tempfile.TemporaryDirectory() as folder:
            config = Path(folder) / "config"
            config.mkdir()
            path = config / "master.json"
            def load(data):
                path.write_text(json.dumps(data), encoding="utf-8")
                return load_settings(Path(folder))
            self.assertIsNone(load(base))
            for value in (True, False, None, "1.5", 0, -1, 11,
                          float("nan"), float("inf"), -float("inf")):
                with self.subTest(multiplier=value), self.assertRaises(ValueError):
                    load({**base, "global_xp": {"enabled": True, "multiplier": value}})
            for section in ({"enabled": "yes", "multiplier": 1},
                            {"enabled": True, "multiplier": 1, "extra": 2},
                            {"enabled": True}, [], 3):
                with self.subTest(section=section), self.assertRaises(ValueError):
                    load({**base, "global_xp": section})

    def test_gameengine_references_effective_xp_equations(self):
        engine = DBR.from_file(resolve("records/game/gameengine.dbr", gen.REFERENCE))
        self.assertEqual(engine.get("experienceRecord"), RECORD)
        self.assertEqual(self.original.get("templateName"),
                         "database/templates/experienceformulas.tpl")
        self.assertEqual(len(EQUATIONS), 4)

    def test_global_xp_is_in_combined_plan_independent_of_spawn_option(self):
        settings = load_settings(gen.REPO)
        self.assertIsNotNone(settings)
        # A single-family plan avoids expanding all 409 variants twice.
        plan = gen.configured_plan("boar", include_spawns=False)
        self.assertIn(OUTPUT_RECORD, plan)
        self.assertEqual(plan[OUTPUT_RECORD], build_global_xp(settings, gen.REFERENCE))
        manifest = json.loads(plan[Path("manifest.json")])
        self.assertEqual(manifest["global_xp"], settings)
        self.assertIn(OUTPUT_RECORD.as_posix(), manifest["files"])


if __name__ == "__main__":
    unittest.main()
