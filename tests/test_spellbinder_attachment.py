"""Focused Spellbinder graph, balance, tree, layout and rollback regressions."""
import copy
import itertools
from pathlib import Path
import re
import sys
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from dbr import DBR
from references import resolve
import arcanist_attachment as arc
import generate_variants as gen
import player_skills
import spellbinder_attachment as sb


class SpellbinderAttachmentTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.settings = sb.load_settings(gen.REPO)
        cls.arc_settings = arc.load_settings(gen.REPO)
        cls.skills, _ = player_skills.build_skills(player_skills.load_settings(gen.REPO), gen.REFERENCE)
        cls.arc_base, _ = arc.build_attachment(cls.arc_settings, gen.REFERENCE)
        cls.files = cls.build(cls.settings)

    @classmethod
    def build(cls, settings, arc_settings=None):
        a, _ = arc.build_attachment(arc_settings or cls.arc_settings, gen.REFERENCE, settings, cls.skills)
        n, _ = sb.compose_class(settings, gen.REFERENCE, cls.skills, '08')
        if set(a) & set(n):
            raise AssertionError('Cross-mastery output collision')
        return {**a, **n}

    def native(self, name):
        return DBR.from_file(resolve(name, gen.REFERENCE))

    def record(self, logical, files=None):
        return DBR((self.files if files is None else files)[Path('database') / logical])

    def fields(self, d):
        return {line.split(',', 1)[0]: d.get(line.split(',', 1)[0]) for line in d.lines if ',' in line}

    def test_all_clones_equal_effective_occultist_with_only_local_links_changed(self):
        # Exact full-record equality also covers damage, lifesteal, native ranks,
        # descriptions, FX, resistance curves, connector strips and skill tiers.
        for name, (c, stems, support, _, _, _) in sb.DONORS.items():
            mapping = {sb.SOURCE + stem + '.dbr': sb.clone_path(c, stem) for stem in stems + support}
            for source, target in mapping.items():
                with self.subTest(line=name, source=source):
                    key = Path('database') / source
                    expected = DBR(self.skills[key]) if key in self.skills else self.native(source)
                    for field, value in self.fields(expected).items():
                        expected.set(field, ';'.join(mapping.get(part, part) for part in value.split(';')))
                    self.assertEqual(self.record(target).render(), expected.render())

    def test_bonds_and_manipulation_use_private_improved_pet_bonus_records(self):
        for stem, field in [('bondsofbysmiel1', 'characterLifeModifier'),
                            ('bondsofbysmiel2', 'offensiveTotalDamageModifier'),
                            ('bondsofbysmiel2', 'characterTotalSpeedModifier')]:
            skill = self.record(sb.clone_path('08', stem))
            target = sb.clone_path('08', stem + '_petbonus')
            self.assertEqual(skill.get('petBonusName'), target)
            actual = self.record(target).get(field)
            expected = DBR(self.skills[Path('database') / (sb.SOURCE + stem + '_petbonus.dbr')]).get(field)
            self.assertEqual(actual, expected)
            self.assertNotEqual(actual, self.native(sb.SOURCE + stem + '_petbonus.dbr').get(field))

    def test_blood_is_toggle_without_instant_heal_and_has_private_buff(self):
        main = self.record(sb.clone_path('08', 'bloodofdreeg1'))
        self.assertEqual(main.get('Class'), 'Skill_BuffRadiusToggled')
        buff_path = sb.clone_path('08', 'bloodofdreeg1_buff')
        self.assertEqual(main.get('buffSkillName'), buff_path)
        buff = self.record(buff_path)
        self.assertEqual(float(buff.get('characterManaLimitReserve')), 100)
        for field in ('skillLifePercent', 'skillManaCost', 'skillCooldownTime', 'skillActiveDuration'):
            self.assertEqual(set(map(float, buff.get(field).split(';'))), {0})
        self.assertEqual(buff.get('characterLifeRegen'), DBR(self.skills[Path('database') / (sb.SOURCE + 'bloodofdreeg1_buff.dbr')]).get('characterLifeRegen'))
        aspect = self.record(sb.clone_path('08', 'bloodofdreeg2'))
        for field in ('defensivePhysical', 'defensivePoison'):
            self.assertEqual(aspect.get(field), DBR(self.skills[Path('database') / (sb.SOURCE + 'bloodofdreeg2.dbr')]).get(field))

    def test_sigil_every_radius_rank_duration_cooldown_damage_and_lifesteal(self):
        original = self.native(sb.SOURCE + 'sigilofdestruction1.dbr')
        clone = self.record(sb.clone_path('05', 'sigilofdestruction1'))
        for actual, base in zip(clone.get('projectileExplosionRadius').split(';'), original.get('projectileExplosionRadius').split(';')):
            self.assertAlmostEqual(float(actual), float(base) * 1.15, places=6)
        self.assertAlmostEqual(float(clone.get('skillActiveDuration')), 7.2)
        self.assertAlmostEqual(float(clone.get('skillCooldownTime')), 2.7)
        for field, value in self.fields(original).items():
            if field.startswith('offensive'):
                self.assertEqual(clone.get(field), value)

    def test_pairs_are_adjacent_in_tree_with_native_connectors_and_correct_buttons(self):
        for c, first_slot in [('08', 33), ('05', 33)]:
            tree = self.record(sb.tree_path(c))
            pairs = [v for v in sb.DONORS.values() if v[0] == c]
            slot = first_slot
            for _, stems, _, donor_buttons, xs, _ in pairs:
                for stem, n, x in zip(stems, donor_buttons, xs):
                    clone = sb.clone_path(c, stem)
                    self.assertEqual(tree.get(f'skillName{slot}'), clone)
                    self.assertEqual(tree.get(f'skillLevel{slot}'), '0')
                    button = self.record(sb.button_path(c, stem))
                    self.assertEqual(button.get('skillName'), clone)
                    self.assertEqual(int(button.get('bitmapPositionX')), x)
                    slot += 1
                a, b = (self.record(sb.button_path(c, stem)) for stem in stems)
                self.assertEqual(a.get('bitmapPositionY'), b.get('bitmapPositionY'))
                # The base connector uses native spacing (160 or 240), not
                # guessed 160px spacing for every skill pair.
                donor_a, donor_b = (self.native(f'records/ui/skills/class03/skill{n:02}.dbr') for n in donor_buttons)
                self.assertEqual(int(b.get('bitmapPositionX')) - int(a.get('bitmapPositionX')),
                                 int(donor_b.get('bitmapPositionX')) - int(donor_a.get('bitmapPositionX')))

    def test_native_trees_and_occultist_are_preserved(self):
        for c, count in [('05', 31), ('08', 32)]:
            source = self.native(sb.tree_path(c))
            target = self.record(sb.tree_path(c))
            for i in range(1, count + 1):
                self.assertEqual(target.get(f'skillName{i}'), source.get(f'skillName{i}'))
                self.assertEqual(target.get(f'skillLevel{i}'), source.get(f'skillLevel{i}'))
        self.assertFalse(any('/playerclass03/' in p.as_posix() or '/class03/' in p.as_posix() for p in self.files))
        self.assertFalse(any('ben_raiseskeletons' in v for k, v in self.fields(self.record(sb.tree_path('05'))).items() if k.startswith('skillName')))

    def test_all_toggle_combinations_and_guardian_remain_independent(self):
        for flags in itertools.product((False, True), repeat=4):
            settings = copy.deepcopy(self.settings)
            for name, flag in zip(sb.DONORS, flags):
                settings['lines'][name] = flag
            a = copy.deepcopy(self.arc_settings)
            a['guardian']['enabled'] = flags[3]
            files = self.build(settings, a)  # Includes layout/connector checks.
            for name, (c, stems, _, _, _, _) in sb.DONORS.items():
                buttons = self.record(sb.panel_path(c), files).get('tabSkillButtons').split(';')
                for stem in stems:
                    self.assertEqual(sb.button_path(c, stem) in buttons, settings['lines'][name])
            tree = self.record(sb.tree_path('05'), files)
            registered = [v for k, v in self.fields(tree).items() if k.startswith('skillName')]
            self.assertEqual(arc.GUARDIAN_TARGET in registered, flags[3])
            if not flags[2]:
                base, _ = arc.build_attachment(a, gen.REFERENCE)
                for p, text in base.items():
                    self.assertEqual(files[p], text)
                for logical in self.native(sb.panel_path('05')).get('tabSkillButtons').split(';'):
                    if re.search(r'/skill\d+\.dbr$', logical):
                        self.assertEqual(self.record(logical, files).render(), self.native(logical).render())
            if not flags[0] and not flags[1]:
                for logical in (sb.tree_path('08'), sb.panel_path('08')):
                    self.assertEqual(self.record(logical, files).render(), self.native(logical).render())

    def test_global_disable_restores_native_necro_and_composed_arcanist_ui(self):
        settings = copy.deepcopy(self.settings)
        settings['enabled'] = False
        files = self.build(settings)
        for p, text in self.arc_base.items():
            self.assertEqual(files[p], text)
        for logical in self.native(sb.panel_path('08')).get('tabSkillButtons').split(';'):
            if re.search(r'/skill\d+\.dbr$', logical):
                self.assertEqual(self.record(logical, files).render(), self.native(logical).render())

    def test_layout_preserves_x_and_moves_native_chains_as_rows(self):
        for c in ('05', '08'):
            panel = self.native(sb.panel_path(c))
            for logical in panel.get('tabSkillButtons').split(';'):
                if not re.search(r'/skill\d+\.dbr$', logical):
                    continue
                old = self.native(logical)
                new = self.record(logical)
                self.assertEqual(old.get('bitmapPositionX'), new.get('bitmapPositionX'))
                y = int(old.get('bitmapPositionY'))
                self.assertEqual(int(new.get('bitmapPositionY')), y - ((y-39)//70)*10)
        self.assertEqual(self.record(arc.GUARDIAN_BUTTON_TARGET).get('bitmapPositionY'), '159')

    def test_schema_and_output_collisions_are_rejected(self):
        for change in ({'enabled': 1}, {'schema_version': True}, {'lines': {'sigil': True}}):
            settings = {**copy.deepcopy(self.settings), **change}
            with self.assertRaises(ValueError):
                self.build(settings)
        files = dict(self.arc_base)
        files[Path('database') / sb.clone_path('05', 'sigilofdestruction1')] = 'collision'
        with self.assertRaisesRegex(ValueError, 'output collision'):
            sb.compose_class(self.settings, gen.REFERENCE, self.skills, '05', files)
        with self.assertRaisesRegex(ValueError, 'compose'):
            sb.compose_class(self.settings, gen.REFERENCE, self.skills, '05')

    def test_capacity_checked_against_actual_template(self):
        # Change only the template read; preserve all DBR source reads.
        original = Path.read_text
        def limited(path, *args, **kwargs):
            text = original(path, *args, **kwargs)
            return text.replace('name = "skillName33"', 'name = "removed33"') if path.name == 'skilltree.tpl' else text
        with patch.object(Path, 'read_text', limited):
            with self.assertRaisesRegex(ValueError, 'capacity'):
                sb.compose_class(self.settings, gen.REFERENCE, self.skills, '08')

    def test_skeletons_stay_disabled_and_conflicting_opt_in_is_rejected(self):
        self.assertFalse(self.arc_settings['skeletons']['enabled'])
        settings = copy.deepcopy(self.arc_settings)
        settings['skeletons']['enabled'] = True
        with self.assertRaisesRegex(ValueError, 'Disable Arcanist skeletons'):
            self.build(self.settings, settings)

    def test_clones_follow_balance_rollback_and_reject_missing_effective_records(self):
        settings = player_skills.load_settings(gen.REPO)
        settings['enabled'] = False
        originals, _ = player_skills.build_skills(settings, gen.REFERENCE)
        files, _ = sb.compose_class(self.settings, gen.REFERENCE, originals, '08')
        clone = self.record(sb.clone_path('08', 'bondsofbysmiel1_petbonus'), files)
        self.assertEqual(clone.render(), self.native(sb.SOURCE + 'bondsofbysmiel1_petbonus.dbr').render())
        with self.assertRaisesRegex(ValueError, 'Effective Occultist balance output missing'):
            sb.compose_class(self.settings, gen.REFERENCE, {}, '08')

    def test_generation_is_deterministic(self):
        self.assertEqual(self.files, self.build(self.settings))


if __name__ == '__main__':
    unittest.main()
