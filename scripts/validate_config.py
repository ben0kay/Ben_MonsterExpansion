#!/usr/bin/env python3
"""ME1: read-only checks for MonsterExpansion tier/family configuration.

Usage:
    python scripts/validate_config.py
    python scripts/validate_config.py --skip-references

No third-party dependencies. Does not edit extracted DBRs, compile a mod, or spawn enemies.
"""
import argparse
import json
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
ORDER = ["common", "veteran", "champion", "elite", "hero", "ascended", "boss", "nemesis", "apex"]
CUSTOM_PARENTS = {"veteran": "common", "elite": "champion", "ascended": "hero", "apex": "nemesis"}
HEX = re.compile(r"^#[0-9A-Fa-f]{6}$")


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load_json(path):
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def reference_path(game_record, reference_root):
    """Map a 'records/...' DBR path to the extracted ReferenceFiles tree."""
    require(isinstance(game_record, str), "Game record must be a string")
    require(game_record.startswith("records/"), f"Not a 'records/' path: {game_record}")
    require("\\" not in game_record, f"Use forward slashes: {game_record}")
    parts = game_record.split("/")
    require(all(p not in ("", ".", "..") for p in parts), f"Unsafe DBR path: {game_record}")
    require(game_record.lower().endswith(".dbr"), f"Not a DBR path: {game_record}")
    return reference_root.joinpath(*parts[1:])


def dbr_values(path):
    # DBR is comma-delimited KEY,VALUE,; only the first two tokens are needed.
    values = {}
    for line in path.read_text(encoding="utf-8-sig").splitlines():
        if "," not in line:
            continue
        key, value = line.split(",", 2)[:2]
        values[key.strip()] = value.strip()
    return values


def check_configs(reference_root=None):
    errors = []
    try:
        catalog = load_json(REPO / "config" / "tiers.json")
        families = sorted((REPO / "config" / "families").glob("*.json"))
        require(catalog.get("schema_version") == 1, "tiers.json schema_version must be 1")
        require(families, "No config/families/*.json found")
        tier_rows = catalog.get("tiers")
        require(isinstance(tier_rows, list), "tiers must be a list")
        ids = [t["id"] for t in tier_rows]
        require(ids == ORDER, f"Tier ordering changed: {ids}")
        require(len(set(ids)) == len(ids), "Tier ids must be unique")
        colors = []
        for i, tier in enumerate(tier_rows, 1):
            tid = tier["id"]
            require(tier["order"] == i, f"Wrong order for {tid}")
            color = tier.get("color_hex")
            require(isinstance(color, str) and HEX.fullmatch(color), f"Invalid hex color for {tid}")
            colors.append(color.lower())
            if tid in CUSTOM_PARENTS:
                require(tier["origin"] == "custom", f"{tid} must be custom")
                p = tier.get("prototype")
                require(isinstance(p, dict), f"{tid} prototype is missing")
                require(p.get("parent_tier") == CUSTOM_PARENTS[tid], f"{tid} parent is incorrect")
                require(isinstance(p.get("model_scale_vs_parent"), (int, float))
                        and p["model_scale_vs_parent"] > 1, f"{tid} must scale up from parent")
                for key in ("health", "damage", "defense"):
                    value = p.get("stats_vs_parent", {}).get(key)
                    require(isinstance(value, (int, float)) and value > 1,
                            f"{tid} prototype '{key}' must exceed parent")
            else:
                require(tier["origin"] == "vanilla", f"{tid} must remain vanilla")
                require("prototype" not in tier, f"Do not override vanilla tier {tid}")
        require(len(set(colors)) == 9, "Tier colors must be distinct")
        for fpath in families:
            fam = load_json(fpath)
            fid = fam.get("id", fpath.name)
            require(fam.get("schema_version") == 1, f"{fid}: unknown schema")
            sources = fam.get("source_records")
            require(isinstance(sources, list) and sources, f"{fid}: source_records empty")
            source_by_tier = {}
            for source in sources:
                t = source["tier"]
                require(t in ORDER, f"{fid}: unknown source tier {t}")
                require(t not in source_by_tier, f"{fid}: duplicate source tier {t}")
                source_by_tier[t] = source
                path = reference_path(source["record"], reference_root or REPO / "ReferenceFiles")
                if reference_root is not None:
                    require(path.is_file(), f"{fid}: missing extracted source: {path}")
                    data = dbr_values(path)
                    require(data.get("templateName") == "database/templates/monster.tpl",
                            f"{fid}: not a monster DBR: {path}")
                    require(data.get("monsterClassification") == source["expected_classification"],
                            f"{fid}: classification differs: {path}")
            pool = reference_path(fam["spawn_pool_record"], reference_root or REPO / "ReferenceFiles")
            if reference_root is not None:
                require(pool.is_file(), f"{fid}: missing spawn pool: {pool}")
                data = dbr_values(pool)
                require(data.get("templateName") == "database/templates/proxypool.tpl",
                        f"{fid}: not a proxy pool: {pool}")
                require(any(data.get(k) == s["record"]
                            for k in data if k.startswith("name")
                            for s in sources), f"{fid}: pool does not reference the source monsters")
            prototype = fam.get("first_prototype")
            require(isinstance(prototype, dict), f"{fid}: first_prototype required")
            target_tier = prototype["tier"]
            require(target_tier in CUSTOM_PARENTS, f"{fid}: prototype must use a new tier")
            require(prototype["source_tier"] == CUSTOM_PARENTS[target_tier],
                    f"{fid}: prototype source_tier should be its parent")
            require(prototype["source_tier"] in source_by_tier, f"{fid}: missing prototype parent source")
            out = prototype["future_output_record"]
            reference_path(out, reference_root or REPO / "ReferenceFiles")
            require(out.startswith("records/creatures/enemies/monsterexpansion/"),
                    f"{fid}: output must be in our namespace")
            require(all(out != s["record"] for s in sources), f"{fid}: output clashes with vanilla")
            require(prototype["planned_spawn_integration"] is False,
                    f"{fid}: do not activate spawns during ME1")
    except (ValueError, KeyError, TypeError, OSError, json.JSONDecodeError) as exc:
        errors.append(str(exc))
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skip-references", action="store_true",
                        help="Check JSON and paths without requiring extracted game files")
    args = parser.parse_args()
    errors = check_configs(None if args.skip_references else REPO / "ReferenceFiles")
    if errors:
        for error in errors:
            print("FAIL:", error, file=sys.stderr)
        return 1
    print("PASS: tier order, colors, prototype rules, family references and spawn pool")
    print("Read-only validation; no DBR files generated or modified.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
