"""Global regular pack-size equation; disabled emits vanilla for rollback."""
import json
import math
from pathlib import Path
from dbr import DBR

RECORD = 'records/proxies/proxypoolequation_01.dbr'
OUTPUT_RECORD = Path('database') / RECORD


def load_settings(repo):
    path = repo / 'config/master.json'
    if not path.exists():
        return None  # Catalog-only fixtures and old configurations remain supported.
    data = json.loads(path.read_text(encoding='utf-8'))
    if data.get('schema_version') != 1:
        raise ValueError('Unsupported master config schema')
    settings = data['monster_spawning']
    multiplier = settings['pack_size_multiplier']
    if type(settings['enabled']) is not bool:
        raise ValueError('Monster spawning enabled must be boolean')
    if type(multiplier) not in (int, float) or not math.isfinite(multiplier) or not 0 < multiplier <= 10:
        raise ValueError('Pack multiplier must be finite, greater than 0 and at most 10')
    return settings


def build_global_spawn(settings, reference):
    from references import resolve
    path = resolve(RECORD, reference)
    if not path.is_file() or path.is_symlink():
        raise ValueError('Missing/unsafe shared spawn equation')
    original = path.read_text(encoding='utf-8-sig')
    record = DBR(original)
    if record.get('templateName') != 'database/templates/proxypoolequation.tpl':
        raise ValueError('Wrong shared spawn equation template')
    for key in ('spawnMinEquation', 'spawnMaxEquation', 'championMinEquation', 'championMaxEquation'):
        if record.get(key) != 'poolValue * 1':
            raise ValueError('Unexpected vanilla equation: ' + key)
    if settings['enabled']:
        factor = format(settings['pack_size_multiplier'], '.12g')
        for key in ('spawnMinEquation', 'spawnMaxEquation'):
            record.set(key, 'poolValue * ' + factor)
    return record.render()
