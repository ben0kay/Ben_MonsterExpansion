#!/usr/bin/env python3
"""Champion → Elite discovery using the shared Veteran discovery pipeline."""
from discover_veterans import main, REPO

if __name__ == '__main__':
    raise SystemExit(main(REPO / 'config/discovery_elites.json'))
