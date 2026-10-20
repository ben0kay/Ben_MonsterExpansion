#!/usr/bin/env python3
"""Read-only Common-enemy discovery; optional reports/disabled drafts under generated/."""
import argparse
from fractions import Fraction
from collections import Counter, defaultdict
from decimal import Decimal, InvalidOperation
import hashlib
import json
from pathlib import Path
import re
import sys

from dbr import DBR, DBRError
import generate_variants as gen
from validate_config import reference_path

REPO = Path(__file__).resolve().parents[1]
OUTPUT = REPO / 'generated/discovery'


class Index:
    def __init__(self, root):
        self.root = Path(root)
        self.cache = {}

    def read(self, record):
        if record not in self.cache:
            path = reference_path(record, self.root)
            if not path.is_file() or any(p.is_symlink() for p in (path, *path.parents)):
                raise ValueError(f'Missing/unsafe reference: {record}')
            dbr = DBR.from_file(path)
            values = {}
            for line in dbr.lines:
                key = line.split(',')[0]
                if ',' in line:
                    if key in values:
                        raise ValueError(f'Duplicate field {key}: {record}')
                    parts = line.split(',', 2)
                    if len(parts) != 3: raise ValueError(f'Malformed field {key}: {record}')
                    values[key] = parts[1]
            self.cache[record] = values
        return self.cache[record]

    def record(self, path):
        return 'records/' + path.relative_to(self.root).as_posix()


def text_tags(root):
    """Read extracted English tag files only; ambiguous values never guessed."""
    values, count, errors = defaultdict(set), 0, []
    if root is not None and root.is_dir():
        for path in sorted(root.rglob('*.txt')):
            if path.is_symlink():
                continue
            try:
                raw = path.read_bytes()
                text = raw.decode('utf-16' if raw.startswith((b'\xff\xfe', b'\xfe\xff')) else 'utf-8-sig')
                count += 1
                for line in text.splitlines():
                    if '=' not in line or line.lstrip().startswith(('#', '//')):
                        continue
                    key, value = line.split('=', 1)
                    if re.fullmatch(r'tag[A-Za-z0-9_]+', key.strip()) and value.strip():
                        values[key.strip()].add(value.strip())
            except (OSError, UnicodeError) as exc:
                errors.append(f'{path.name}: {type(exc).__name__}')
    return ({k: next(iter(v)) for k, v in values.items() if len(v) == 1},
            {'files_read': count, 'ambiguous_tags': sorted(k for k, v in values.items() if len(v) > 1),
             'read_errors': errors})


def numeric_series(raw):
    chunks = raw.split(';')
    if not chunks or any(not x or not Decimal(x).is_finite() for x in chunks):
        raise ValueError('Invalid numeric damage series')


def source_compatibility(index, record, excluded, scale_factor=1.1):
    """Mirror the currently supported bio/passive/cosmetic generator operations."""
    if not record.startswith('records/creatures/enemies/') or excluded.search(record):
        return {'reasons': ['special_or_nonordinary_source']}
    try:
        data = index.read(record)
        if data.get('templateName') != 'database/templates/monster.tpl':
            return {'reasons': ['not_monster_template']}
        if data.get('monsterClassification') != 'Common':
            return {'reasons': ['not_common']}
        reasons = []
        if data.get('quest', '') not in ('', '0', '0.000000'):
            reasons.append('quest_marked_source')
        if any('.lua' in value.lower() for value in data.values()):
            reasons.append('scripted_source_review')
        bio_record = data.get('characterAttributeEquations', '')
        if not bio_record.startswith('records/creatures/enemies/bios/'):
            reasons.append('unsupported_bio_path')
        else:
            bio = index.read(bio_record)
            if bio.get('templateName') != 'database/templates/characterattributeequations.tpl':
                reasons.append('unsupported_bio_template')
            for key in ('characterLife', 'characterDefensiveAbility'):
                if not bio.get(key, '').strip() or ';' in bio[key]:
                    reasons.append('unsupported_bio_equation')
        scale = Decimal(data.get('scale', 'NaN'))
        if not scale.is_finite() or not Decimal('.1') <= scale * Decimal(str(scale_factor)) <= 20:
            reasons.append('unsupported_model_scale')
        skills = [value for key, value in data.items() if re.fullmatch(r'skillName\d+', key) and value]
        damage = []
        for record_name in skills:
            skill = index.read(record_name)
            if skill.get('templateName') == 'database/templates/skill_passive.tpl' and all(
                    key in skill for key in ('offensivePhysicalMin', 'offensivePhysicalMax')):
                numeric_series(skill['offensivePhysicalMin']); numeric_series(skill['offensivePhysicalMax'])
                nonzero = any(Decimal(v) != 0 for key in ('offensivePhysicalMin', 'offensivePhysicalMax')
                              for v in skill[key].split(';'))
                if nonzero:
                    damage.append(record_name)
        if len(damage) != 1 or skills.count(damage[0]) != 1:
            reasons.append('no_unique_physical_base_passive')
        if not any(f'skillName{i}' not in data and f'skillLevel{i}' not in data for i in range(1, 61)):
            reasons.append('no_free_skill_slot')
        if all(data.get(key) for key in ('initialSkillName', 'initial2SkillName')):
            reasons.append('no_free_initial_slot')
        return {'reasons': sorted(set(reasons)), 'description_tag': data.get('description', ''),
                'bio_record': bio_record, 'damage_skill_source_record': damage[0] if len(damage) == 1 else None}
    except (ValueError, KeyError, OSError, InvalidOperation) as exc:
        return {'reasons': ['missing_or_invalid_dependency'], 'detail': str(exc)}


def occupied_regular_slots(data, maximum):
    # Even a stale field in an unnamed slot reserves that destination.
    occupied = set()
    for key in data:
        match = re.fullmatch(r'(.+?)(\d+)', key)
        if match and 'Champion' not in key and 1 <= int(match.group(2)) <= maximum:
            occupied.add(int(match.group(2)))
    return occupied



def discover(reference_root, families, policy, tags=None, tier=None):
    if (policy.get('schema_version') != 1 or policy.get('source_classification') != 'Common'
            or policy.get('target_tier') != 'veteran' or policy.get('max_pool_slot') != 15
            or not re.fullmatch(r'[a-z][a-z0-9_]*', policy.get('family_id', ''))):
        raise ValueError('Unsupported discovery policy; Common -> Veteran only, template capacity 15')
    tier = tier or next(t for t in json.loads((REPO / "config/tiers.json").read_text())["tiers"]
                        if t["id"] == policy["target_tier"])
    factor = tier["prototype"]["model_scale_vs_parent"]
    denominator = Fraction(str(tier["prototype"]["natural_spawns"]["common_conversion_share"])).denominator
    index = Index(reference_root); tags = tags or {}
    excluded = re.compile(policy['excluded_path_pattern'])
    known_sources = {v['source_record'] for f in families for v in f['variants']}
    owned = {p['record'] for f in families for p in f['pools']}
    mapped = {(p['record'], m['source_slot']) for f in families for p in f['pools'] for m in p['promotions']}
    proxies, blocked_proxies, errors = defaultdict(list), defaultdict(list), []
    for path in sorted((index.root / 'proxies').rglob('*.dbr')):
        record = index.record(path)
        try:
            data = index.read(record)
        except (ValueError, OSError) as exc:
            errors.append({'record': record, 'detail': str(exc)}); continue
        if data.get('templateName') not in ('database/templates/proxy.tpl', 'database/templates/proxyambush.tpl'):
            continue
        target = blocked_proxies if excluded.search(record) else proxies
        for key, value in data.items():
            if re.fullmatch(r'pool\d+', key) and value:
                target[value].append(record)
    rows, checks = [], {}
    for path in sorted((index.root / 'proxies/pools').glob('*.dbr')):
        pool_record = index.record(path)
        try:
            pool = index.read(pool_record)
            if pool.get('templateName') != 'database/templates/proxypool.tpl':
                continue
            free = sorted(set(range(1, policy['max_pool_slot'] + 1)) - occupied_regular_slots(pool, policy['max_pool_slot']))
            weight_ok = True
            try:
                regular_slots = [int(k[4:]) for k in pool if re.fullmatch(r'name\d+', k)]
                weights = [int(pool[f'weight{i}']) for i in regular_slots]
                weight_ok = all(0 <= w <= 2147483647 // denominator for w in weights)
            except (ValueError, KeyError):
                weight_ok = False
            for key in sorted(pool, key=lambda k: int(k[4:]) if re.fullmatch(r'name\d+', k) else 0):
                if not re.fullmatch(r'name\d+', key):
                    continue
                slot = int(key[4:]); source = pool[key]
                if source not in checks:
                    checks[source] = source_compatibility(index, source, excluded, factor)
                check = checks[source]
                row = {'pool': pool_record, 'source_slot': slot, 'source_record': source,
                       'proxy_references': sorted(set(proxies[pool_record])), **check}
                reasons = list(check['reasons'])
                if (pool_record, slot) in mapped:
                    row.update(status='already_mapped', reasons=[])
                else:
                    if source in known_sources: reasons.append('existing_variant_new_pool_mapping_review')
                    if pool_record in owned: reasons.append('existing_pool_merge_review')
                    if excluded.search(pool_record): reasons.append('special_pool_review')
                    if not proxies[pool_record]: reasons.append('no_ordinary_proxy_reference')
                    if blocked_proxies[pool_record]: reasons.append('pool_also_used_by_special_proxy')
                    if not weight_ok: reasons.append('invalid_or_overflow_pool_weights')
                    if 'weight' + str(slot) not in pool or int(pool.get('weight' + str(slot), '0')) <= 0:
                        reasons.append('zero_or_missing_selection_weight')
                    if any(pool.get(stem + str(slot), '') not in ('', '0', '0.000000')
                           for stem in ('limit', 'alwaysSpawn')):
                        reasons.append('limited_or_forced_entry')
                    if not reasons and not free:
                        reasons.append('no_free_pool_slot')
                    row['status'] = 'review_required' if reasons else 'candidate'
                    row['reasons'] = sorted(set(reasons))
                    if not reasons:
                        row['output_slot'] = free.pop(0)
                        # This is an existing English value only, never a guessed name.
                        if check.get('description_tag') in tags:
                            row['display_name'] = tags[check['description_tag']]
                        else:
                            row['name_warning'] = 'english_tag_unresolved_original_name_preserved'
                rows.append(row)
        except (ValueError, KeyError, OSError) as exc:
            errors.append({'record': pool_record, 'detail': str(exc)})
    reasons = Counter(reason for row in rows for reason in row['reasons'])
    candidates = [row for row in rows if row['status'] == 'candidate']
    return {'schema_version': 1, 'policy': policy, 'summary': {
        'regular_entries_examined': len(rows), 'unique_sources_examined': len(checks),
        'candidate_entries': len(candidates), 'candidate_sources': len({r['source_record'] for r in candidates}),
        'candidate_pools': len({r['pool'] for r in candidates}),
        'already_mapped_entries': sum(r['status'] == 'already_mapped' for r in rows),
        'review_required_entries': sum(r['status'] == 'review_required' for r in rows),
        'reason_counts': dict(sorted(reasons.items())), 'read_errors': len(errors)},
        'entries': rows, 'read_errors': errors,
        'warning': 'Mechanical candidates only; disabled drafts are not active mod content or runtime proof.'}


def draft_config(report):
    fid = report['policy']['family_id']
    variants, pools = {}, {}
    for row in report['entries']:
        if row['status'] != 'candidate': continue
        source = row['source_record']
        vid = 'veteran_' + hashlib.sha256(source.encode()).hexdigest()[:16]
        if source not in variants:
            variants[source] = {'id': vid, 'tier': 'veteran', 'source_record': source,
                                'expected_classification': 'Common',
                                'output_record': f'records/creatures/enemies/monsterexpansion/{fid}_{vid}.dbr',
                                'damage_skill_source_record': row['damage_skill_source_record']}
            if 'display_name' in row: variants[source]['display_name'] = row['display_name']
        config = pools.setdefault(row['pool'], {'record': row['pool'], 'enabled': True,
                                                'proxy_references': row['proxy_references'], 'promotions': []})
        config['promotions'].append({'source_slot': row['source_slot'], 'variant': vid,
                                     'output_slot': row['output_slot']})
    return {'schema_version': 2, 'id': fid, 'display_name': 'Discovered Veteran candidates',
            'enabled': False, 'variants': [variants[k] for k in sorted(variants)],
            'pools': [pools[k] for k in sorted(pools)],
            'notes': ['DISABLED DRAFT: review before adding to config/families.',
                      'Unknown English tags keep original names; supply extracted text tags for suffixes.',
                      'New shared-pool mappings are combined once; existing owned pools require separate merge review.']}


def markdown(report):
    summary = report['summary']
    lines = ['# Veteran discovery report', '', report['warning'], '', '| Metric | Count |', '| --- | ---: |']
    for key in ('regular_entries_examined', 'unique_sources_examined', 'candidate_sources', 'candidate_entries',
                'candidate_pools', 'already_mapped_entries', 'review_required_entries', 'read_errors'):
        lines.append(f'| {key} | {summary[key]} |')
    lines += ['', '## Review reasons (one entry can have several)', '', '| Reason | Entries |', '| --- | ---: |']
    lines += [f'| {key} | {value} |' for key, value in summary['reason_counts'].items()]
    text = report.get('english_text', {})
    lines += ['', f"English files read: {text.get('files_read', 0)}. Unknown names are not invented.",
              '', '## Candidate sample (first 30 entries)', '', '| Source | Pool / regular slot |', '| --- | --- |']
    for row in [r for r in report['entries'] if r['status'] == 'candidate'][:30]:
        lines.append(f"| {row['source_record']} | {row['pool']} / {row['source_slot']} |")
    return '\n'.join(lines) + '\n'


def write_outputs(files):
    """Only deterministic disposable discovery output; never live config/game files."""
    for filename in files:
        if Path(filename).name != filename: raise ValueError('Unsafe discovery output name')
    for path in (OUTPUT, *OUTPUT.parents):
        if path.is_symlink(): raise ValueError('Linked discovery output directory')
    for filename in files:
        path = OUTPUT / filename
        if path.is_symlink() or (path.exists() and not path.is_file()): raise ValueError('Unsafe output file')
    OUTPUT.mkdir(parents=True, exist_ok=True)
    for filename, text in files.items(): (OUTPUT / filename).write_text(text, encoding='utf-8')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--write-report', action='store_true', help='Write JSON and Markdown under generated/discovery')
    parser.add_argument('--draft-config', action='store_true', help='Also write a disabled draft family, never activate it')
    parser.add_argument('--text-root', type=Path, help='Extracted English tag directory (optional)')
    args = parser.parse_args()
    try:
        policy = json.loads((REPO / 'config/discovery.json').read_text())
        families = [json.loads(p.read_text()) for p in sorted((REPO / 'config/families').glob('*.json'))]
        resources = REPO / 'ReferenceFiles/Resources'
        default_text = next((p for p in sorted(resources.iterdir())
                             if p.is_dir() and p.name.casefold() == 'text_en'), resources / 'text_en')
        if args.text_root is not None and not args.text_root.is_dir():
            raise ValueError('--text-root must be an existing extracted English tag directory')
        tags, text_info = text_tags(args.text_root or default_text)
        report = discover(REPO / 'ReferenceFiles', families, policy, tags)
        report['english_text'] = text_info
        outputs = {'coverage.json': json.dumps(report, indent=2, sort_keys=True) + '\n', 'coverage.md': markdown(report)}
        if args.draft_config:
            draft = draft_config(report)
            if not draft['variants']: raise ValueError('No candidates; no empty draft written')
            # Exercise the real generator for every proposed variant/pool, without writes.
            tiers = {t['id']: t for t in json.loads((REPO / 'config/tiers.json').read_text())['tiers']}
            probe = dict(draft, enabled=True)
            gen.build_plan([probe], tiers, include_spawns=True)
            outputs[draft['id'] + '.json'] = json.dumps(draft, indent=2, sort_keys=True) + '\n'
        print(json.dumps(report['summary'], indent=2))
        print(f"English tag files: {text_info['files_read']}; candidates are unverified, not auto-enabled.")
        if args.write_report or args.draft_config:
            write_outputs(outputs)
            print('Wrote generated/discovery/ only. Active config, DBRs and game files unchanged.')
        else:
            print('Read-only scan; use --write-report and/or --draft-config for isolated output.')
        return 0
    except (ValueError, KeyError, TypeError, OSError) as exc:
        print(f'FAIL: {exc}', file=sys.stderr); return 1


if __name__ == '__main__':
    raise SystemExit(main())
