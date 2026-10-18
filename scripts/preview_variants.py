#!/usr/bin/env python3
"""Preview only: show proposed first variants. No filesystem writes."""
import json
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]


def main():
    import sys
    sys.path.insert(0, str(REPO / "scripts"))
    from validate_config import check_configs
    errors = check_configs(None)  # useful even without local reference assets
    if errors:
        for error in errors:
            print("FAIL:", error, file=sys.stderr)
        return 1
    catalog = json.loads((REPO / "config" / "tiers.json").read_text(encoding="utf-8"))
    tier_by_id = {t["id"]: t for t in catalog["tiers"]}
    for file in sorted((REPO / "config" / "families").glob("*.json")):
        family = json.loads(file.read_text(encoding="utf-8"))
        prototype = family["first_prototype"]
        tier = tier_by_id[prototype["tier"]]
        parent = next(s for s in family["source_records"] if s["tier"] == prototype["source_tier"])
        print(f"Family: {family['display_name']}")
        print(f"  Source: {parent['record']}")
        print(f"  Proposed output: {prototype['future_output_record']}")
        print(f"  Tier: {tier['name']} | Color target: {tier['color_hex']}")
        print(f"  Model scale factor vs parent: {tier['prototype']['model_scale_vs_parent']:.2f}x")
        print(f"  Stats vs parent (provisional): {tier['prototype']['stats_vs_parent']}")
        print("  No records created; no spawn pools modified.")


if __name__ == "__main__":
    raise SystemExit(main())
