"""Clone a native skill line without changing its pets or existing mastery skills.

The initial attachment exposes only the base skill for the SK0 runtime gate.
Modifier clones remain unreachable until a complete UI layout is verified.
"""
import json
import re
from pathlib import Path
from dbr import DBR
from references import resolve


def load_settings(repo):
    path = repo / 'config/nightblade_skeletons.json'
    return json.loads(path.read_text()) if path.exists() else None


def put(record, key, value):
    """Replace a field or add an explicitly template-supported tree field."""
    if record._locations(key):
        record.set(key, str(value))
    else:
        record.lines.append(f'{key},{value},\n')


def build_attachment(settings, reference):
    """Return deterministic DBRs and a report, including vanilla rollback records."""
    if settings is None:
        return {}, None
    if set(settings) != {'schema_version', 'enabled', 'tree', 'panel', 'skills'}:
        raise ValueError('Unknown mastery attachment configuration fields')
    if settings['schema_version'] != 1 or type(settings['enabled']) is not bool:
        raise ValueError('Invalid mastery attachment configuration')
    skills = settings['skills']
    if not isinstance(skills, list) or len(skills) != 3:
        raise ValueError('Skeleton attachment requires its three native skill records')
    files, targets = {}, set()

    def source(name):
        return DBR.from_file(resolve(name, reference))

    def emit(name, record):
        # Resolve validates traversal/absolute paths even for new output names.
        resolve(name, reference)
        path = Path('database') / name
        if path in files:
            raise ValueError('Duplicate attachment output: ' + name)
        files[path] = record.render()

    tree, panel = source(settings['tree']), source(settings['panel'])
    # Validate template capacity rather than assuming unused fields are supported.
    template = (reference / 'Resources/templates/skilltree.tpl').read_text()
    slots = [int(m.group(1)) for line in tree.lines
             if (m := re.match(r'skillName(\d+),[^,\r\n]+', line))]
    next_slot = max(slots) + 1
    buttons = panel.get('tabSkillButtons').split(';')
    original_buttons = [source(name) for name in buttons if re.fullmatch(r'skill\d+\.dbr', name.rsplit('/', 1)[-1])]
    # Native icon frames occupy at most 48x48; keep new icons and rank text apart.
    occupied = [(int(b.get('bitmapPositionX')), int(b.get('bitmapPositionY')))
                for b in original_buttons]
    active = []
    for index, entry in enumerate(skills):
        if set(entry) != {'source', 'target', 'button_source', 'button_target', 'position', 'visible'}:
            raise ValueError('Unknown attachment skill configuration fields')
        if type(entry['visible']) is not bool or entry['visible'] != (index == 0):
            raise ValueError('SK0 gate: expose only the base skill until UI/runtime verification')
        if not entry['target'].startswith('records/skills/playerclass04/ben_'):
            raise ValueError('Attachment skill must use custom Nightblade namespace')
        if not entry['button_target'].startswith('records/ui/skills/class04/skill'):
            raise ValueError('Attachment button must use Nightblade UI namespace')
        if entry['target'] in targets:
            raise ValueError('Duplicate attachment skill')
        targets.add(entry['target'])
        skill = source(entry['source'])
        button = source(entry['button_source'])
        if button.get('skillName') != entry['source']:
            raise ValueError('UI donor does not point to the requested native skill')
        position = entry['position']
        if not isinstance(position, list) or len(position) != 2 or any(type(v) is not int for v in position):
            raise ValueError('Invalid attachment position')
        x, y = position
        if entry['visible']:
            if not (246 <= x <= 886 and 39 <= y <= 459):
                raise ValueError('Attachment button outside existing skill layout bounds')
            if any(abs(x-a) < 64 and abs(y-b) < 64 for a, b in occupied):
                raise ValueError('Attachment button overlaps an existing button or rank text')
            occupied.append((x, y))
        if index == 0:
            # Hide native connector strips while the two modifiers are not exposed.
            skill.set('skillConnectionOn', '')
            skill.set('skillConnectionOff', '')
        button.set('skillName', entry['target'])
        button.set('bitmapPositionX', str(x))
        button.set('bitmapPositionY', str(y))
        # Never retune the skill, copy pets, or redirect the third skill's native petSkillName.
        emit(entry['target'], skill)
        emit(entry['button_target'], button)
        if settings['enabled'] and entry['visible']:
            slot = next_slot + len(active)
            for field in (f'skillName{slot}', f'skillLevel{slot}'):
                if f'name = "{field}"' not in template:
                    raise ValueError('Attachment exceeds skill tree template capacity')
            put(tree, f'skillName{slot}', entry['target'])
            put(tree, f'skillLevel{slot}', '0')
            buttons.append(entry['button_target'])
            active.append(entry['target'])
    if settings['enabled']:
        panel.set('tabSkillButtons', ';'.join(buttons))
    emit(settings['tree'], tree)
    emit(settings['panel'], panel)
    return files, {'enabled': settings['enabled'], 'active_skills': active,
                   'status': 'base-skill proof of concept; runtime verification pending',
                   'cloned_records': [s['target'] for s in skills]}
