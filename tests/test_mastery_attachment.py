"""Focused checks for the Nightblade skeleton complete skill line."""
import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
import generate_variants as gen
from dbr import DBR
from references import resolve
from mastery_attachment import load_settings, build_attachment
from player_skills import load_settings as load_balance, build_skills


class AttachmentTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.settings = load_settings(gen.REPO)
        cls.files, cls.report = build_attachment(cls.settings, gen.REFERENCE)

    def record(self, name):
        return DBR(self.files[Path('database') / name])

    def test_native_skill_parity_and_dlc_dependencies(self):
        for index, entry in enumerate(self.settings['skills']):
            original = DBR.from_file(resolve(entry['source'], gen.REFERENCE))
            if index == 0:
                original.set('petBurstSpawn', '4')
                original.set('petLimit', '4')
            self.assertEqual(self.record(entry['target']).render(), original.render())
        base = self.record(self.settings['skills'][0]['target'])
        self.assertEqual(base.get('petLimit'), '4')
        self.assertEqual(base.get('petBurstSpawn'), '4')
        self.assertEqual(float(base.get('skillCooldownTime')), 18)
        self.assertEqual(base.get('skillMaxLevel'), '16')
        self.assertEqual(base.get('skillUltimateLevel'), '26')
        for line in base.lines:
            if line.startswith('spawnObjects'):
                for pet in line.split(',')[1].split(';'):
                    self.assertTrue(resolve(pet, gen.REFERENCE).is_file(), pet)
        wrapper = self.record(self.settings['skills'][2]['target'])
        self.assertTrue(resolve(wrapper.get('petSkillName'), gen.REFERENCE).is_file())

    def test_tree_panel_append_line_and_preserve_existing_fields(self):
        tree = self.record(self.settings['tree'])
        original = DBR.from_file(resolve(self.settings['tree'], gen.REFERENCE))
        for line in original.lines:
            if ',' in line:
                key = line.split(',')[0]
                self.assertEqual(tree.get(key), original.get(key))
        self.assertEqual(tree.get('skillName35'), self.settings['skills'][0]['target'])
        self.assertEqual(tree.get('skillName36'), self.settings['skills'][1]['target'])
        self.assertEqual(tree.get('skillName37'), self.settings['skills'][2]['target'])
        old = DBR.from_file(resolve(self.settings['panel'], gen.REFERENCE))
        old.set('tabSkillButtons', old.get('tabSkillButtons')+';'+';'.join(e['button_target'] for e in self.settings['skills']))
        self.assertEqual(self.record(self.settings['panel']).render(), old.render())
        self.assertEqual(len(self.report['active_skills']), 3)
        self.assertEqual(self.record(self.settings['skills'][0]['button_target']).get('bitmapPositionY'), '459')

    def test_disabled_restores_original_tree_and_panel_with_stable_manifest_paths(self):
        disabled = copy.deepcopy(self.settings)
        disabled['enabled'] = False
        files, report = build_attachment(disabled, gen.REFERENCE)
        self.assertEqual(set(files), set(self.files))
        self.assertEqual(report['active_skills'], [])
        for key in ('tree', 'panel'):
            name = disabled[key]
            self.assertEqual(files[Path('database') / name], DBR.from_file(resolve(name, gen.REFERENCE)).render())
        self.assertEqual(build_attachment(None, gen.REFERENCE), ({}, None))
        for name in disabled['existing_button_positions']:
            self.assertEqual(files[Path('database') / name], DBR.from_file(resolve(name, gen.REFERENCE)).render())
        base = DBR(files[Path('database') / disabled['skills'][0]['target']])
        self.assertEqual(base.get('petLimit'), '3')
        self.assertEqual(base.get('petBurstSpawn'), '3')

    def test_layout_and_path_collisions_are_rejected(self):
        for edit in ('overlap', 'outside', 'duplicate', 'unsafe', 'gate', 'donor'):
            settings = copy.deepcopy(self.settings)
            if edit == 'overlap': settings['skills'][0]['position'] = [406, 249]
            if edit == 'outside': settings['skills'][0]['position'] = [246, 529]
            if edit == 'duplicate': settings['skills'][1]['target'] = settings['skills'][0]['target']
            if edit == 'unsafe': settings['skills'][0]['target'] = 'records/skills/playerclass04/ben_../../evil.dbr'
            if edit == 'gate': settings['skills'][1]['visible'] = False
            if edit == 'donor': settings['skills'][0]['button_source'] = settings['skills'][1]['button_source']
            with self.subTest(edit=edit), self.assertRaises(ValueError):
                build_attachment(settings, gen.REFERENCE)

    def test_combined_manifest_balance_and_collision_guard(self):
        balance, _ = build_skills(load_balance(gen.REPO), gen.REFERENCE)
        combined = gen.configured_plan('all', True)
        for path, content in balance.items():
            self.assertEqual(combined[path], content)
        manifest = json.loads(combined[Path('manifest.json')])
        for path, content in self.files.items():
            self.assertEqual(combined[path], content)
            self.assertIn(path.as_posix(), manifest['files'])
        self.assertEqual(manifest['nightblade_skeletons'], self.report)
        collision = {next(iter(balance)): 'unexpected'}
        with patch('mastery_attachment.build_attachment', return_value=(collision, {})):
            with self.assertRaises(gen.GenerationError):
                gen.configured_plan('all', False)

    def test_ui_only_moves_buttons_and_preserves_branch_offsets(self):
        for name, position in self.settings['existing_button_positions'].items():
            original = DBR.from_file(resolve(name, gen.REFERENCE))
            original.set('bitmapPositionX', str(position[0]))
            original.set('bitmapPositionY', str(position[1]))
            self.assertEqual(self.record(name).render(), original.render())
        for child, parent in ((29,1), (30,10), (31,8)):
            names = [f'records/ui/skills/class04/skill{i:02}.dbr' for i in (child,parent)]
            before = [DBR.from_file(resolve(n, gen.REFERENCE)) for n in names]
            after = [self.record(n) for n in names]
            for axis in ('X','Y'):
                key = 'bitmapPosition'+axis
                self.assertEqual(int(before[0].get(key))-int(before[1].get(key)),
                                 int(after[0].get(key))-int(after[1].get(key)))
        self.assertEqual(len(self.files), 39)

    def test_undead_legion_is_native_additive_cap_curve(self):
        entry = self.settings['skills'][1]
        modifier = self.record(entry['target'])
        self.assertEqual(modifier.get('Class'), 'Skill_Modifier')
        self.assertEqual(modifier.render(), DBR.from_file(resolve(entry['source'], gen.REFERENCE)).render())
        additions = list(map(int, modifier.get('petLimit').split(';')))
        self.assertEqual(additions[0], 1)
        self.assertEqual(additions[11], 5)
        self.assertEqual(additions[-1], 7)
        self.assertEqual([4+additions[i] for i in (0,11,21)], [5,9,11])

    def test_effective_dlc_priority(self):
        # An expansion override must be cloned instead of a stale base reference.
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            import mastery_attachment as attachment
            def effective(name, ignored):
                if name == self.settings['skills'][0]['source']:
                    return root / 'effective.dbr'
                return resolve(name, gen.REFERENCE)
            native = DBR.from_file(resolve(self.settings['skills'][0]['source'], gen.REFERENCE))
            native.set('skillManaCost', '123')
            (root / 'effective.dbr').write_text(native.render())
            (root / 'Resources/templates').mkdir(parents=True)
            (root / 'Resources/templates/skilltree.tpl').write_text((gen.REFERENCE / 'Resources/templates/skilltree.tpl').read_text())
            with patch.object(attachment, 'resolve', side_effect=effective):
                files, _ = attachment.build_attachment(self.settings, root)
            self.assertEqual(DBR(files[Path('database') / self.settings['skills'][0]['target']]).get('skillManaCost'), '123')


if __name__ == '__main__':
    unittest.main()
