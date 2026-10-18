"""ME2 generator safety/functional tests using checked-in boar reference files."""
import hashlib
import json
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "scripts"))
import generate_variants as gen
from dbr import DBR, DBRError
from validate_config import reference_path


class DBRTests(unittest.TestCase):
    def test_preserves_other_fields(self):
        record = DBR("a,old,\r\nb,other,\r\n")
        record.set("a", "new")
        self.assertEqual(record.render(), "a,new,\r\nb,other,\r\n")

    def test_duplicates_rejected(self):
        with self.assertRaises(DBRError):
            DBR("a,one,\na,two,\n").set("a", "three")

    def test_missing_key_rejected(self):
        with self.assertRaises(DBRError):
            DBR("a,one,\n").set("b", "two")

    def test_unsafe_reference_rejected(self):
        for p in ["records/../evil.dbr", "/etc/passwd", "records/foo\\bad.dbr"]:
            with self.subTest(p=p), self.assertRaises(ValueError):
                reference_path(p, REPO / "ReferenceFiles")

    def test_numeric_series(self):
        self.assertEqual(gen.scaled_series("10.000000;20.000000", 1.1),
                         "11.000000;22.000000")
        with self.assertRaises(gen.GenerationError):
            gen.scaled_series("10;a", 1.1)


class VariantTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.family = json.loads((REPO / "config/families/boar.json").read_text(encoding="utf-8"))
        cls.tier = next(t for t in json.loads((REPO / "config/tiers.json").read_text(encoding="utf-8"))["tiers"]
                        if t["id"] == "veteran")

    def test_builds_three_records_and_manifest(self):
        files = gen.build_variant(self.family, self.tier)
        self.assertEqual(len(files), 4)
        monster_path = gen.game_location(self.family["first_prototype"]["future_output_record"])
        monster = DBR(files[monster_path])
        self.assertEqual(monster.get("monsterClassification"), "Common")
        self.assertEqual(monster.get("scale"), "1.100000")
        self.assertEqual(monster.get("actorRadius"), "0.750000")
        self.assertEqual(monster.get("description"), "tagEnemyBoarA01")
        self.assertIn("monsterexpansion/bios/", monster.get("characterAttributeEquations"))
        self.assertIn("monsterexpansion/boar_veteran_01_damage.dbr", monster.get("skillName2"))
        bio_path = gen.game_location(monster.get("characterAttributeEquations"))
        bio = DBR(files[bio_path])
        self.assertIn("*1.3", bio.get("characterLife"))
        self.assertIn("*1.08", bio.get("characterDefensiveAbility"))
        skill_path = gen.game_location(monster.get("skillName2"))
        damage = DBR(files[skill_path])
        vanilla_damage = DBR.from_file(REPO / "ReferenceFiles/skills/nonplayerskills/passive/damagebase_physical01.dbr")
        for name in ("offensivePhysicalMin", "offensivePhysicalMax"):
            expected = gen.scaled_series(vanilla_damage.get(name), 1.1)
            self.assertEqual(damage.get(name), expected)
        manifest = json.loads(files[Path("manifest.json")])
        self.assertIn("spawn pool integration", manifest["not_implemented"])
        self.assertNotIn("records/proxies", "\n".join(map(str, files)))

    def test_deterministic_and_no_reference_changes(self):
        watched = [REPO / "ReferenceFiles/creatures/enemies/boar_a01.dbr",
                   REPO / "ReferenceFiles/creatures/enemies/bios/bio_boar_01.dbr",
                   REPO / "ReferenceFiles/skills/nonplayerskills/passive/damagebase_physical01.dbr"]
        before = [hashlib.sha256(p.read_bytes()).hexdigest() for p in watched]
        first = gen.build_variant(self.family, self.tier)
        self.assertEqual(first, gen.build_variant(self.family, self.tier))
        self.assertEqual(before, [hashlib.sha256(p.read_bytes()).hexdigest() for p in watched])

    def test_write_guards_and_idempotence(self):
        files = gen.build_variant(self.family, self.tier)
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp) / "generated/MonsterExpansion"
            with patch.object(gen, "OUTPUT", root):
                gen.write_staged(files, root)
                gen.write_staged(files, root)
                original = (root / Path("manifest.json")).read_text(encoding="utf-8")
                changed = dict(files)
                changed[Path("manifest.json")] = "changed\n"
                with self.assertRaises(gen.GenerationError):
                    gen.write_staged(changed, root)
                self.assertEqual(original, (root / "manifest.json").read_text(encoding="utf-8"))
                gen.write_staged(changed, root, overwrite=True)
                self.assertEqual((root / "manifest.json").read_text(encoding="utf-8"), "changed\n")
                with self.assertRaises(gen.GenerationError):
                    gen.write_staged(files, Path(tmp) / "elsewhere")


if __name__ == "__main__":
    unittest.main()
