"""Custom tier labels are generated only for cloned monsters from exact English tags."""
import json
from pathlib import Path
import sys
import unittest

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "scripts"))
import generate_variants as gen
from creature_names import creature_name
from dbr import DBR


class DisplayNameTests(unittest.TestCase):
    def test_creature_names_from_all_three_localization_layers(self):
        self.assertEqual(creature_name("tagEnemyBoarA01", gen.REFERENCE), "Stonetusk")
        self.assertEqual(creature_name("tagEnemyZombieA01", gen.REFERENCE), "Walking Dead")
        self.assertEqual(creature_name("tagGDX1HeroAscended_H01", gen.REFERENCE),
                         "Pavros Undylon, Flamespeaker")
        self.assertEqual(creature_name("tagGDX2HeroSandLizard_H03", gen.REFERENCE),
                         "Plagnius ~ Diseased")

    def test_existing_zombie_names_still_work_and_boars_now_resolve(self):
        files = gen.configured_plan(include_spawns=True)
        tags = dict(line.split("=", 1) for line in files[gen.TEXT_SOURCE].splitlines())
        for name in ("zombie_veteran_01", "zombie_veteran_starter_01"):
            path = Path(f"database/records/creatures/enemies/monsterexpansion/{name}.dbr")
            monster = DBR(files[path])
            self.assertEqual(tags[monster.get("description")], "Walking Dead (Veteran)")
        for name in ("boar_veteran_01", "boar_veteran_02"):
            path = Path(f"database/records/creatures/enemies/monsterexpansion/{name}.dbr")
            monster = DBR(files[path])
            self.assertEqual(tags[monster.get("description")], "Stonetusk (Veteran)")
        self.assertEqual(gen.read_game_dbr("records/creatures/enemies/zombie_a01.dbr")
                         .get("description"), "tagEnemyZombieA01")
        self.assertFalse(any(tag.startswith("tagEnemy") for tag in tags))

    def test_all_enabled_variant_names_covered_without_fabricating_unknowns(self):
        files = gen.configured_plan()
        manifest = json.loads(files[Path("manifest.json")])
        coverage = manifest["name_coverage"]
        tags = dict(line.split("=", 1) for line in files[gen.TEXT_SOURCE].splitlines())
        self.assertEqual(coverage["named"], len(tags))
        self.assertEqual(coverage["named"] + len(coverage["unresolved"]),
                         len(manifest["variants"]))
        self.assertEqual(coverage["unresolved"], [],
                         "Find missing original/GDX1/GDX2 creature translations before claiming all names")
        for entry in manifest["variants"]:
            path = Path("database") / entry["output"]
            monster = DBR(files[path])
            label = tags[monster.get("description")]
            self.assertTrue(label.endswith(" (" + entry["tier"].capitalize() + ")"),
                            entry["output"])

    def test_invalid_label_and_unresolved_fallback(self):
        for name in ("", "two\nlines", "bad=value", " leading"):
            with self.assertRaises(gen.GenerationError):
                gen.display_text({"display_name": name}, {"name": "Veteran"})
        self.assertEqual(gen.display_text({"display_name": "Example"}, {"name": "Elite"}),
                         "Example (Elite)")
        self.assertIsNone(gen.display_text({}, {"name": "Veteran"}, "tagUnknownNeverExists"))
