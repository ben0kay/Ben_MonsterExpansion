#!/usr/bin/env python3
"""Read-only preview of all configured families and optional spawn-pool plans."""
from generate_variants import main

if __name__ == "__main__":
    # Shares generator CLI; no writes unless explicitly passed --write.
    import sys
    if "--write" in sys.argv or "--replace-generated" in sys.argv:
        raise SystemExit("Preview is read-only; use generate_variants.py to write")
    raise SystemExit(main())
