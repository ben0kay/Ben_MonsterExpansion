"""ME2 debug staging tests; no game or game files are modified."""
import json
import sys
import tempfile
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "scripts"))
import prepare_console_test as debug
import generate_variants as generator


class ConsoleStagingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        family = json.loads((REPO / "config/families/boar.json").read_text(encoding="utf-8"))
        tiers = json.loads((REPO / "config/tiers.json").read_text(encoding="utf-8"))["tiers"]
        contents = generator.build_variant(family, next(t for t in tiers if t["id"] == "veteran"))
        cls.files = {key: value for key, value in contents.items() if key != Path("manifest.json")}

    def test_fixed_only_six_mod_files(self):
        self.assertEqual(set(self.files), debug.ALLOWED | debug.AURA_ALLOWED)
        self.assertTrue(all("monsterexpansion" in p.as_posix() for p in self.files))
        self.assertTrue(all("proxies" not in p.as_posix() for p in self.files))

    def test_stage_idempotent_in_safe_directory(self):
        with tempfile.TemporaryDirectory() as tmp:
            folder = Path(tmp) / "mods" / debug.MOD_NAME
            folder.mkdir(parents=True)
            debug.stage(self.files, repo=folder)
            debug.stage(self.files, repo=folder)
            for path, text in self.files.items():
                self.assertEqual((folder / path).read_text(encoding="utf-8"), text)

    def test_stage_refuses_changed_file_unless_opted_in(self):
        with tempfile.TemporaryDirectory() as tmp:
            folder = Path(tmp) / "mods" / debug.MOD_NAME
            folder.mkdir(parents=True)
            path = sorted(self.files)[0]
            destination = folder / path
            destination.parent.mkdir(parents=True)
            destination.write_text("user's altered data", encoding="utf-8")
            with self.assertRaises(generator.GenerationError):
                debug.stage(self.files, repo=folder)
            self.assertEqual(destination.read_text(encoding="utf-8"), "user's altered data")
            debug.stage(self.files, repo=folder, replace=True)
            self.assertEqual(destination.read_text(encoding="utf-8"), self.files[path])

    def test_stage_rejects_repo_mismatch_and_extra_file(self):
        with tempfile.TemporaryDirectory() as tmp:
            with self.assertRaises(generator.GenerationError):
                debug.stage(self.files, repo=Path(tmp))
            with self.assertRaises(generator.GenerationError):
                debug.stage({**self.files, Path("database/records/game/gameengine.dbr"): "bad"},
                            repo=Path(tmp) / "mods" / debug.MOD_NAME)

    def test_console_command_references_generated_enemy(self):
        self.assertEqual(debug.COMMAND,
                         'game.Spawn "records/creatures/enemies/monsterexpansion/boar_veteran_01.dbr"')


if __name__ == "__main__":
    unittest.main()
