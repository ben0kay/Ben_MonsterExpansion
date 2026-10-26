import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from dbr import DBR
from references import resolve
from player_movement import load_settings as movement_config, build_player_movement, PLAYER_RECORDS
from player_basics import load_settings, build_player_basics, ENGINE_RECORD, ENGINE_OUTPUT
import generate_variants as gen


class PlayerBasicsTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.settings = load_settings(gen.REPO)
        cls.movement, _ = build_player_movement(movement_config(gen.REPO), gen.REFERENCE)

    def test_composes_player_overrides_and_only_changes_requested_fields(self):
        files, report = build_player_basics(self.settings, gen.REFERENCE, self.movement)
        self.assertEqual(len(files), 3)
        for name in PLAYER_RECORDS:
            src = resolve(name, gen.REFERENCE).read_text(encoding="utf-8")
            expected = (src.replace("characterRunSpeed,0.930000,", "characterRunSpeed,1.069500,")
                           .replace("characterLife,250.000000,", "characterLife,300.000000,")
                           .replace("characterMana,250.000000,", "characterMana,300.000000,"))
            self.assertEqual(files[Path("database") / name], expected)
        engine = resolve(ENGINE_RECORD, gen.REFERENCE).read_text(encoding="utf-8")
        expected_engine = (engine.replace("playerRunSpeedCapMax,135.000000,", "playerRunSpeedCapMax,145.000000,")
                               .replace("CameraDistanceDefault,36.000000,", "CameraDistanceDefault,39.000000,"))
        self.assertEqual(files[ENGINE_OUTPUT], expected_engine)
        self.assertEqual(report["engine"]["camera_min"], "20.000000")
        self.assertEqual(report["engine"]["camera_max"], "48.000000")

    def test_independent_disables_restore_original_fields(self):
        settings = copy.deepcopy(self.settings)
        for key in ("starting_stats", "movement_speed_cap", "camera"):
            settings[key]["enabled"] = False
        files, _ = build_player_basics(settings, gen.REFERENCE, self.movement)
        for name in PLAYER_RECORDS:
            self.assertEqual(files[Path("database") / name], self.movement[Path("database") / name])
        self.assertEqual(files[ENGINE_OUTPUT], resolve(ENGINE_RECORD, gen.REFERENCE).read_text(encoding="utf-8"))

    def test_rejects_invalid_settings(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "config").mkdir()
            for section, field, bad in (
                ("starting_stats", "health", 0),
                ("starting_stats", "energy", "300"),
                ("movement_speed_cap", "max_percent", 351),
                ("movement_speed_cap", "max_percent", True),
                ("camera", "default_distance", 50),
                ("camera", "enabled", "true"),
            ):
                config = copy.deepcopy(self.settings)
                config[section][field] = bad
                (root / "config/player_basics.json").write_text(json.dumps(config))
                with self.subTest(section=section, field=field), self.assertRaises(ValueError):
                    settings = load_settings(root)
                    build_player_basics(settings, gen.REFERENCE, self.movement)

    def test_full_plan_has_one_engine_record_and_composed_player_records(self):
        files = gen.configured_plan("boar")
        manifest = json.loads(files[Path("manifest.json")])
        self.assertIn(ENGINE_OUTPUT.as_posix(), manifest["files"])
        self.assertEqual(manifest["player_basics"]["movement_speed_cap"]["max_percent"], 145)
        for name in PLAYER_RECORDS:
            record = DBR(files[Path("database") / name])
            self.assertEqual(record.get("characterRunSpeed"), "1.069500")
            self.assertEqual(record.get("characterLife"), "300.000000")
            self.assertEqual(record.get("characterMana"), "300.000000")


if __name__ == "__main__":
    unittest.main()
