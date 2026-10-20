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


def check_configs(reference_root=None, repo=REPO):
    """Validate the full catalog before generating/staging any selected family."""
    errors = []
    try:
        import math
        root = reference_root or repo / "ReferenceFiles"
        catalog = load_json(repo / "config/tiers.json")
        require(catalog.get("schema_version") == 1, "Unsupported tier schema")
        tiers = catalog["tiers"]
        require([t["id"] for t in tiers] == ORDER, "Tier order changed")
        require(len({t["color_hex"].lower() for t in tiers}) == 9, "Tier colors must differ")
        by_id = {t["id"]: t for t in tiers}
        for i, tier in enumerate(tiers, 1):
            require(tier["order"] == i and HEX.fullmatch(tier["color_hex"]), "Invalid tier order/color")
            if tier["id"] not in CUSTOM_PARENTS:
                require(tier["origin"] == "vanilla" and "prototype" not in tier,
                        "Vanilla tier overrides are not supported")
                continue
            proto = tier["prototype"]
            require(tier["origin"] == "custom" and proto["parent_tier"] == CUSTOM_PARENTS[tier["id"]],
                    "Wrong custom parent")
            for value in [proto["model_scale_vs_parent"], *proto["stats_vs_parent"].values()]:
                require(type(value) in (int, float) and math.isfinite(value) and value > 1,
                        "Tier multipliers must be finite and exceed 1")
            aura = proto.get("cosmetic_aura", {"enabled": False})
            require(type(aura.get("enabled")) is bool, "Aura enabled must be boolean")
            if aura["enabled"]:
                path = reference_path(aura["effect_source_record"], root)
                require(str(aura["effect_source_record"]).startswith("records/fx/"), "Aura must reference FX")
                if reference_root is not None:
                    require(path.is_file() and not path.is_symlink(), "Missing/unsafe aura source")
            if "natural_spawns" in proto:
                value = proto["natural_spawns"]["common_conversion_share"]
                require(type(value) in (int, float) and math.isfinite(value) and 0 < value < .5,
                        "common_conversion_share must be finite, above 0 and below 0.5")
                ratio = proto["natural_spawns"].get("target_veterans_per_champion", 2.5)
                require(type(ratio) in (int, float) and math.isfinite(ratio) and ratio > 0,
                        "Ratio target must be finite and positive (reporting only)")
        paths = sorted((repo / "config/families").glob("*.json"))
        require(paths, "No families configured")
        outputs, pools = set(), set()
        for fpath in paths:
            fam = load_json(fpath)
            require(fam.get("schema_version") == 2, "Family schema must be 2")
            require(re.fullmatch(r"[a-z][a-z0-9_]*", fam["id"]) and fpath.stem == fam["id"],
                    "Family id must match filename")
            require(type(fam.get("enabled")) is bool, "Family enabled must be boolean")
            require(fam["variants"], "Family needs variants")
            ids = set()
            for variant in fam["variants"]:
                vid = variant["id"]
                require(re.fullmatch(r"[a-z][a-z0-9_]*", vid) and vid not in ids, "Invalid/duplicate variant id")
                ids.add(vid)
                if "display_name" in variant:
                    name = variant["display_name"]
                    require(isinstance(name, str) and bool(name) and name.strip() == name and
                            not any(c in name for c in "\r\n=\x00"), "Invalid display_name")
                require(variant["tier"] in CUSTOM_PARENTS, "Variant must use a custom tier")
                for key in ("source_record", "output_record", "damage_skill_source_record"):
                    reference_path(variant[key], root)
                require(variant["source_record"].startswith("records/creatures/enemies/"), "Wrong monster path")
                expected = f"records/creatures/enemies/monsterexpansion/{fam['id']}_{vid}.dbr"
                require(variant["output_record"] == expected, "Output must follow family_variant namespace")
                require(expected not in outputs, "Duplicate variant output")
                outputs.add(expected)
                require(variant["damage_skill_source_record"].startswith("records/skills/nonplayerskills/"),
                        "Wrong damage source namespace")
                if reference_root is not None:
                    path = reference_path(variant["source_record"], root)
                    require(path.is_file() and not path.is_symlink(), f"Missing/unsafe monster: {path}")
                    data = dbr_values(path)
                    require(data.get("templateName") == "database/templates/monster.tpl", "Not a monster")
                    require(data.get("monsterClassification") == variant["expected_classification"],
                            "Source classification differs")
                    # Do not promote quest/summoned records through broad automatic discovery.
                    require(not any(x in path.stem.lower() for x in ("summon", "potiondropper", "lootdropper", "_doa")),
                            "Special monster needs explicit separate policy")
            for pool in fam["pools"]:
                record = pool["record"]
                reference_path(record, root)
                require(record.startswith("records/proxies/pools/") and record not in pools,
                        "Pool must be unique and in regular pools namespace")
                pools.add(record)
                require(type(pool.get("enabled")) is bool, "Pool enabled must be boolean")
                require(pool["proxy_references"] and pool["promotions"], "Pool needs proxy evidence and mappings")
                for proxy in pool["proxy_references"]:
                    reference_path(proxy, root)
                sources, targets = set(), set()
                for entry in pool["promotions"]:
                    a, b = entry["source_slot"], entry["output_slot"]
                    require(type(a) is int and type(b) is int and 1 <= a <= 15 and 1 <= b <= 15,
                            "Pool slots must be integers 1..15 (template capacity)")
                    require(a not in sources and b not in targets and entry["variant"] in ids,
                            "Duplicate slot or missing variant")
                    sources.add(a); targets.add(b)
                require(not sources & targets, "Source and destination slots overlap")
                if reference_root is not None:
                    from natural_spawns import build_pool_override
                    build_pool_override(fam, pool, by_id, root)
    except (ValueError, KeyError, TypeError, OSError, StopIteration, json.JSONDecodeError) as exc:
        errors.append(str(exc))
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skip-references", action="store_true")
    args = parser.parse_args()
    errors = check_configs(None if args.skip_references else REPO / "ReferenceFiles")
    if errors:
        for error in errors:
            print("FAIL:", error, file=sys.stderr)
        return 1
    print("PASS: tier defaults, family variants, references and promotion mappings (read-only)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
