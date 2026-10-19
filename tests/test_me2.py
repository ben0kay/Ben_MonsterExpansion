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


if __name__ == "__main__":
    unittest.main()
