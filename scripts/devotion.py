"""Config-driven Devotion cap and shrine rewards, using effective DLC references."""
from pathlib import Path
from dbr import DBR
from references import layers, records, resolve

TEMPLATE = 'database/templates/staticshrine.tpl'
LAYER_IDS = ('gdx2', 'gdx1', 'base')


def validate_settings(settings):
    if settings is None:
        return
    if not isinstance(settings, dict) or type(settings.get('enabled')) is not bool:
        raise ValueError('Devotion enabled must be boolean')
    for key in ('points_per_shrine', 'max_points'):
        value = settings.get(key)
        if type(value) is not int or not 0 < value <= 2147483647:
            raise ValueError(f'Devotion {key} must be a positive DBR integer')
    if settings['points_per_shrine'] > settings['max_points']:
        raise ValueError('Shrine reward cannot exceed the configured Devotion cap')
    required = settings.get('required_reference_layers')
    if (not isinstance(required, list) or not required or
            any(x not in LAYER_IDS for x in required) or len(set(required)) != len(required)):
        raise ValueError('Devotion requires distinct base/gdx1/gdx2 reference layer ids')


def reward(record):
    if record.get('templateName') != TEMPLATE or not record._locations('devotionPoints'):
        return None
    value = int(record.get('devotionPoints'))
    if value < 0:
        raise ValueError('Negative source shrine reward needs review')
    return value


def reference_coverage(settings, root):
    """A missing DLC batch must never silently fall back to base shrine records."""
    validate_settings(settings)
    counts = {}
    for name, layer in zip(LAYER_IDS, layers(root)):
        folder = layer / 'interactive'
        count = 0
        if folder.is_dir():
            if any(p.is_symlink() for p in (folder, *folder.parents)):
                raise ValueError('Linked shrine reference directory')
            for path in sorted(folder.rglob('*.dbr')):
                if any(p.is_symlink() for p in (path, *path.parents)):
                    raise ValueError('Linked shrine reference file')
                if reward(DBR.from_file(path)) not in (None, 0):
                    count += 1
        counts[name] = count
    missing = [name for name in settings['required_reference_layers'] if not counts[name]]
    return {'rewarding_shrines_per_layer': counts, 'missing_reference_layers': missing,
            'note': 'Counts describe uploaded records, not proof of a complete game extraction.'}


def build_shrines(settings, reference):
    validate_settings(settings)
    if settings is None:
        return {}, None
    coverage = reference_coverage(settings, reference)
    report = dict(coverage, enabled=settings['enabled'], points_per_shrine=settings['points_per_shrine'],
                  max_points=settings['max_points'], shrine_records=[])
    if not settings['enabled'] and coverage['missing_reference_layers']:
        report['status'] = 'disabled_pending_references'
        return {}, report
    if coverage['missing_reference_layers']:
        names = ', '.join(coverage['missing_reference_layers'])
        raise ValueError(f'Devotion shrine references missing for {names}; upload the extracted DLC interactive folders before enabling Devotion')
    files = {}
    for game_record in records(reference, 'interactive'):
        path = resolve(game_record, reference)
        shrine = DBR.from_file(path)
        amount = reward(shrine)
        # Preserve blank, decorative and zero-reward quest shrines, including Mogdrogen.
        if amount in (None, 0):
            continue
        if settings['enabled']:
            shrine.set('devotionPoints', str(settings['points_per_shrine']))
        files[Path('database') / game_record] = shrine.render()
        report['shrine_records'].append(game_record)
    if not files:
        raise ValueError('No rewarding shrine records found')
    report['status'] = 'generated_runtime_unverified' if settings['enabled'] else 'vanilla_shrine_rollback'
    return files, report
