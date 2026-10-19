"""Split mapped regular spawn weight into Common/Veteran; preserve higher groups."""
from fractions import Fraction
import re
from dbr import DBR
from validate_config import reference_path, require


def build_pool_override(family, config, tier_by_id, reference_root):
    record = config['record']
    source = reference_path(record, reference_root)
    require(source.is_file() and not source.is_symlink(), f'Missing/unsafe pool: {record}')
    pool = DBR.from_file(source)
    require(pool.get('templateName') == 'database/templates/proxypool.tpl', 'Wrong pool template')
    for proxy_record in config['proxy_references']:
        path = reference_path(proxy_record, reference_root)
        require(path.is_file() and not path.is_symlink(), f'Missing/unsafe proxy: {proxy_record}')
        proxy = DBR.from_file(path)
        require(proxy.get('templateName') in ('database/templates/proxy.tpl', 'database/templates/proxyambush.tpl'), 'Wrong proxy template')
        require(any(re.fullmatch(r'pool\d+', line.split(',')[0]) and line.split(',')[1] == record
                    for line in proxy.lines), f'Proxy does not reference pool: {proxy_record}')
    variants = {v['id']: v for v in family['variants']}
    promotions = config['promotions']
    fractions = {Fraction(str(tier_by_id[variants[p['variant']]['tier']]['prototype']
                              ['natural_spawns']['common_conversion_share'])) for p in promotions}
    require(len(fractions) == 1, 'One conversion share per pool is supported')
    share = fractions.pop()
    require(0 < share < Fraction(1, 2) and share.denominator <= 1000, 'Unsafe conversion share')
    numerator, denominator = share.numerator, share.denominator
    slots = [int(line.split(',')[0][4:]) for line in pool.lines
             if re.fullmatch(r'name\d+', line.split(',')[0])]
    original = pool.render()
    changes = []
    # Check every source/destination before changing anything. Finite counts cannot
    # be copied into two independent buckets without changing the combined quota.
    for entry in promotions:
        a, b = entry['source_slot'], entry['output_slot']
        variant = variants[entry['variant']]
        require(a in slots, f'Missing regular source slot {a}: {record}')
        require(pool.get(f'name{a}') == variant['source_record'], f'Source mismatch at {record} slot {a}')
        require(not any(re.fullmatch(r'.*?(\d+)', line.split(',')[0]) and
                        re.fullmatch(r'.*?(\d+)', line.split(',')[0]).group(1) == str(b) and
                        'Champion' not in line.split(',')[0] for line in pool.lines),
                f'Destination regular slot {b} already has fields: {record}')
        for key in (f'limit{a}', f'alwaysSpawn{a}'):
            require(not pool._locations(key) or pool.get(key) in ('', '0', '0.000000'),
                    f'Limited/forced source {record} slot {a} needs a quota-aware policy')
        rule_fields = {f'name{b}': variant['output_record']}
        for stem in ('levelVarianceEquation', 'minPlayerLevel', 'maxPlayerLevel'):
            if pool._locations(f'{stem}{a}'):
                rule_fields[f'{stem}{b}'] = pool.get(f'{stem}{a}')
        changes.append((a, b, rule_fields))
    if config['enabled']:
        # Scale ALL regular weights by the denominator so unrelated choices retain
        # exactly their original relative mass. Champion weights are separate.
        weights = {slot: int(pool.get(f'weight{slot}')) for slot in slots}
        require(all(0 <= w <= 2147483647 // denominator for w in weights.values()),
                'Pool weights overflow or are negative')
        for slot, weight in weights.items():
            pool.set(f'weight{slot}', str(weight * denominator))
        for a, b, fields in changes:
            pool.set(f'weight{a}', str(weights[a] * (denominator - numerator)))
            fields[f'weight{b}'] = str(weights[a] * numerator)
            if pool.lines and not pool.lines[-1].endswith('\n'):
                pool.lines[-1] += '\n'
            for key, value in fields.items():
                pool.lines.append(f'{key},{value},\n')
    return record, pool.render(), {
        'pool': record, 'enabled': config['enabled'], 'common_conversion_share': float(share),
        'promotions': promotions, 'ratio_verified': False, 'map_coverage_verified': False,
        'rollback_vanilla_pool': not config['enabled'],
        'unchanged_vanilla_pool': pool.render() == original,
    }
