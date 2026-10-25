"""Generate configurable attribute progression from the effective DLC record."""
import json
from pathlib import Path
from dbr import DBR
from references import resolve
from devotion import validate_settings

RECORD = 'records/creatures/pc/playerlevels.dbr'
OUTPUT_RECORD = Path('database') / RECORD
ATTRIBUTES = {'physique': 'strengthIncrement', 'cunning': 'dexterityIncrement', 'spirit': 'intelligenceIncrement'}


def load_settings(repo):
    path = repo / 'config/player_stats.json'
    if not path.exists():
        return None
    settings = json.loads(path.read_text(encoding='utf-8'))
    if settings.get('schema_version') != 1 or type(settings.get('enabled')) is not bool:
        raise ValueError('Invalid player stats schema/enabled flag')
    values = [settings['attribute_points_per_level']]
    gains = settings['attribute_gain_per_point']
    if set(gains) != set(ATTRIBUTES):
        raise ValueError('Player attribute gains must specify physique, cunning and spirit')
    values.extend(gains.values())
    if any(type(value) is not int or value <= 0 for value in values):
        raise ValueError('Player attribute points and gains must be positive integers')
    validate_settings(settings.get("devotion"))
    return settings


def build_player_stats(settings, reference):
    path = resolve(RECORD, reference)
    if not path.is_file():
        raise ValueError('Missing player-level reference')
    record = DBR.from_file(path)
    if record.get('templateName') != 'database/templates/experiencelevelcontrol.tpl':
        raise ValueError('Wrong player-level template')
    if record.get('maxPlayerLevel') != '100' or record.get('maxDevotionPoints') != '55':
        raise ValueError('Player stats require the verified expansion progression record (100 levels, 55 devotion)')
    # Check target fields even for rollback. Devotion composes independently below.
    for key in ('characterModifierPoints', *ATTRIBUTES.values()):
        record.get(key)
    if settings['enabled']:
        record.set('characterModifierPoints', str(settings['attribute_points_per_level']))
        for attribute, field in ATTRIBUTES.items():
            record.set(field, str(settings['attribute_gain_per_point'][attribute]))
    devotion = settings.get("devotion")
    validate_settings(devotion)
    if devotion and devotion["enabled"]:
        record.set("maxDevotionPoints", str(devotion["max_points"]))
    return record.render()
