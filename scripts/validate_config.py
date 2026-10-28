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
    from references import resolve
    return resolve(game_record, reference_root)


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
        from global_spawns import load_settings, build_global_spawn
        settings = load_settings(repo)
        if settings is not None and reference_root is not None:
            build_global_spawn(settings, reference_root)
        from player_stats import load_settings as load_player_stats, build_player_stats
        player_settings = load_player_stats(repo)
        if player_settings is not None and reference_root is not None:
            build_player_stats(player_settings, reference_root)
            from devotion import build_shrines
            build_shrines(player_settings.get("devotion"), reference_root)
        from player_movement import load_settings as load_movement, build_player_movement
        movement_settings = load_movement(repo)
        prior_player_files = {}
        if movement_settings is not None and reference_root is not None:
            prior_player_files, _ = build_player_movement(movement_settings, reference_root)
        from player_basics import load_settings as load_basics, build_player_basics
        basics_settings = load_basics(repo)
        if basics_settings is not None and reference_root is not None:
            basics_files, _ = build_player_basics(basics_settings, reference_root, prior_player_files)
            prior_player_files.update(basics_files)
        if (player_settings is not None and reference_root is not None
                and player_settings.get("level_cap") is not None):
            from player_stats import build_player_level_cap
            build_player_level_cap(player_settings, reference_root, prior_player_files)
        from player_skills import load_settings as load_skills, build_skills
        if reference_root is not None:
            skill_files, _ = build_skills(load_skills(repo), reference_root)
            from mastery_attachment import load_settings as load_attachment, build_attachment
            attachment_files, _ = build_attachment(load_attachment(repo), reference_root)
            require(not set(skill_files) & set(attachment_files), "Mastery attachment output collision")
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
            from enemy_rewards import validate_settings as validate_reward_settings
            validate_reward_settings(proto.get("experience_reward"))
            aura = proto.get("cosmetic_aura", {"enabled": False})
            require(type(aura.get("enabled")) is bool, "Aura enabled must be boolean")
            if aura["enabled"]:
                path = reference_path(aura["effect_source_record"], root)
                require(str(aura["effect_source_record"]).startswith("records/fx/"), "Aura must reference FX")
                if reference_root is not None:
                    require(path.is_file() and not path.is_symlink(), "Missing/unsafe aura source")
            rage = proto.get("low_health_rage")
            if rage is not None:
                allowed = {"enabled", "variant_ids", "target_mode", "health_threshold_percent",
                           "active_duration_seconds", "cooldown_seconds",
                           "total_damage_bonus_percent", "run_speed_bonus_percent",
                           "aura_effect_record"}
                require(tier["id"] in ("elite", "ascended") and isinstance(rage, dict) and
                        set(rage) == allowed and type(rage["enabled"]) is bool,
                        "Low-health rage must be an Elite/Ascended-only explicit config")
                require(rage["target_mode"] in ("all", "selected"), "Unknown rage selection mode")
                ids = rage["variant_ids"]
                require(isinstance(ids, list) and len(ids) == len(set(ids)) and
                        (rage["target_mode"] == "all" or bool(ids)) and
                        all(isinstance(v, str) and re.fullmatch(
                            r"[a-z][a-z0-9_]*:[a-z][a-z0-9_]*", v) for v in ids),
                        "Low-health rage target IDs must be unique family:variant names")
                for field, low, high in (
                    ("health_threshold_percent", 1, 90),
                    ("active_duration_seconds", 1, 60),
                    ("cooldown_seconds", 10, 600),
                    ("total_damage_bonus_percent", 0, 100),
                    ("run_speed_bonus_percent", 0, 50),
                ):
                    value = rage[field]
                    require(type(value) in (float, int) and math.isfinite(value) and low <= value <= high,
                            "Invalid low-health rage " + field)
                effect = rage["aura_effect_record"]
                require(isinstance(effect, str) and effect.startswith("records/fx/") and
                        effect.endswith(".dbr"), "Rage aura must reference an FX DBR")
                effect_path = reference_path(effect, root)
                if reference_root is not None:
                    require(effect_path.is_file() and not effect_path.is_symlink() and
                            dbr_values(effect_path).get("templateName") == "database/templates/effect.tpl",
                            "Rage aura must be an existing effect DBR")
            retaliation = proto.get("elemental_retaliation")
            if retaliation is not None:
                allowed = {"enabled", "activation_chance_percent", "cooldown_seconds",
                           "radius_meters", "profiles"}
                require(tier["id"] == "ascended" and isinstance(retaliation, dict) and
                        set(retaliation) == allowed and type(retaliation["enabled"]) is bool,
                        "Elemental retaliation must be Ascended-only with explicit settings")
                for key, low, high in (("activation_chance_percent", 1, 100),
                                       ("cooldown_seconds", 1, 600),
                                       ("radius_meters", 0.5, 10)):
                    value = retaliation[key]
                    require(type(value) in (float, int) and math.isfinite(value)
                            and low <= value <= high, "Invalid retaliation " + key)
                profiles = retaliation["profiles"]
                require(isinstance(profiles, dict) and bool(profiles) and
                        set(profiles) <= {"aether", "poison", "fire", "cold", "lightning",
                                         "chaos", "vitality", "physical", "pierce",
                                         "bleeding", "elemental"},
                        "Unsupported elemental retaliation profile")
                seen_names = set()
                for element, settings in profiles.items():
                    require(isinstance(settings, dict) and
                            set(settings) == {"source_skill_record", "radius_effect_record",
                                              "hero_stems"},
                            "Invalid " + element + " retaliation profile")
                    names = settings["hero_stems"]
                    require(isinstance(names, list) and bool(names) and
                            all(isinstance(name, str) and
                                re.fullmatch(r"[a-z][a-z0-9_]*_h[0-9]+[a-z]?", name) for name in names) and
                            len(set(names)) == len(names) and
                            not (set(names) & seen_names),
                            "Retaliation Hero stems must be explicit, unique and non-overlapping")
                    seen_names.update(names)
                    source_name = settings["source_skill_record"]
                    effect_name = settings["radius_effect_record"]
                    require(source_name.startswith("records/skills/nonplayerskills/") and
                            effect_name.startswith("records/fx/"),
                            "Retaliation source/FX path must be in native namespaces")
                    source = reference_path(source_name, root)
                    effect = reference_path(effect_name, root)
                    if reference_root is not None:
                        require(source.is_file() and not source.is_symlink() and
                                dbr_values(source).get("templateName") ==
                                "database/templates/skill_onhitattackradius.tpl" and
                                dbr_values(source).get("Class") == "Skill_OnHitAttackRadius",
                                "Retaliation source must be a native on-hit radius skill")
                        require(effect.is_file() and not effect.is_symlink() and
                                dbr_values(effect).get("templateName") ==
                                "database/templates/fxpak.tpl",
                                "Retaliation source FX must be a native FX pack")
                        damage_field = ("offensivePoisonMin" if element == "poison"
                                        else "offensiveAetherMin")
                        require(";" in dbr_values(source).get(damage_field, ""),
                                "Retaliation damage source must have a native rank curve")
            if "natural_spawns" in proto:
                value = proto["natural_spawns"].get("conversion_share", proto["natural_spawns"].get("common_conversion_share"))
                require(type(value) in (int, float) and math.isfinite(value) and 0 < value < .5,
                        "common_conversion_share must be finite, above 0 and below 0.5")
                quota_policy = proto["natural_spawns"].get("finite_limit_policy")
                require(quota_policy is None or (quota_policy == "bounded_champion_group" and proto["parent_tier"] == "hero"),
                        "Unsupported finite-limit policy")
                ratio = proto["natural_spawns"].get("target_veterans_per_champion", 2.5)
                require(type(ratio) in (int, float) and math.isfinite(ratio) and ratio > 0,
                        "Ratio target must be finite and positive (reporting only)")
        paths = sorted((repo / "config/families").glob("*.json"))
        require(paths, "No families configured")
        outputs, pools = set(), {}
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
                require(variant["expected_classification"] == CUSTOM_PARENTS[variant["tier"]].capitalize(),
                        "Variant must use its exact tier parent")
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
                require(record.startswith(("records/proxies/pools/", "records/proxies/poolsgdx1/", "records/proxies/poolsgdx2/")),
                        "Pool must be in regular pools namespace")
                pools.setdefault(record, []).append((fam, pool))
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
        # Selected-rage mode is only for explicitly enabled custom variants.
        active_variant_ids = {tier_id: set() for tier_id in ("elite", "ascended")}
        for fpath in paths:
            fam = load_json(fpath)
            if fam["enabled"]:
                for variant in fam["variants"]:
                    if variant["tier"] in active_variant_ids:
                        active_variant_ids[variant["tier"]].add(f"{fam['id']}:{variant['id']}")
        for tier_id in ("elite", "ascended"):
            rage = by_id[tier_id]["prototype"].get("low_health_rage")
            if rage and rage["enabled"] and rage["target_mode"] == "selected":
                require(set(rage["variant_ids"]) <= active_variant_ids[tier_id],
                        "Rage target must be an active " + tier_id + " variant")
        if reference_root is not None:
            from natural_spawns import build_merged_pool
            for mappings in pools.values():
                build_merged_pool(mappings, by_id, root)
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
