"""Staging must match a freshly validated config plan, never a manifest allowlist."""
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / 'scripts'))
import generate_variants as gen
import prepare_console_test as staging


class ConsoleStagingTests(unittest.TestCase):
    def test_all_families_stage_idempotently_and_protect_existing_edits(self):
        files = gen.configured_plan(include_spawns=True); files.pop(Path('manifest.json'))
        self.assertEqual(len(files), 1216)
        with tempfile.TemporaryDirectory() as tmp:
            repo = Path(tmp) / 'mods' / staging.MOD_NAME; repo.mkdir(parents=True)
            staging.stage(files, repo=repo, include_spawns=True)
            staging.stage(files, repo=repo, include_spawns=True)
            path = next(iter(files)); target = repo / path
            target.write_text('local edits')
            with self.assertRaises(gen.GenerationError):
                staging.stage(files, repo=repo, include_spawns=True)
            self.assertEqual(target.read_text(), 'local edits')
            staging.stage(files, repo=repo, include_spawns=True, replace=True)
            self.assertEqual(target.read_text(), files[path])

    def test_unexpected_paths_changed_contents_and_wrong_selection_rejected(self):
        files = gen.configured_plan('boar'); files.pop(Path('manifest.json'))
        with tempfile.TemporaryDirectory() as tmp:
            repo = Path(tmp) / 'mods' / staging.MOD_NAME; repo.mkdir(parents=True)
            bad = dict(files); bad[Path('database/records/game/gameengine.dbr')] = 'bad'
            with self.assertRaises(gen.GenerationError):
                staging.stage(bad, repo=repo, family='boar')
            bad = dict(files); bad[next(iter(files))] = 'bad'
            with self.assertRaises(gen.GenerationError):
                staging.stage(bad, repo=repo, family='boar')
            with self.assertRaises(gen.GenerationError):
                staging.stage(files, repo=repo, family='all')
            self.assertEqual(list(repo.iterdir()), [])

    def test_generated_manifest_tampering_and_stale_files_rejected(self):
        with tempfile.TemporaryDirectory() as tmp:
            output = Path(tmp) / 'generated/MonsterExpansion'
            with patch.object(gen, 'OUTPUT', output), patch.object(staging, 'OUTPUT', output):
                files = gen.configured_plan(include_spawns=True)
                gen.write_staged(files, output)
                self.assertEqual(len(staging.preflight(include_spawns=True)), 1216)
                (output / 'manifest.json').write_text('{}')
                with self.assertRaises(gen.GenerationError):
                    staging.preflight(include_spawns=True)

    def test_symlinked_output_parent_rejected(self):
        files = gen.configured_plan('boar'); files.pop(Path('manifest.json'))
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); repo = root / 'mods' / staging.MOD_NAME; repo.mkdir(parents=True)
            outside = root / 'outside'; outside.mkdir()
            (repo / 'database').symlink_to(outside, target_is_directory=True)
            with self.assertRaises(gen.GenerationError):
                staging.stage(files, repo=repo, family='boar')
            self.assertEqual(list(outside.iterdir()), [])
