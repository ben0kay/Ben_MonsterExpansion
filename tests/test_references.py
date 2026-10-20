"""DLC precedence must affect reads, discovery and output names consistently."""
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from references import layers, resolve, records
from validate_config import reference_path
import generate_variants as gen


class ReferenceTests(unittest.TestCase):
    def test_priority_and_fallback(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); choices = layers(root)
            for i, layer in enumerate(reversed(choices)):
                p = layer / 'creatures/test.dbr'; p.parent.mkdir(parents=True, exist_ok=True); p.write_text(str(i))
                self.assertEqual(reference_path('records/creatures/test.dbr', root), p)
            choices[0].joinpath('creatures/test.dbr').unlink()
            self.assertEqual(resolve('records/creatures/test.dbr', root), choices[1] / 'creatures/test.dbr')

    def test_discovery_deduplicates_and_includes_expansion_namespaces(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            for layer in layers(root):
                p = layer / 'proxies/pools/shared.dbr'; p.parent.mkdir(parents=True); p.write_text('')
            p = layers(root)[0] / 'proxies/poolsgdx2/new.dbr'; p.parent.mkdir(); p.write_text('')
            self.assertEqual(records(root), ['records/proxies/pools/shared.dbr', 'records/proxies/poolsgdx2/new.dbr'])

    def test_output_keeps_logical_game_path(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); p = layers(root)[0] / 'creatures/test.dbr'; p.parent.mkdir(parents=True); p.write_text('')
            with patch.object(gen, 'REFERENCE', root):
                self.assertEqual(gen.game_location('records/creatures/test.dbr'), Path('database/records/creatures/test.dbr'))

    def test_unsafe_override_never_falls_back(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); p = layers(root)[0] / 'creatures/test.dbr'; p.parent.mkdir(parents=True)
            p.symlink_to(root / 'missing')
            with self.assertRaises(ValueError): resolve('records/creatures/test.dbr', root)
            with self.assertRaises(ValueError): resolve('records/../escape.dbr', root)

    def test_all_active_pool_fields_match_effective_dlc_sources(self):
        import re
        from fractions import Fraction
        from dbr import DBR
        from natural_spawns import build_pool_override
        families = [json.loads(p.read_text()) for p in (gen.REPO / 'config/families').glob('*.json')]
        tiers = {t['id']: t for t in json.loads((gen.REPO / 'config/tiers.json').read_text())['tiers']}
        def values(text):
            return {line.split(',', 2)[0]: line.split(',', 2)[1] for line in text.splitlines() if ',' in line}
        for family in families:
            variants = {v['id']: v for v in family['variants']}
            for config in family['pools']:
                with self.subTest(pool=config['record']):
                    original = values(reference_path(config['record'], gen.REFERENCE).read_text(encoding='utf-8-sig'))
                    expected = dict(original)
                    if config['enabled']:
                        share = Fraction(str(tiers['veteran']['prototype']['natural_spawns']['common_conversion_share']))
                        for key, value in original.items():
                            if re.fullmatch(r'weight\d+', key): expected[key] = str(int(value) * share.denominator)
                        for entry in config['promotions']:
                            a, b = str(entry['source_slot']), str(entry['output_slot'])
                            expected['weight'+a] = str(int(original['weight'+a]) * (share.denominator-share.numerator))
                            expected['weight'+b] = str(int(original['weight'+a]) * share.numerator)
                            expected['name'+b] = variants[entry['variant']]['output_record']
                            for stem in ('levelVarianceEquation', 'minPlayerLevel', 'maxPlayerLevel'):
                                if stem+a in original: expected[stem+b] = original[stem+a]
                    _, output, _ = build_pool_override(family, config, tiers, gen.REFERENCE)
                    self.assertEqual(values(output), expected)
