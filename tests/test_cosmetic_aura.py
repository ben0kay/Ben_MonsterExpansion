"""Cosmetic isolation, rollback and template compatibility checks."""
import copy
import json
import re
import sys
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / 'scripts'))
import generate_variants as gen
from dbr import DBR


class CosmeticAuraTests(unittest.TestCase):
    def setUp(self):
        self.family = json.loads((REPO / 'config/families/boar.json').read_text())
        self.tier = next(t for t in json.loads((REPO / 'config/tiers.json').read_text())['tiers']
                         if t['id'] == 'veteran')

    def test_aura_isolated_from_baseline_combat_and_can_be_disabled(self):
        enabled = gen.build_variant(self.family, self.tier)
        disabled_tier = copy.deepcopy(self.tier)
        disabled_tier['prototype']['cosmetic_aura']['enabled'] = False
        disabled = gen.build_variant(self.family, disabled_tier)
        self.assertEqual(len(disabled), 4)
        monster_path = gen.game_location(self.family['first_prototype']['future_output_record'])
        monster = DBR(enabled[monster_path])
        self.assertEqual(monster.get('initialSkillName'), monster.get('skillName6'))
        self.assertEqual(monster.get('skillLevel6'), '1')
        stripped = ''.join(line for line in monster.lines
                           if not line.startswith(('initialSkillName,', 'skillName6,', 'skillLevel6,')))
        self.assertEqual(stripped, disabled[monster_path])
        for path in disabled:
            if path not in (monster_path, Path('manifest.json')):
                self.assertEqual(enabled[path], disabled[path])
        skill = DBR(enabled[gen.game_location(monster.get('skillName6'))])
        for line in skill.lines:
            key, value, _ = line.split(',', 2)
            self.assertFalse(key.startswith(('offensive', 'defensive', 'character', 'retaliation')))
            if 'Cost' in key:
                self.assertEqual(float(value), 0)
        self.assertEqual(skill.get('notDispelable'), '1')
        pack = DBR(enabled[gen.game_location(skill.get('charFxPakSelfNames'))])
        self.assertEqual(pack.get('particleEffectAttachPoints'), 'FXCentered')
        self.assertEqual(pack.get('useTintColor'), '0')
        self.assertIn(gen.game_location(pack.get('particleEffectNames')), enabled)

    def test_new_buff_fields_are_declared_in_real_templates(self):
        root = REPO / 'ReferenceFiles/Resources/templates'
        def fields(template):
            text = (root / template).read_text()
            result = set(re.findall(r'name = "([^"]+)"', text))
            for include in re.findall(r'defaultValue = "database\\Templates\\([^"\n]+)"', text):
                result |= fields(include.replace('\\', '/').lower())
            return result
        supported = fields('skill_buffselftoggled.tpl')
        generated = gen.build_variant(self.family, self.tier)
        skill = next(value for path, value in generated.items() if path.name.endswith('_cosmetic.dbr'))
        for line in DBR(skill).lines:
            key = line.split(',')[0]
            if key != 'templateName':
                self.assertIn(key, supported)

    def test_refuses_to_replace_parent_initial_skill_or_slot(self):
        source = gen.read_game_dbr(self.family['source_records'][0]['record'])
        for field in ('initialSkillName', 'skillName6', 'skillLevel6'):
            monster = DBR(source.render() + f'{field},occupied,\n')
            with self.assertRaises(gen.GenerationError):
                gen.build_cosmetic_aura(monster, self.tier['prototype'], 'boar_veteran_01')
