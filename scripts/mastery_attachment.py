"""Attach a cloned skill line and reversible UI layout without forking native pets."""
import json
import re
from pathlib import Path
from dbr import DBR
from references import resolve


def load_settings(repo, mastery='nightblade'):
    """Load an individual skeleton attachment; Nightblade remains the default."""
    names = {
        'nightblade': 'nightblade_skeletons.json',
        'demolitionist': 'demolitionist_skeletons.json',
    }
    if mastery not in names:
        raise ValueError('Unsupported skeleton attachment mastery')
    path = repo / 'config' / names[mastery]
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
    if set(settings) != {'schema_version', 'enabled', 'tree', 'panel', 'skills', 'existing_button_positions'}:
        raise ValueError('Unknown mastery attachment configuration fields')
    if settings['schema_version'] != 2 or type(settings['enabled']) is not bool:
        raise ValueError('Invalid mastery attachment configuration')
    class_match = re.fullmatch(
        r'records/skills/playerclass(\d{2})/_classtree_class(\d{2})\.dbr',
        settings['tree'])
    if class_match is None or class_match.group(1) != class_match.group(2):
        raise ValueError('Skeleton attachment tree path is not a mastery tree')
    class_id = class_match.group(1)
    if class_id not in ('02', '04'):
        raise ValueError('Only Demolitionist/Nightblade skeleton attachments are supported')
    if settings['panel'] != f'records/ui/skills/class{class_id}/classtable.dbr':
        raise ValueError('Attachment panel must match the target mastery')
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
    base_templates = reference / 'original/database/templates'
    if not base_templates.is_dir():
        base_templates = reference / 'Resources/templates'  # Legacy extract layout.
    template = (base_templates / 'skilltree.tpl').read_text(encoding='utf-8-sig')
    slots = [int(m.group(1)) for line in tree.lines
             if (m := re.match(r'skillName(\d+),[^,\r\n]+', line))]
    next_slot = max(slots) + 1
    buttons = panel.get('tabSkillButtons').split(';')
    def position(value):
        if not isinstance(value, list) or len(value) != 2 or any(type(v) is not int for v in value):
            raise ValueError('Invalid attachment position')
        x, y = value
        if not (246 <= x <= 886 and 39 <= y <= 459):
            raise ValueError('Attachment button outside existing skill layout bounds')
        return x, y

    original_names = [name for name in buttons
                      if re.fullmatch(r'skill\d+\.dbr', name.rsplit('/', 1)[-1])]
    layout = settings['existing_button_positions']
    if not isinstance(layout, dict) or set(layout) != set(original_names):
        raise ValueError('Layout must cover exactly the existing mastery skill buttons')
    occupied = []
    for name in original_names:
        button = source(name)
        x, y = position(layout[name])
        occupied.append((x, y))
        if settings['enabled']:
            button.set('bitmapPositionX', str(x))
            button.set('bitmapPositionY', str(y))
        # Always emit originals in disabled mode to undo previously staged moves.
        emit(name, button)
    if any(abs(a-c) < 60 and abs(b-d) < 60
           for i, (a,b) in enumerate(occupied) for c,d in occupied[i+1:]):
        raise ValueError('Existing mastery buttons overlap after layout changes')
    active = []
    for index, entry in enumerate(skills):
        if set(entry) != {'source', 'target', 'button_source', 'button_target', 'position', 'visible', 'set'}:
            raise ValueError('Unknown attachment skill configuration fields')
        if entry['visible'] is not True:
            raise ValueError('Expose the complete skill line together')
        if not re.fullmatch(
            rf'records/skills/playerclass{class_id}/ben_[a-z0-9_]+\.dbr',
            entry['target']):
            raise ValueError('Attachment skill must use custom target-mastery namespace')
        if not re.fullmatch(
            rf'records/ui/skills/class{class_id}/skill[0-9]+\.dbr',
            entry['button_target']):
            raise ValueError('Attachment button must use target-mastery UI namespace')
        if entry['target'] in targets:
            raise ValueError('Duplicate attachment skill')
        targets.add(entry['target'])
        skill = source(entry['source'])
        button = source(entry['button_source'])
        if button.get('skillName') != entry['source']:
            raise ValueError('UI donor does not point to the requested native skill')
        x, y = position(entry['position'])
        if any(abs(x-a) < 60 and abs(y-b) < 60 for a,b in occupied):
            raise ValueError('Attachment button overlaps an existing button or rank text')
        occupied.append((x, y))
        if index and (y != skills[0]['position'][1] or x != skills[0]['position'][0] + 160*index):
            raise ValueError('Native connector geometry requires a horizontal line with 160 pixel spacing')
        edits = entry['set']
        if not isinstance(edits, dict) or (set(edits) - {'petLimit', 'petBurstSpawn'}) or (index and edits):
            raise ValueError('Only base summon burst/cap overrides are supported')
        for key, value in edits.items():
            if not isinstance(value, str) or not re.fullmatch(r'[1-9][0-9]*', value):
                raise ValueError('Summon overrides must be positive integer strings')
            if settings['enabled']:
                skill.set(key, value)
        if index == 0 and int(skill.get('petBurstSpawn')) > int(skill.get('petLimit')):
            raise ValueError('Summon burst exceeds the base cap')
        button.set('skillName', entry['target'])
        button.set('bitmapPositionX', str(x))
        button.set('bitmapPositionY', str(y))
        # Keep native connectors, modifier curves and the third skill's petSkillName.
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
                   'status': 'complete skill line; layout and modifiers await in-game verification',
                   'cloned_records': [s['target'] for s in skills]}
