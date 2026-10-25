"""Exact conditional weight splitting, independently for regular/Champion groups."""
from collections import defaultdict
from fractions import Fraction
import re
from math import lcm
from dbr import DBR
from validate_config import reference_path, require

# These are fields established by proxypool.tpl, not rarity guesses from filenames.
GROUPS = {'common': '', 'champion': 'Champion', 'hero': 'Champion'}
RULES = ('levelVarianceEquation', 'minPlayerLevel', 'maxPlayerLevel')


def unsupported_slot_fields(keys, group, slot):
    allowed = {stem + group + str(slot) for stem in (*RULES, 'name', 'weight', 'limit', 'alwaysSpawn')}
    pattern = r'.*Champion(\d+)' if group else r'(?!.*Champion).*?(\d+)'
    return [key for key in keys if (m := re.fullmatch(pattern, key))
            and int(m.group(1)) == slot and key not in allowed]


def conversion_share(tier):
    settings = tier['prototype']['natural_spawns']
    # Retain the original Veteran config key for compatibility.
    return Fraction(str(settings.get('conversion_share', settings.get('common_conversion_share'))))


def selection_group(tier):
    parent = tier['prototype']['parent_tier']
    require(parent in GROUPS, 'Unsupported pool parent; Nemesis requires a separate policy')
    return GROUPS[parent]


def limit_policy_error(data, group, slot, tier, read_record):
    """Allow a finite Hero quota only when the whole selection group fits it.

    With at most N group draws and a source limit >= N, splitting the entry
    cannot increase the combined quota. Require the unchanged identity equations;
    forced group entries could bypass the bound and therefore exclude the pool.
    """
    zero = ('', '0', '0.000000')
    if data.get(f'alwaysSpawn{group}{slot}', '') not in zero:
        return 'limited_or_forced_entry'
    raw = data.get(f'limit{group}{slot}', '')
    if raw in zero:
        return None
    policy = tier['prototype'].get('natural_spawns', {}).get('finite_limit_policy')
    if policy != 'bounded_champion_group' or tier['prototype']['parent_tier'] != 'hero' or group != 'Champion':
        return 'limited_or_forced_entry'
    try:
        limit = int(raw)
        maximum = int(data['championMax'])
        minimum = int(data.get('championMin', '0'))
        if not 0 <= minimum <= maximum <= limit or maximum <= 0:
            return 'finite_quota_exceeds_supported_group_bound'
        if any(value not in zero for key, value in data.items()
               if re.fullmatch(r'alwaysSpawnChampion\d+', key)):
            return 'forced_champion_group_needs_review'
        equation = read_record(data['proxyPoolEquation'])
        if equation.get('templateName') != 'database/templates/proxypoolequation.tpl':
            return 'unsupported_champion_count_equation'
        for key in ('championMinEquation', 'championMaxEquation'):
            if re.sub(r'\s+', '', equation.get(key, '')) != 'poolValue*1':
                return 'unsupported_champion_count_equation'
    except (ValueError, KeyError, OSError):
        return 'unsupported_champion_count_equation'
    return None


def build_pool_override(family, config, tier_by_id, reference_root):
    return build_merged_pool([(family, config)], tier_by_id, reference_root)


def build_merged_pool(mappings, tier_by_id, reference_root):
    """Combine family mappings before touching a shared vanilla pool. One output."""
    record = mappings[0][1]['record']
    require(all(c['record'] == record for _, c in mappings), 'Cannot merge different pools')
    source = reference_path(record, reference_root)
    require(source.is_file() and not source.is_symlink(), f'Missing/unsafe pool: {record}')
    pool = DBR.from_file(source)
    require(pool.get('templateName') == 'database/templates/proxypool.tpl', 'Wrong pool template')
    original = pool.render()
    groups = defaultdict(list)
    reports = []
    for family, config in mappings:
        for proxy_record in config['proxy_references']:
            path = reference_path(proxy_record, reference_root)
            require(path.is_file() and not path.is_symlink(), f'Missing/unsafe proxy: {proxy_record}')
            proxy = DBR.from_file(path)
            require(proxy.get('templateName') in ('database/templates/proxy.tpl', 'database/templates/proxyambush.tpl'), 'Wrong proxy template')
            require(any(re.fullmatch(r'pool\d+', line.split(',')[0]) and line.split(',')[1] == record
                        for line in proxy.lines), f'Proxy does not reference pool: {proxy_record}')
        variants = {v['id']: v for v in family['variants']}
        for entry in config['promotions']:
            variant = variants[entry['variant']]
            tier = tier_by_id[variant['tier']]
            group = selection_group(tier)
            expected = tier['prototype']['parent_tier'].capitalize()
            require(variant['expected_classification'] == expected, 'Variant must use its exact tier parent')
            parent = DBR.from_file(reference_path(variant['source_record'], reference_root))
            require(parent.get('monsterClassification') == expected, 'Pool source has wrong classification')
            share = conversion_share(tier)
            require(0 < share < Fraction(1, 2) and share.denominator <= 1000, 'Unsafe conversion share')
            groups[group].append((entry, variant, share, config['enabled']))
        reports.append({'family': family['id'], 'enabled': config['enabled'], 'promotions': config['promotions']})
    shares = {}
    all_promotions = []
    for group, entries in sorted(groups.items()):
        fractions = {share for _, _, share, _ in entries}
        shares[group or 'regular'] = float(next(iter(fractions))) if len(fractions) == 1 else sorted(float(x) for x in fractions)
        denominator = lcm(*(share.denominator for _, _, share, enabled in entries if enabled))
        require(denominator <= 1000, 'Combined conversion denominator exceeds safe bound')
        slots = [int(re.fullmatch(r'name' + group + r'(\d+)', line.split(',')[0]).group(1))
                 for line in pool.lines if re.fullmatch(r'name' + group + r'(\d+)', line.split(',')[0])]
        sources, destinations, changes = set(), set(), []
        for entry, variant, share, enabled in entries:
            a, b = entry['source_slot'], entry['output_slot']
            require(type(a) is int and type(b) is int and 1 <= a <= 15 and 1 <= b <= 15, 'Pool slots must be 1..15')
            require(a not in sources and b not in destinations, 'Duplicate pool mapping across families')
            sources.add(a); destinations.add(b)
            require(a in slots and pool.get(f'name{group}{a}') == variant['source_record'], f'Source mismatch at {record} {group} slot {a}')
            # Every field in this selection namespace reserves its slot, even if unnamed.
            pattern = r'.*Champion(\d+)' if group else r'(?!.*Champion).*?(\d+)'
            require(not any((m := re.fullmatch(pattern, line.split(',')[0])) and int(m.group(1)) == b
                            for line in pool.lines), f'Destination {group} slot {b} already has fields: {record}')
            data = {line.split(',')[0]: line.split(',')[1] for line in pool.lines if ',' in line}
            def read_record(record):
                dbr = DBR.from_file(reference_path(record, reference_root))
                return {line.split(',')[0]: line.split(',')[1] for line in dbr.lines if ',' in line}
            error = limit_policy_error(data, group, a, tier_by_id[variant['tier']], read_record)
            require(error is None, f'{error}: {record} slot {a} needs a quota-aware policy')
            require(not unsupported_slot_fields([line.split(',')[0] for line in pool.lines], group, a),
                    'Unsupported source slot rules need explicit policy')
            fields = {f'name{group}{b}': variant['output_record']}
            for stem in (*RULES, 'limit'):
                if pool._locations(f'{stem}{group}{a}') and (stem != 'limit' or pool.get(f'{stem}{group}{a}') not in ('', '0', '0.000000')):
                    fields[f'{stem}{group}{b}'] = pool.get(f'{stem}{group}{a}')
            changes.append((a, b, fields, enabled, share))
            all_promotions.append(dict(entry, selection_group=group or 'regular'))
        require(not sources & destinations, 'Source and destination slots overlap')
        if not any(enabled for _, _, _, enabled in entries):
            continue
        weights = {slot: int(pool.get(f'weight{group}{slot}')) for slot in slots}
        require(all(0 <= w <= 2147483647 // denominator for w in weights.values()), 'Pool weights overflow or are negative')
        for slot, weight in weights.items():
            pool.set(f'weight{group}{slot}', str(weight * denominator))
        for a, b, fields, enabled, share in changes:
            if not enabled:
                continue
            require(weights[a] > 0, 'Mapped source must have positive weight')
            numerator = share.numerator * (denominator // share.denominator)
            pool.set(f'weight{group}{a}', str(weights[a] * (denominator - numerator)))
            fields[f'weight{group}{b}'] = str(weights[a] * numerator)
            if pool.lines and not pool.lines[-1].endswith('\n'):
                pool.lines[-1] += '\n'
            for key, value in fields.items():
                pool.lines.append(f'{key},{value},\n')
    return record, pool.render(), {
        'pool': record, 'enabled': any(c['enabled'] for _, c in mappings),
        'common_conversion_share': shares.get('regular'), 'conversion_shares': shares,
        'promotions': all_promotions, 'families': reports,
        'ratio_verified': False, 'map_coverage_verified': False,
        'rollback_vanilla_pool': pool.render() == original,
        'unchanged_vanilla_pool': pool.render() == original,
    }
