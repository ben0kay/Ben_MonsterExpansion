import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from dbr import DBR
from player_movement import (
    PLAYER_RECORDS, build_player_movement, load_settings
)
from references import resolve
import generate_variants as gen


class PlayerMovementTests(unittest.TestCase):
    def test_both_genders_get_exact_15_percent_without_other_changes(self):
        settings = load_settings(gen.REPO)
        self.assertEqual(settings["base_run_speed_multiplier"], 1.15)
        files, report = build_player_movement(settings, gen.REFERENCE)
        self.assertEqual(len(files), 2)
        self.assertTrue(all(item["changed"] for item in report))
        for name in PLAYER_RECORDS:
            source = resolve(name, gen.REFERENCE).read_text(encoding="utf-8")
            self.assertIn("characterRunSpeed,0.930000,", source)
            expected = source.replace("characterRunSpeed,0.930000,",
                                      "characterRunSpeed,1.069500,")
            self.assertEqual(files[Path("database") / name], expected)
            self.assertEqual(DBR(files[Path("database") / name]).get("characterRunSpeed"), "1.069500")

    def test_disabled_emits_exact_effective_sources(self):
        settings = copy.deepcopy(load_settings(gen.REPO))
        settings["enabled"] = False
        files, report = build_player_movement(settings, gen.REFERENCE)
        self.assertTrue(all(not item["changed"] for item in report))
        for name in PLAYER_RECORDS:
            self.assertEqual(files[Path("database") / name],
                             resolve(name, gen.REFERENCE).read_text(encoding="utf-8"))

    def test_invalid_inputs_fail_closed(self):
        settings = load_settings(gen.REPO)
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "config").mkdir()
            for value in (True, 0, -1, 0.1, 2.1, "1.15", float("nan"), float("inf")):
                bad = copy.deepcopy(settings)
                bad["base_run_speed_multiplier"] = value
                (root / "config/player_movement.json").write_text(json.dumps(bad))
                with self.subTest(value=value), self.assertRaises(ValueError):
                    load_settings(root)
            bad = copy.deepcopy(settings)
            bad["enabled"] = "true"
            (root / "config/player_movement.json").write_text(json.dumps(bad))
            with self.assertRaises(ValueError):
                load_settings(root)

    def test_main_plan_has_both_overrides_without_spawn_flag(self):
        files = gen.configured_plan("boar", include_spawns=False)
        for name in PLAYER_RECORDS:
            self.assertIn(Path("database") / name, files)
        manifest = json.loads(files[Path("manifest.json")])
        self.assertEqual(manifest["player_movement"]["base_run_speed_multiplier"], 1.15)
        self.assertEqual(len(manifest["player_movement_records"]), 2)
        for name in PLAYER_RECORDS:
            self.assertIn((Path("database") / name).as_posix(), manifest["files"])
        self.assertEqual(manifest["player_movement_records"][0]["generated_run_speed"], "1.069500")


if __name__ == "__main__":
    unittest.main()
