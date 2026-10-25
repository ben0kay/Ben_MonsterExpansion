"""Devotion rewards/cap compose with attributes and fail safely on missing DLC data."""
import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from devotion import build_shrines, validate_settings, reference_coverage
from references import layers, resolve
from player_stats import build_player_stats, load_settings, RECORD
import generate_variants as gen
from dbr import DBR


class DevotionTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(); self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.settings = {'enabled': True, 'points_per_shrine': 2, 'max_points': 85,
                         'required_reference_layers': ['base', 'gdx1', 'gdx2']}
        self.shrine = 'templateName,database/templates/staticshrine.tpl,\nClass,StaticShrine,\ndevotionPoints,1,\nnormalXPReward,500,\nlegendaryDisabled,0,\n'
        for i, layer in enumerate(layers(self.root)):
            path = layer / f'interactive/{i}.dbr'; path.parent.mkdir(parents=True); path.write_text(self.shrine)
        # A later DLC overrides a shared base shrine; do not restore old reward/XP flags.
        (layers(self.root)[2] / 'interactive/shared.dbr').write_text(self.shrine)
        (layers(self.root)[0] / 'interactive/shared.dbr').write_text(self.shrine.replace('500,', '999,'))
        (layers(self.root)[2] / 'interactive/quest.dbr').write_text(self.shrine.replace('devotionPoints,1,', 'devotionPoints,0,'))
        (layers(self.root)[2] / 'interactive/blank.dbr').write_text(self.shrine.replace('devotionPoints,1,\n', ''))

    def test_only_reward_changes_and_dlc_priority_and_zero_shrines_preserved(self):
        before = {p: p.read_bytes() for p in self.root.rglob('*.dbr')}
        files, report = build_shrines(self.settings, self.root)
        self.assertEqual(len(files), 4)
        self.assertFalse(any(p.name in ('blank.dbr', 'quest.dbr') for p in files))
        self.assertEqual(report['missing_reference_layers'], [])
        for path, text in files.items():
            original = resolve(path.as_posix().removeprefix('database/'), self.root).read_text()
            self.assertEqual(text, original.replace('devotionPoints,1,', 'devotionPoints,2,'))
        self.assertIn('normalXPReward,999,', files[Path('database/records/interactive/shared.dbr')])
        self.assertTrue(all(p.read_bytes() == text for p, text in before.items()))

    def test_missing_dlc_blocks_enabled_changes_and_disabled_pending_emits_nothing(self):
        for path in (layers(self.root)[0] / 'interactive').glob('*.dbr'): path.unlink()
        with self.assertRaisesRegex(ValueError, 'gdx2'): build_shrines(self.settings, self.root)
        files, report = build_shrines(dict(self.settings, enabled=False), self.root)
        self.assertEqual(files, {}); self.assertEqual(report['status'], 'disabled_pending_references')

    def test_disabled_complete_references_emit_exact_vanilla_shrines_for_rollback(self):
        files, report = build_shrines(dict(self.settings, enabled=False), self.root)
        self.assertEqual(report['status'], 'vanilla_shrine_rollback')
        for path, text in files.items():
            self.assertEqual(text, resolve(path.as_posix().removeprefix('database/'), self.root).read_text())

    def test_cap_composes_with_attributes_and_disable_restores_cap(self):
        settings = load_settings(gen.REPO); settings['devotion'] = self.settings
        result = DBR(build_player_stats(settings, gen.REFERENCE))
        source = DBR.from_file(resolve(RECORD, gen.REFERENCE))
        self.assertEqual(result.get('maxDevotionPoints'), '85')
        self.assertEqual(result.get('characterModifierPoints'), '2')
        for field in ('strengthIncrement', 'dexterityIncrement', 'intelligenceIncrement'):
            self.assertEqual(result.get(field), '6')
        for field in ('maxPlayerLevel', 'skillModifierPoints', 'experienceLevelEquation'):
            self.assertEqual(result.get(field), source.get(field))
        settings['devotion']['enabled'] = False
        self.assertEqual(DBR(build_player_stats(settings, gen.REFERENCE)).get('maxDevotionPoints'), '55')

    def test_invalid_settings_refused(self):
        for field in ('max_points', 'points_per_shrine'):
            for value in (0, -1, True, 1.5, '2'):
                with self.subTest(field=field, value=value), self.assertRaises(ValueError):
                    validate_settings(dict(self.settings, **{field: value}))
        for value in ([], ['gdx1', 'gdx1'], ['../gdx2']):
            with self.assertRaises(ValueError): validate_settings(dict(self.settings, required_reference_layers=value))

    def test_reference_symlinks_refused(self):
        path = layers(self.root)[0] / 'interactive/linked.dbr'; path.symlink_to(self.root / 'missing')
        with self.assertRaises(ValueError): build_shrines(self.settings, self.root)

    def test_generated_plan_manifest_includes_shrines_with_valid_references(self):
        settings = load_settings(gen.REPO); settings['devotion'] = self.settings
        with patch('player_stats.load_settings', return_value=settings), patch('devotion.build_shrines', wraps=lambda cfg, reference: build_shrines(cfg, self.root)):
            files = gen.configured_plan('boar')
        self.assertEqual(DBR(files[Path('database') / RECORD]).get('maxDevotionPoints'), '85')
        self.assertEqual(DBR(files[Path('database/records/interactive/shared.dbr')]).get('devotionPoints'), '2')
        manifest = json.loads(files[Path('manifest.json')])
        self.assertIn('database/records/interactive/shared.dbr', manifest['files'])
        self.assertTrue(manifest['devotion']['enabled'])
