"""Cosmetic isolation, established template fields and non-destructive slot allocation."""
import copy
import re
import unittest
from pathlib import Path
import sys
REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / 'scripts'))
import generate_variants as gen
from dbr import DBR


class CosmeticAuraTests(unittest.TestCase):
    def test_preserves_existing_initial_and_uses_available_slots(self):
        monster = gen.read_game_dbr('records/creatures/enemies/zombie_a01.dbr')
        monster.lines.append('initialSkillName,records/skills/existing.dbr,\n')
        monster.lines.append('skillName4,records/skills/occupied.dbr,\n')
        proto = {'cosmetic_aura': {'enabled': True,
                 'effect_source_record': 'records/fx/creatures/glownature01_large.dbr'}}
        files = gen.build_cosmetic_aura(monster, proto, 'test_veteran_01')
        self.assertEqual(monster.get('initialSkillName'), 'records/skills/existing.dbr')
        self.assertIn('test_veteran_01_cosmetic', monster.get('initial2SkillName'))
        self.assertEqual(monster.get('skillName4'), 'records/skills/occupied.dbr')
        self.assertEqual(monster.get('initial2SkillName'), monster.get('skillName5'))
        monster.lines.append('initial2SkillName,duplicate,\n')
        with self.assertRaises(ValueError):
            gen.build_cosmetic_aura(monster, proto, 'test_veteran_01')

    def test_both_initial_slots_occupied_rejected(self):
        monster = gen.read_game_dbr('records/creatures/enemies/zombie_a01.dbr')
        monster.lines += ['initialSkillName,one,\n', 'initial2SkillName,two,\n']
        before = monster.render()
        with self.assertRaises(gen.GenerationError):
            gen.build_cosmetic_aura(monster, {'cosmetic_aura': {'enabled': True,
                'effect_source_record': 'records/fx/creatures/glownature01_large.dbr'}}, 'test_veteran_01')
        self.assertEqual(before, monster.render())

    def test_minimal_cosmetic_fields_match_real_template_no_stat_bonuses(self):
        root = REPO / 'ReferenceFiles/Resources/templates'
        def fields(template):
            text = (root / template).read_text()
            result = set(re.findall(r'name = "([^"]+)"', text))
            for include in re.findall(r'defaultValue = "database\\Templates\\([^"\n]+)"', text):
                result |= fields(include.replace('\\', '/').lower())
            return result
        supported = fields('skill_buffselftoggled.tpl')
        for path, text in gen.configured_plan().items():
            if path.name.endswith('_cosmetic.dbr'):
                data = DBR(text)
                for line in data.lines:
                    key, value, _ = line.split(',', 2)
                    if key != 'templateName':
                        self.assertIn(key, supported)
                    self.assertFalse(key.startswith(('offensive', 'defensive', 'character', 'retaliation')))
                    if 'Cost' in key:
                        self.assertEqual(float(value), 0)
                self.assertEqual(data.get('notDispelable'), '1')
