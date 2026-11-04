"""Compose Occultist pairs with effective balance records and existing class UI.

Skill_Modifier follows its base in the native skill tree; connectors are on the
base skill (Blood uses its buff). Keep donor horizontal distances and tiers.
"""
import json
import re
from pathlib import Path

from dbr import DBR
from references import resolve

DONORS = {
    'bonds': ('08', ('bondsofbysmiel1', 'bondsofbysmiel2'),
              ('bondsofbysmiel1_petbonus', 'bondsofbysmiel2_petbonus'), (25, 26), (726, 886), 319),
    'blood': ('08', ('bloodofdreeg1', 'bloodofdreeg2'),
              ('bloodofdreeg1_buff',), (19, 20), (486, 726), 459),
    'sigil': ('05', ('sigilofdestruction1', 'sigilofdestruction2'),
              (), (12, 13), (406, 646), 459),
}
SOURCE = 'records/skills/playerclass03/'
# These donors are managed by player_skills.json, including disabled-record
# rollback outputs. Never silently replace effective values with vanilla.
BALANCED = {SOURCE + stem + '.dbr' for stem in (
    'bondsofbysmiel1_petbonus', 'bondsofbysmiel2_petbonus',
    'bloodofdreeg1', 'bloodofdreeg1_buff', 'bloodofdreeg2',
    'sigilofdestruction1', 'sigilofdestruction2',
)}


def load_settings(repo):
    path = Path(repo) / 'config/spellbinder_occultist.json'
    if not path.exists():
        return None
    return validate_settings(json.loads(path.read_text(encoding='utf-8')))


def validate_settings(settings):
    if (not isinstance(settings, dict) or set(settings) != {'schema_version', 'enabled', 'lines'}
            or type(settings['schema_version']) is not int or settings['schema_version'] != 1
            or type(settings['enabled']) is not bool
            or not isinstance(settings['lines'], dict) or set(settings['lines']) != set(DONORS)
            or any(type(v) is not bool for v in settings['lines'].values())):
        raise ValueError('Invalid Spellbinder Occultist attachment configuration')
    return settings


def tree_path(class_id):
    return f'records/skills/playerclass{class_id}/_classtree_class{class_id}.dbr'


def panel_path(class_id):
    return f'records/ui/skills/class{class_id}/classtable.dbr'


def clone_path(class_id, stem):
    return f'records/skills/playerclass{class_id}/ben_{stem}.dbr'


def button_path(class_id, stem):
    return f'records/ui/skills/class{class_id}/ben_{stem}.dbr'


def compose_class(settings, reference, effective_skills, class_id, existing=None):
    """Return one owner's complete outputs, explicitly composing Arcanist UI.

    Existing outputs must come from arcanist_attachment, never arbitrary mod
    files. Original/native rollback records are emitted even with all flags off.
    """
    if class_id not in ('05', '08'):
        raise ValueError('Unsupported Spellbinder mastery')
    files = dict(existing or {})
    if settings is None:
        return files, None
    validate_settings(settings)
    reference = Path(reference)

    def native(logical):
        return DBR.from_file(resolve(logical, reference))

    def current(logical):
        path = Path('database') / logical
        return DBR(files[path]) if path in files else native(logical)

    def emit(logical, record, compose=False):
        resolve(logical, reference)  # Validate even brand new output paths.
        path = Path('database') / logical
        if path in files and not compose:
            raise ValueError('Spellbinder output collision: ' + logical)
        files[path] = record.render()

    tree_name, panel_name = tree_path(class_id), panel_path(class_id)
    if class_id == '05' and (not existing or Path('database') / tree_name not in existing):
        raise ValueError('Arcanist expansion must compose the existing summon generator')
    tree, panel = current(tree_name), current(panel_name)
    if (tree.get('templateName') != 'database/templates/skilltree.tpl'
            or panel.get('templateName') != 'database/templates/ingameui/skillpanectrl.tpl'):
        raise ValueError('Spellbinder tree/panel template changed')
    native_tree = native(tree_name)
    slots = lambda d: {int(m.group(1)): m.group(2) for line in d.lines
                      if (m := re.match(r'skillName(\d+),([^,\r\n]+)', line))}
    expected_count = 31 if class_id == '05' else 32
    original_slots = slots(native_tree)
    if set(original_slots) != set(range(1, expected_count + 1)):
        raise ValueError('Native mastery slots changed; re-audit attachment')
    if any(slots(tree).get(i) != v for i, v in original_slots.items()):
        raise ValueError('Existing generator replaced a native mastery skill')
    active = [name for name, donor in DONORS.items()
              if donor[0] == class_id and settings['enabled'] and settings['lines'][name]]
    buttons = panel.get('tabSkillButtons').split(';')
    if len(buttons) != len(set(buttons)):
        raise ValueError('Duplicate skill panel button')
    if class_id == '05' and active and any('ben_raiseskeletons' in v for v in slots(tree).values()):
        raise ValueError('Disable Arcanist skeletons before enabling the Sigil layout')

    # Reserve an eighth row at y=459 only when Blood/Sigil needs it. Native
    # horizontal chains and transmuter offsets stay together; X never changes.
    compact = 'blood' in active or 'sigil' in active
    moves = []
    for logical in buttons:
        if not re.fullmatch(r'records/ui/skills/class' + class_id + r'/(?:skill\d+|ben_\w+)\.dbr', logical):
            continue
        button = current(logical)
        x, y = int(button.get('bitmapPositionX')), int(button.get('bitmapPositionY'))
        new_y = y
        if compact:
            # Seven native main rows, 70px apart -> 60px apart. Transmuter
            # buttons keep their +32px offset from the same main row.
            row = (y - 39) // 70
            if not 0 <= row <= 6 or (y - 39) % 70 not in (0, 32):
                raise ValueError('Unreviewed native button row: ' + logical)
            new_y = y - row * 10
        if new_y != y:
            moves.append(logical)
            button.set('bitmapPositionY', str(new_y))
        # Explicit native rollback overrides; use the composed Guardian and
        # standalone moves as inputs so this never undoes the summon generator.
        emit(logical, button, compose=True)

    template = (reference / 'original/database/templates/skilltree.tpl').read_text(encoding='utf-8-sig')
    cloned, attached = [], []
    for name, (target_class, stems, support, donor_buttons, xs, y) in DONORS.items():
        if target_class != class_id:
            continue
        if name == 'bonds' and compact:
            y = 279
        mapping = {SOURCE + stem + '.dbr': clone_path(class_id, stem) for stem in stems + support}
        for source, target in mapping.items():
            path = Path('database') / source
            if source in BALANCED and path not in effective_skills:
                raise ValueError('Effective Occultist balance output missing: ' + source)
            record = DBR(effective_skills[path]) if path in effective_skills else native(source)
            # Rewrite the complete local skill graph, keeping native FX/assets.
            for line in list(record.lines):
                if ',' not in line:
                    continue
                key = line.split(',', 1)[0]
                value = record.get(key)
                updated = ';'.join(mapping.get(part, part) for part in value.split(';'))
                if updated != value:
                    record.set(key, updated)
            emit(target, record)
            cloned.append(target)
        for stem, number, x in zip(stems, donor_buttons, xs):
            source = SOURCE + stem + '.dbr'
            target = mapping[source]
            button = native(f'records/ui/skills/class03/skill{number:02}.dbr')
            if (button.get('skillName') != source or int(button.get('bitmapPositionX')) != x
                    or button.get('templateName') != 'database/templates/ingameui/skillbutton.tpl'):
                raise ValueError('Occultist donor button/tier changed')
            button.set('skillName', target)
            button.set('bitmapPositionY', str(y))
            output = button_path(class_id, stem)
            emit(output, button)
            if name in active:
                slot = max(slots(tree)) + 1
                for field, value in ((f'skillName{slot}', target), (f'skillLevel{slot}', '0')):
                    if f'name = "{field}"' not in template:
                        raise ValueError('Spellbinder exceeds skilltree template capacity')
                    if tree._locations(field):
                        raise ValueError('Spellbinder skill slot occupied')
                    tree.lines.append(f'{field},{value},\n')
                buttons.append(output)
                attached.append(target)

    panel.set('tabSkillButtons', ';'.join(buttons))
    emit(tree_name, tree, compose=True)
    emit(panel_name, panel, compose=True)
    # All native/new buttons and connector corridors must remain unobscured.
    positions = {}
    for logical in buttons:
        if logical.endswith('/classtraining.dbr'):
            continue
        button = current(logical)
        xy = tuple(int(button.get(k)) for k in ('bitmapPositionX', 'bitmapPositionY'))
        if not (246 <= xy[0] <= 886 and 39 <= xy[1] <= 459):
            raise ValueError('Spellbinder button outside panel')
        positions[logical] = xy
    for i, (first, (x, y)) in enumerate(positions.items()):
        for second, (a, b) in list(positions.items())[i+1:]:
            if abs(x-a) < 60 and abs(y-b) < 60:
                raise ValueError('Spellbinder overlapping buttons: ' + first + ', ' + second)
    for name in active:
        _, stems, _, _, xs, y = DONORS[name]
        if name == 'bonds' and compact:
            y = 279
        pair = {button_path(class_id, stem) for stem in stems}
        for logical, (x, other_y) in positions.items():
            if logical not in pair and xs[0] < x < xs[1] and abs(y-other_y) < 32:
                raise ValueError('Spellbinder connector obscured: ' + logical)
    return files, {'active_lines': active, 'active_skills': attached,
                   'cloned_records': cloned, 'moved_buttons': moves,
                   'in_game_verified': False}
