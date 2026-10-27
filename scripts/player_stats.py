"""Generate configurable attribute progression from the effective DLC record."""
import json
from pathlib import Path
from dbr import DBR
from references import resolve
from devotion import validate_settings
from player_movement import PLAYER_RECORDS

RECORD = 'records/creatures/pc/playerlevels.dbr'
OUTPUT_RECORD = Path('database') / RECORD
ATTRIBUTES = {'physique': 'strengthIncrement', 'cunning': 'dexterityIncrement', 'spirit': 'intelligenceIncrement'}


def validate_level_cap(settings):
    """Bound cap to the built-in per-level skill-point array (up to 200)."""
    cap = settings.get('level_cap')
    if cap is None:
        return None  # Backwards-compatible config without a cap override.
    if (not isinstance(cap, dict) or set(cap) != {'enabled', 'max_level'}
            or type(cap['enabled']) is not bool
            or type(cap['max_level']) is not int
            or not 100 <= cap['max_level'] <= 200):
        raise ValueError('Invalid player level cap (expected 100-200 and bool enabled)')
    return cap



def validate_skill_points(settings):
    """Validate optional contiguous, level-based skill-point award ranges."""
    schedule = settings.get('skill_points_per_level')
    if schedule is None:
        return None
    if (not isinstance(schedule, dict) or set(schedule) != {'enabled', 'ranges'}
            or type(schedule['enabled']) is not bool
            or not isinstance(schedule['ranges'], list)
            or not schedule['ranges']):
        raise ValueError('Invalid skill-point schedule')
    next_level = 2  # Index zero in skillModifierPoints awards level 2.
    for bracket in schedule['ranges']:
        if (not isinstance(bracket, dict)
                or set(bracket) != {'start_level', 'end_level', 'points'}
                or any(type(bracket[key]) is not int for key in bracket)
                or bracket['start_level'] != next_level
                or not next_level <= bracket['end_level'] <= 200
                or not 1 <= bracket['points'] <= 20):
            raise ValueError('Skill-point ranges must be contiguous from level 2')
        next_level = bracket['end_level'] + 1
    cap = validate_level_cap(settings)
    if schedule['enabled'] and cap and cap['enabled'] and next_level <= cap['max_level']:
        raise ValueError('Skill-point ranges must cover the configured level cap')
    return schedule


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
    validate_level_cap(settings)
    validate_skill_points(settings)
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
    # Skill-point awards are independent of attribute, devotion, and cap toggles.
    schedule = validate_skill_points(settings)
    if schedule and schedule['enabled']:
        native_awards = record.get('skillModifierPoints').split(';')
        awards = list(native_awards)
        for bracket in schedule['ranges']:
            for level in range(bracket['start_level'], bracket['end_level'] + 1):
                index = level - 2
                if index >= len(awards):
                    raise ValueError('Skill-point schedule exceeds original award table')
                awards[index] = str(bracket['points'])
        record.set('skillModifierPoints', ';'.join(awards))
    devotion = settings.get("devotion")
    validate_settings(devotion)
    if devotion and devotion["enabled"]:
        record.set("maxDevotionPoints", str(devotion["max_points"]))
    cap = validate_level_cap(settings)
    if cap and cap['enabled']:
        # The native array awards points for every level beyond 1, up to 200.
        skill_awards = record.get('skillModifierPoints').split(';')
        if len(skill_awards) < cap['max_level'] - 1:
            raise ValueError('Level cap exceeds available skill-point awards')
        record.set('maxPlayerLevel', str(cap['max_level']))
    return record.render()


def build_player_level_cap(settings, reference, prior_player_files=None):
    """Compose maxLevel on both player actors after movement and starting-stat edits."""
    cap = validate_level_cap(settings)
    if cap is None:
        return {}, []
    prior_player_files = prior_player_files or {}
    output, report = {}, []
    for name in PLAYER_RECORDS:
        path = Path('database') / name
        original = DBR.from_file(resolve(name, reference))
        current = DBR(prior_player_files[path]) if path in prior_player_files else DBR.from_file(resolve(name, reference))
        if original.get('templateName') != 'database/templates/player.tpl' or original.get('Class') != 'Player':
            raise ValueError('Unexpected player actor template/class: ' + name)
        if original.get('maxLevel') != '100':
            raise ValueError('Player actor baseline level cap is not 100: ' + name)
        if current.get('templateName') != original.get('templateName') or current.get('Class') != 'Player':
            raise ValueError('Incompatible player actor: ' + name)
        target = str(cap['max_level']) if cap['enabled'] else original.get('maxLevel')
        current.set('maxLevel', target)
        output[path] = current.render()
        report.append({'record': name, 'max_level': target})
    return output, report
