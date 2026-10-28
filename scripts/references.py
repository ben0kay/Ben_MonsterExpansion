"""Resolve logical game records against GDX2, GDX1, then base references."""
from pathlib import Path


def layers(root):
    root = Path(root)
    base = root / 'original/database/records'
    if not base.is_dir():
        base = root  # Compatibility with older flattened reference extracts and test fixtures.
    return [root / 'gdx2/database/records', root / 'gdx1/database/records', base]


def resolve(record, root):
    if not isinstance(record, str) or not record.startswith('records/') or '\\' in record:
        raise ValueError('Invalid game record path')
    parts = record.split('/')
    if any(p in ('', '.', '..') for p in parts) or not record.lower().endswith('.dbr'):
        raise ValueError('Unsafe game record path: ' + record)
    for layer in layers(root):
        candidate = layer.joinpath(*parts[1:])
        # An unsafe higher-priority record must never silently fall back.
        if any(p.is_symlink() for p in (candidate, *candidate.parents)):
            raise ValueError('Linked reference path: ' + str(candidate))
        if candidate.exists():
            if not candidate.is_file():
                raise ValueError('Reference is not a file: ' + str(candidate))
            return candidate
    return layers(root)[-1].joinpath(*parts[1:])


def records(root, prefix='proxies'):
    """Deduplicated logical records, including expansion-specific namespaces."""
    found = set()
    for layer in layers(root):
        folder = layer / prefix
        if not folder.is_dir():
            continue
        for path in folder.rglob('*.dbr'):
            record = 'records/' + path.relative_to(layer).as_posix()
            resolve(record, root)  # Reject symlinks before offering the record.
            found.add(record)
    return sorted(found)
