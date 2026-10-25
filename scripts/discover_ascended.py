#!/usr/bin/env python3
"""Hero → Ascended discovery using the shared tier pipeline."""
from discover_veterans import main, REPO

if __name__ == '__main__':
    raise SystemExit(main(REPO / 'config/discovery_ascended.json'))
