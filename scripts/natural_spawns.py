"""ME3: one explicit pool override, no edits to extracted references or proxies."""
import math
from dbr import DBR
from validate_config import reference_path

POOL = 'records/proxies/pools/p_beasts_boar_n.dbr'
PROXY = 'records/proxies/area001/beasts_boar_n.dbr'
MONSTER = 'records/creatures/enemies/monsterexpansion/boar_veteran_01.dbr'


def require(ok, why):
    if not ok:
        raise ValueError(why)


def validate_spawn_settings(family, tier):
    settings = family.get('natural_spawns')
    require(isinstance(settings, dict), 'Missing family natural_spawns settings')
    require(type(settings.get('enabled')) is bool, 'Spawn enabled must be boolean')
    require(family['id'] == 'boar' and family['spawn_pool_record'] == POOL,
            'ME3 supports only the reviewed boar pool')
    require(settings.get('proxy_reference_record') == PROXY, 'Unreviewed proxy path')
    require(type(settings.get('pool_slot')) is int and settings['pool_slot'] == 5,
            'ME3 reserves unused regular slot 5')
    require(type(settings.get('level_variance_source_slot')) is int and
            settings['level_variance_source_slot'] == 1, 'ME3 inherits regular slot 1 level rules')
    require(family['first_prototype']['future_output_record'] == MONSTER,
            'Unexpected spawn monster path')
    values = tier['prototype']['natural_spawns']
    weight = values.get('regular_pool_weight')
    require(type(weight) is int and 1 <= weight <= 99,
            'Veteran regular_pool_weight must be an integer 1..99; Common must dominate')
    ratio = values.get('target_veterans_per_champion')
    require(type(ratio) in (int, float) and math.isfinite(ratio) and 2 <= ratio <= 3,
            'Target Veteran:Champion ratio must be finite and between 2 and 3')
    return settings, values


def build_pool_override(family, tier, reference_root):
    settings, values = validate_spawn_settings(family, tier)
    pool = DBR.from_file(reference_path(POOL, reference_root))
    proxy = DBR.from_file(reference_path(PROXY, reference_root))
    require(pool.get('templateName') == 'database/templates/proxypool.tpl', 'Wrong pool template')
    require(proxy.get('pool1') == POOL, 'Proxy no longer references reviewed pool')
    original = pool.render()
    baseline = sum(int(pool.get(f'weight{i}')) for i in range(1, 5))
    require(baseline == 100, 'Baseline regular weights changed; recalibrate before generating')
    require(not any(line.startswith(('name5,', 'weight5,', 'levelVarianceEquation5,',
                                     'minPlayerLevel5,', 'maxPlayerLevel5,', 'limit5,', 'alwaysSpawn5,'))
                    for line in pool.lines), 'Regular slot 5 already has rules; review required')
    if settings['enabled']:
        # Mirror slot 1 eligibility/level equation; omit absent limits/forced spawns.
        additions = {'name5': MONSTER, 'weight5': str(values['regular_pool_weight'])}
        for stem in ('levelVarianceEquation', 'minPlayerLevel', 'maxPlayerLevel'):
            if any(line.startswith(stem + '1,') for line in pool.lines):
                additions[stem + '5'] = pool.get(stem + '1')
        if pool.lines and not pool.lines[-1].endswith('\n'):
            pool.lines[-1] += '\n'
        for field, value in additions.items():
            pool.lines.append(f'{field},{value},\n')
        # Preserve every original field, including all Champion/Hero and count rules.
        require(pool.render().startswith(original), 'Original pool data unexpectedly changed')
    weight = values['regular_pool_weight'] if settings['enabled'] else 0
    return POOL, pool.render(), {
        'included': True, 'enabled': settings['enabled'], 'pool': POOL,
        'proxy_reference': PROXY, 'regular_baseline_weight': baseline,
        'veteran_weight': weight, 'regular_selection_share': weight / (baseline + weight),
        'target_veterans_per_champion': values['target_veterans_per_champion'],
        'ratio_verified': False, 'runtime_verified': False,
        'scope': 'all encounters resolving this pool path; not all boar pools',
        'rollback_vanilla_pool': not settings['enabled'],
    }
