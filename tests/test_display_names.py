"""Generated display tags remain custom-only and match packaged English strings."""
import json
from pathlib import Path
import sys
import unittest

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / 'scripts'))
import generate_variants as gen
from dbr import DBR


class DisplayNameTests(unittest.TestCase):
    def test_zombie_tags_resolve_to_parenthesized_tier_names(self):
        files = gen.configured_plan(include_spawns=True)
        tags = dict(line.split('=', 1) for line in files[gen.TEXT_SOURCE].splitlines())
        self.assertEqual(len(tags), 2)
        for name in ('zombie_veteran_01', 'zombie_veteran_starter_01'):
            monster = DBR(files[Path(f'database/records/creatures/enemies/monsterexpansion/{name}.dbr')])
            self.assertEqual(tags[monster.get('description')], 'Walking Dead (Veteran)')
        self.assertFalse(any(tag.startswith('tagEnemy') for tag in tags))
        self.assertEqual(gen.read_game_dbr('records/creatures/enemies/zombie_a01.dbr').get('description'),
                         'tagEnemyZombieA01')

    def test_missing_name_preserves_original_tag_and_no_text_for_boars(self):
        files = gen.configured_plan('boar')
        self.assertNotIn(gen.TEXT_SOURCE, files)
        monster = DBR(files[Path('database/records/creatures/enemies/monsterexpansion/boar_veteran_01.dbr')])
        self.assertEqual(monster.get('description'), 'tagEnemyBoarA01')

    def test_invalid_label_rejected_and_suffix_uses_tier_config(self):
        for name in ('', 'two\nlines', 'bad=value', ' leading'):
            with self.assertRaises(gen.GenerationError):
                gen.display_text({'display_name': name}, {'name': 'Veteran'})
        self.assertEqual(gen.display_text({'display_name': 'Example'}, {'name': 'Elite'}),
                         'Example (Elite)')
