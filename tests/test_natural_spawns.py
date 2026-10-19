"""Exact conditional weight conversion, rules preservation and safe rollback."""
import copy
from fractions import Fraction
import json
from pathlib import Path
import re
import sys
import tempfile
import unittest

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / 'scripts'))
import generate_variants as gen
import natural_spawns as spawns
from dbr import DBR
from validate_config import reference_path


def catalog():
    families = [json.loads(p.read_text()) for p in sorted((REPO / 'config/families').glob('*.json'))]
    tiers = {t['id']: t for t in json.loads((REPO / 'config/tiers.json').read_text())['tiers']}
    return families, tiers


class NaturalSpawnTests(unittest.TestCase):
    def test_every_pool_conserves_weight_rules_and_higher_tiers(self):
        families, tiers = catalog()
        for family in families:
            for config in family['pools']:
                with self.subTest(pool=config['record']):
                    record, text, _ = spawns.build_pool_override(family, config, tiers, gen.REFERENCE)
                    original = DBR.from_file(reference_path(record, gen.REFERENCE)); result = DBR(text)
                    slots = [int(line.split(',')[0][4:]) for line in original.lines
                             if re.fullmatch(r'name\d+', line.split(',')[0])]
                    mapped = {p['source_slot']: p for p in config['promotions']}
                    old_total = sum(int(original.get(f'weight{i}')) for i in slots)
                    new_slots = slots + [p['output_slot'] for p in config['promotions']]
                    new_total = sum(int(result.get(f'weight{i}')) for i in new_slots)
                    for i in slots:
                        old = int(original.get(f'weight{i}'))
                        new = int(result.get(f'weight{i}'))
                        if i in mapped:
                            p = mapped[i]; target = p['output_slot']
                            promoted = int(result.get(f'weight{target}'))
                            self.assertEqual(Fraction(promoted, new + promoted), Fraction(1, 5))
                            self.assertEqual(Fraction(new + promoted, new_total), Fraction(old, old_total))
                            for stem in ('levelVarianceEquation', 'minPlayerLevel', 'maxPlayerLevel'):
                                if original._locations(f'{stem}{i}'):
                                    self.assertEqual(result.get(f'{stem}{target}'), original.get(f'{stem}{i}'))
                        else:
                            self.assertEqual(Fraction(new, new_total), Fraction(old, old_total))
                    # Every existing field except regular weight is byte-value identical.
                    for line in original.lines:
                        key = line.split(',')[0]
                        if not re.fullmatch(r'weight\d+', key):
                            self.assertEqual(result.get(key), original.get(key))

    def test_starter_max_level_is_inherited(self):
        families, tiers = catalog(); zombie = next(f for f in families if f['id'] == 'zombie')
        pool = next(p for p in zombie['pools'] if p['record'].endswith('/p_zombie_e.dbr'))
        _, text, _ = spawns.build_pool_override(zombie, pool, tiers, gen.REFERENCE)
        self.assertEqual(DBR(text).get('maxPlayerLevel5'), '3')
        # Other source starter slot had no max; do not invent a gate for its promotion.
        self.assertFalse(DBR(text)._locations('maxPlayerLevel6'))

    def test_disabled_pool_emits_exact_vanilla_for_incremental_build_rollback(self):
        families, tiers = catalog()
        for family in families:
            for config in family['pools']:
                disabled = dict(config, enabled=False)
                record, text, report = spawns.build_pool_override(family, disabled, tiers, gen.REFERENCE)
                self.assertEqual(text, reference_path(record, gen.REFERENCE).read_text())
                self.assertTrue(report['rollback_vanilla_pool'])

    def test_limited_source_and_occupied_target_refused(self):
        families, tiers = catalog(); zombie = next(f for f in families if f['id'] == 'zombie')
        config = copy.deepcopy(zombie['pools'][0])
        config['promotions'] = [{'source_slot': 4, 'variant': 'veteran_01', 'output_slot': 5}]
        with self.assertRaises(ValueError):
            spawns.build_pool_override(zombie, config, tiers, gen.REFERENCE)
        config = copy.deepcopy(zombie['pools'][0]); config['promotions'][0]['output_slot'] = 2
        with self.assertRaises(ValueError):
            spawns.build_pool_override(zombie, config, tiers, gen.REFERENCE)

    def test_pool_selection_does_not_mutate_references(self):
        families, tiers = catalog()
        before = {p: p.read_bytes() for f in families for p in
                  [reference_path(c['record'], gen.REFERENCE) for c in f['pools']]}
        gen.configured_plan(include_spawns=True)
        self.assertTrue(all(p.read_bytes() == text for p, text in before.items()))
