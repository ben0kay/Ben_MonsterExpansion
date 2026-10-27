"""Champion discovery and merged-pool probability/eligibility regression checks."""
import copy
from fractions import Fraction
import json
from pathlib import Path
import re
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
import discover_veterans as scan
import generate_variants as gen
import natural_spawns as spawns
from dbr import DBR
from validate_config import reference_path
from test_natural_spawns import catalog


class EliteTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.families, cls.tiers = catalog()
        cls.files = gen.configured_plan(include_spawns=True)
        cls.elites = next(f for f in cls.families if f['id'] == 'discovered_elites')

    def test_complete_merged_catalog_preserves_every_other_field_and_probability(self):
        """Independent oracle over final output, including pools shared by both tiers."""
        by_pool = {}
        for family in [f for f in self.families if f['id'] != 'discovered_ascended']:
            variants = {v['id']: v for v in family['variants']}
            for pool in family['pools']:
                for entry in pool['promotions']:
                    variant = variants[entry['variant']]
                    group = '' if variant['tier'] == 'veteran' else 'Champion'
                    by_pool.setdefault(pool['record'], {}).setdefault(group, []).append((entry, variant))
        shared = 0
        for record, groups in by_pool.items():
            with self.subTest(pool=record):
                original = scan.Index(gen.REFERENCE).read(record)
                two_tier = getattr(self, '_two_tier', None)
                if two_tier is None:
                    self._two_tier = gen.build_plan([f for f in self.families if f['id'] != 'discovered_ascended'], self.tiers, include_spawns=True)
                output = DBR(self._two_tier[gen.game_location(record)])
                expected = dict(original)
                shared += len(groups) == 2
                for group, entries in groups.items():
                    ratio = Fraction(1, 5) if not group else Fraction(33, 100)
                    slots = [int(m.group(1)) for k in original if (m := re.fullmatch('name' + group + r'(\d+)', k))]
                    old_total = sum(int(original[f'weight{group}{i}']) for i in slots)
                    for i in slots:
                        expected[f'weight{group}{i}'] = str(int(original[f'weight{group}{i}']) * ratio.denominator)
                    for entry, variant in entries:
                        a, b = entry['source_slot'], entry['output_slot']
                        weight = int(original[f'weight{group}{a}'])
                        expected[f'weight{group}{a}'] = str(weight * (ratio.denominator - ratio.numerator))
                        expected[f'weight{group}{b}'] = str(weight * ratio.numerator)
                        expected[f'name{group}{b}'] = variant['output_record']
                        for stem in ('levelVarianceEquation', 'minPlayerLevel', 'maxPlayerLevel', 'limit'):
                            if f'{stem}{group}{a}' in original and (stem != 'limit' or original[f'{stem}{group}{a}'] not in ('', '0', '0.000000')):
                                expected[f'{stem}{group}{b}'] = original[f'{stem}{group}{a}']
                        promoted = int(output.get(f'weight{group}{b}'))
                        retained = int(output.get(f'weight{group}{a}'))
                        self.assertEqual(Fraction(promoted, promoted + retained), ratio)
                        self.assertEqual(Fraction(promoted + retained, old_total * ratio.denominator), Fraction(weight, old_total))
                values = {line.split(',')[0]: line.split(',')[1] for line in output.lines if ',' in line}
                self.assertEqual(values, expected)
        self.assertEqual(shared, 212)

    def test_veteran_records_and_regular_selections_preserved_in_combined_build(self):
        veterans = [f for f in self.families if f['id'] not in ('discovered_elites', 'discovered_ascended')]
        old = gen.build_plan(veterans, self.tiers, include_spawns=True)
        for path, text in old.items():
            if path.name == 'manifest.json':
                continue
            if '/proxies/' not in path.as_posix():
                self.assertEqual(self.files[path], text, str(path))
            else:
                now = DBR(self.files[path])
                for line in DBR(text).lines:
                    key = line.split(',')[0]
                    if not re.fullmatch(r'weightChampion\d+', key):
                        self.assertEqual(now.get(key), line.split(',')[1], str(path))

    def test_elite_stats_skills_classification_and_golden_particle(self):
        variant = self.elites['variants'][0]
        monster = DBR(self.files[gen.game_location(variant['output_record'])])
        parent = gen.read_game_dbr(variant['source_record'])
        self.assertEqual(monster.get('monsterClassification'), 'Champion')
        self.assertEqual(monster.get('description'), parent.get('description'))
        bio = DBR(self.files[gen.game_location(monster.get('characterAttributeEquations'))])
        original_bio = gen.read_game_dbr(parent.get('characterAttributeEquations'))
        self.assertEqual(bio.get('characterLife'), '(' + original_bio.get('characterLife') + ')*1.3')
        self.assertEqual(bio.get('characterDefensiveAbility'), '(' + original_bio.get('characterDefensiveAbility') + ')*1.12')
        for key in ('actorRadius', 'actorHeight'):
            self.assertEqual(monster.get(key), parent.get(key))
        for line in parent.lines:
            key, value = line.split(',')[:2]
            if key.startswith('skillName') and value != variant['damage_skill_source_record']:
                self.assertEqual(monster.get(key), value)
        self.assertAlmostEqual(float(monster.get('scale')), float(parent.get('scale')) * 1.1)
        prefix = self.elites['id'] + '_' + variant['id']
        damage = DBR(self.files[Path(f'database/records/skills/nonplayerskills/monsterexpansion/{prefix}_damage.dbr')])
        source_damage = gen.read_game_dbr(variant['damage_skill_source_record'])
        for key in ('offensivePhysicalMin', 'offensivePhysicalMax'):
            for before, after in zip(source_damage.get(key).split(';'), damage.get(key).split(';')):
                self.assertAlmostEqual(float(after), float(before) * 1.18, places=5)
        effect = DBR(self.files[Path(f'database/records/fx/monsterexpansion/{prefix}_cosmetic_fx.dbr')])
        self.assertEqual(effect.get('effectFile'), 'fx/particlesystems/creature/pfx_goldenglow01_large.pfx')

    def test_single_elite_boar_low_health_rage_is_opt_in_and_reversible(self):
        target = next(v for v in self.elites["variants"]
                      if v["source_record"] == "records/creatures/enemies/boar_b01.dbr")
        prefix = self.elites["id"] + "_" + target["id"]
        monster = DBR(self.files[gen.game_location(target["output_record"])])
        original = gen.read_game_dbr(target["source_record"])
        source_skills = {original.get(f"skillName{n}")
                         for n in range(1, 61) if original._locations(f"skillName{n}")}
        generated_skills = {monster.get(f"skillName{n}")
                            for n in range(1, 61) if monster._locations(f"skillName{n}")}
        # Existing attacks remain; the source damage passive is intentionally cloned.
        source_skills.remove(target["damage_skill_source_record"])
        self.assertTrue(source_skills <= generated_skills)
        self.assertIn(f"{prefix}_cosmetic.dbr", monster.get("initialSkillName"))
        rage_path = f"records/skills/nonplayerskills/monsterexpansion/{prefix}_rage.dbr"
        self.assertEqual(monster.get("skillName8"), rage_path)
        self.assertEqual(monster.get("skillLevel8"), "1")
        rage = DBR(self.files[gen.game_location(rage_path)])
        self.assertEqual(rage.get("templateName"),
                         "database/templates/skill_passiveonlifebuffself.tpl")
        self.assertEqual(rage.get("Class"), "Skill_PassiveOnLifeBuffSelf")
        for key, value in (("lifeMonitorPercent", 30),
                           ("skillActiveDuration", 12),
                           ("skillCooldownTime", 180),
                           ("offensiveTotalDamageModifier", 15),
                           ("characterRunSpeedModifier", 10)):
            self.assertAlmostEqual(float(rage.get(key)), value)
        self.assertEqual(rage.get("skillActivatedAuraName"),
                         "records/fx/skillsother/buff/dranghoul_laststand_selfloop_fx01.dbr")
        for bad in ("skillSpecialAnimationName", "skillActivatedSound",
                    "defensiveStun", "damageAbsorption", "damageAbsorptionPercent"):
            self.assertFalse(rage._locations(bad), bad)
        self.assertGreater(
            len([p for p in self.files if p.name.endswith("_rage.dbr")]), 1)

        tiers = copy.deepcopy(self.tiers)
        tiers["elite"]["prototype"]["low_health_rage"]["enabled"] = False
        rollback = gen.build_variant(self.elites, target, tiers["elite"])
        self.assertNotIn(gen.game_location(rage_path), rollback)
        restored = DBR(rollback[gen.game_location(target["output_record"])])
        self.assertFalse(any("_rage.dbr" in x for x in restored.lines))
        self.assertEqual(restored.get("skillName5"), original.get("skillName5"))
        self.assertEqual(restored.get("skillName6"), original.get("skillName6"))

    def test_all_compatible_elites_and_ascended_receive_rage(self):
        totals = {"elite": 0, "ascended": 0}
        assigned = {"elite": 0, "ascended": 0}
        excluded = {"elite": 0, "ascended": 0}
        for family in self.families:
            for variant in family["variants"]:
                monster = DBR(self.files[gen.game_location(variant["output_record"])])
                rage_skills = [monster.get(f"skillName{n}") for n in range(1, 61)
                               if monster._locations(f"skillName{n}")
                               and monster.get(f"skillName{n}").endswith("_rage.dbr")]
                tier = variant["tier"]
                if tier in totals:
                    totals[tier] += 1
                    parent = gen.read_game_dbr(variant["source_record"])
                    if gen.has_low_health_skill(parent):
                        excluded[tier] += 1
                        self.assertFalse(rage_skills, variant["output_record"])
                    else:
                        assigned[tier] += 1
                        self.assertEqual(len(rage_skills), 1, variant["output_record"])
                        buff = DBR(self.files[gen.game_location(rage_skills[0])])
                        self.assertEqual(float(buff.get("lifeMonitorPercent")), 30.0)
                        self.assertEqual(float(buff.get("skillActiveDuration")), 12.0)
                        self.assertEqual(float(buff.get("offensiveTotalDamageModifier")), 15.0)
                else:
                    self.assertFalse(rage_skills, variant["output_record"])
        self.assertEqual(totals, {"elite": 124, "ascended": 137})
        self.assertEqual(sum(totals.values()), 261)
        manifest = json.loads(self.files[Path("manifest.json")])
        for tier in totals:
            self.assertEqual(assigned[tier] + excluded[tier], totals[tier])
            self.assertGreater(assigned[tier], 0)
            summary = manifest["rage_coverage"][tier]
            self.assertEqual(summary["targeted"], totals[tier])
            self.assertEqual(summary["attached"], assigned[tier])
            self.assertEqual(summary["inherited_low_health"], excluded[tier])
            self.assertEqual(summary["no_free_slot"], 0)

    def test_ascended_rage_toggle_rollback_and_no_native_hero_override(self):
        tiers = copy.deepcopy(self.tiers)
        family = next(f for f in self.families if f["id"] == "discovered_ascended")
        chosen = next(v for v in family["variants"]
                      if not gen.has_low_health_skill(gen.read_game_dbr(v["source_record"])))
        parent = gen.read_game_dbr(chosen["source_record"])
        output_path = gen.game_location(chosen["output_record"])
        actual = DBR(self.files[output_path])
        self.assertEqual(actual.get("monsterClassification"), "Hero")
        expected_rage_path = gen.game_location(
            f"records/skills/nonplayerskills/monsterexpansion/{family['id']}_{chosen['id']}_rage.dbr")
        self.assertIn(expected_rage_path, self.files)

        tiers["ascended"]["prototype"]["low_health_rage"]["enabled"] = False
        rollback = gen.build_variant(family, chosen, tiers["ascended"])
        self.assertNotIn(expected_rage_path, rollback)
        restored = DBR(rollback[output_path])
        self.assertFalse(any("_rage.dbr" in line for line in restored.lines
                             if line.startswith("skillName")))
        # The Ascended monster is built from the original Hero's skill set.
        for slot in range(1, 61):
            name = f"skillName{slot}"
            if parent._locations(name):
                original_skill = parent.get(name)
                if original_skill != chosen["damage_skill_source_record"]:
                    self.assertEqual(restored.get(name), original_skill)
        # There are no original Hero actor overrides in the generated mod.
        for path in self.files:
            self.assertFalse(path.as_posix().startswith("database/records/creatures/enemies/hero/"))
            self.assertNotIn("nativehero_", path.as_posix())
        manifest = json.loads(self.files[Path("manifest.json")])
        self.assertNotIn("native_hero_rage", manifest)

    def test_conflicting_shared_mappings_rejected_and_disabling_elites_keeps_veterans(self):
        elite_pool = next(p for p in self.elites['pools'] if any(p['record'] == q['record'] for f in self.families if f != self.elites for q in f['pools']))
        others = [(f, p) for f in self.families if f != self.elites for p in f['pools'] if p['record'] == elite_pool['record']]
        with self.assertRaises(ValueError):
            spawns.build_merged_pool([(self.elites, elite_pool), (self.elites, elite_pool)], self.tiers, gen.REFERENCE)
        disabled = dict(elite_pool, enabled=False)
        _, merged, _ = spawns.build_merged_pool(others + [(self.elites, disabled)], self.tiers, gen.REFERENCE)
        _, original, _ = spawns.build_merged_pool(others, self.tiers, gen.REFERENCE)
        self.assertEqual(merged, original)
        wrong = copy.deepcopy(self.elites); wrong['variants'][0]['expected_classification'] = 'Common'
        with self.assertRaises(gen.GenerationError):
            gen.build_variant(wrong, wrong['variants'][0], self.tiers['elite'])

    def test_discovery_is_exact_parent_and_refuses_quotas_unknown_rules_and_full_slots(self):
        policy = json.loads((gen.REPO / 'config/discovery_elites.json').read_text())
        source = self.elites['variants'][0]['source_record']
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            def put(record, text):
                path = root / record.removeprefix('records/'); path.parent.mkdir(parents=True, exist_ok=True); path.write_text(text)
            index = scan.Index(gen.REFERENCE)
            todo, seen = [source], set()
            # Copy just the referenced monster, bio and skills for the compatibility check.
            while todo:
                record = todo.pop()
                if record in seen: continue
                seen.add(record); data = index.read(record)
                put(record, reference_path(record, gen.REFERENCE).read_text())
                if record == source:
                    todo += [v for k, v in data.items() if k == 'characterAttributeEquations' or re.fullmatch(r'skillName\d+', k)]
            pool = 'records/proxies/pools/p_test.dbr'
            proxy = 'records/proxies/area001/test.dbr'
            put(proxy, f'templateName,database/templates/proxy.tpl,\npool1,{pool},\n')
            base = f'templateName,database/templates/proxypool.tpl,\nnameChampion1,{source},\nweightChampion1,100,\n'
            put(pool, base)
            run = lambda: scan.discover(root, [], policy)
            report = run(); self.assertEqual(report['summary']['candidate_sources'], 1)
            self.assertEqual(scan.draft_config(report)['variants'][0]['expected_classification'], 'Champion')
            for field, reason in [('limitChampion1', 'limited_or_forced_entry'), ('alwaysSpawnChampion1', 'limited_or_forced_entry'), ('unknownChampion1', 'unsupported_slot_rule_fields')]:
                put(pool, base + f'{field},1,\n')
                self.assertIn(reason, run()['entries'][0]['reasons'])
            put(pool, base + ''.join(f'minPlayerLevelChampion{i},1,\n' for i in range(2, 16)))
            self.assertIn('no_free_pool_slot', run()['entries'][0]['reasons'])
            put(pool, base)
            for classification in ('Common', 'Hero', 'Quest', 'Boss'):
                put(source, reference_path(source, gen.REFERENCE).read_text().replace('monsterClassification,Champion,', f'monsterClassification,{classification},'))
                self.assertIn('not_champion', run()['entries'][0]['reasons'])
