#!/usr/bin/env python3
"""Generate configured monster families and optional reviewed pool overrides.

Run from the repository root:
    python scripts/generate_variants.py
    python scripts/generate_variants.py --write

Only generated/MonsterExpansion/ is written and it is Git-ignored. No Grim Dawn
build, Asset Manager invocation or reach fixes. --include-spawns opts into ME3.
"""
import argparse
import json
import os
import re
import sys
import tempfile
from decimal import Decimal, InvalidOperation
from pathlib import Path

from dbr import DBR, DBRError
from natural_spawns import build_pool_override, build_merged_pool
from validate_config import check_configs, reference_path

REPO = Path(__file__).resolve().parents[1]
REFERENCE = REPO / "ReferenceFiles"
OUTPUT = REPO / "generated" / "MonsterExpansion"
TEXT_SOURCE = Path("source/Text_EN/tags_benmonsterexpansion.txt")
VALID_NAME = re.compile(r"^[a-z][a-z0-9_]*$")


class GenerationError(ValueError):
    pass


def fail_unless(ok, reason):
    if not ok:
        raise GenerationError(reason)


def game_location(relative_record):
    """Produce relative path under staged database/. No arbitrary destinations."""
    reference_path(relative_record, REFERENCE)
    return Path("database") / relative_record


def read_game_dbr(game_record):
    path = reference_path(game_record, REFERENCE)
    fail_unless(path.is_file() and not path.is_symlink(), f"Missing/unsafe source: {path}")
    return DBR.from_file(path)


def scaled_expression(expression, factor):
    fail_unless(bool(expression.strip()), "Cannot scale empty attribute equation")
    fail_unless(";" not in expression, "Expected one attribute equation")
    return f"({expression})*{format(Decimal(str(factor)), 'f')}"


def scaled_number(value, multiplier):
    try:
        number = Decimal(value)
        result = number * Decimal(str(multiplier))
    except InvalidOperation as exc:
        raise GenerationError(f"Not a numeric skill value: {value!r}") from exc
    fail_unless(result.is_finite(), "Scaled skill value must be finite")
    return f"{result:.6f}"


def scaled_series(raw, factor):
    chunks = raw.split(";")
    fail_unless(bool(chunks) and all(item.strip() for item in chunks), "Empty damage series member")
    return ";".join(scaled_number(chunk, factor) for chunk in chunks)


def build_cosmetic_aura(monster, prototype, prefix, tier_name="Veteran"):
    """Shared cosmetic attachment: self-only toggle, no inherited combat bonuses.

    Evidence: necro_skeleton_b03_priest -> skeleton_priestselfaura uses
    initialSkillName + Skill_BuffSelfToggled + charFxPakSelfNames. Create a
    minimal record instead of cloning its fire damage/camera shake settings.
    Reuse a vanilla particle resource; do not copy Resources into mod sources.
    """
    config = prototype.get("cosmetic_aura", {"enabled": False})
    fail_unless(type(config.get("enabled")) is bool, "Aura enabled must be boolean")
    if not config["enabled"]:
        return {}
    effect_source = config.get("effect_source_record")
    effect = read_game_dbr(effect_source)
    fail_unless(effect.get("templateName") == "database/templates/effect.tpl",
                "Unexpected cosmetic effect template")
    particle = effect.get("effectFile")
    fail_unless(particle.startswith("fx/") and ".." not in particle.split("/")
                and "\\" not in particle and particle.endswith(".pfx"), "Unsafe particle path")
    fail_unless((REFERENCE / "Resources" / particle).is_file(), "Missing particle reference")
    # Template supports 60 assigned skills and two initial skills. Preserve every
    # occupied slot; use an available initial slot or fail without overwriting.
    slot = next((n for n in range(1, 61)
                 if not monster._locations(f"skillName{n}") and not monster._locations(f"skillLevel{n}")), None)
    initial = next((key for key in ("initialSkillName", "initial2SkillName")
                    if not monster._locations(key) or not monster.get(key)), None)
    fail_unless(slot is not None and initial is not None,
                "No safe cosmetic/initial skill slot; disable aura or review this source")
    skill_record = f"records/skills/nonplayerskills/monsterexpansion/{prefix}_cosmetic.dbr"
    pack_record = f"records/fx/monsterexpansion/{prefix}_cosmetic_chfxpak.dbr"
    effect_record = f"records/fx/monsterexpansion/{prefix}_cosmetic_fx.dbr"
    # All keys are established by uploaded templates; no attack radius, damage,
    # stat bonuses, reservation, weapon enchantment, cast animation or sound.
    skill = DBR(f"""templateName,database/templates/skill_buffselftoggled.tpl,
Class,Skill_BuffSelfToggled,
FileDescription,Cosmetic {tier_name} glow - no combat bonuses,
instantCast,1,
notDispelable,1,
skillMaxLevel,1,
skillManaCost,0.000000,
skillActiveLifeCost,0.000000,
skillActiveManaCost,0.000000,
""" + f"charFxPakSelfNames,{pack_record},\n")
    # Tint semantics are not proven for particles; disable rather than tint the
    # creature's original texture by accident. Exact muted green remains a target.
    pack = DBR("templateName,database/templates/charfxpak.tpl,\n"
               "particleEffectAttachPoints,FXCentered,\n"
               f"particleEffectNames,{effect_record},\nuseTintColor,0,\n")
    if monster.lines and not monster.lines[-1].endswith("\n"):
        monster.lines[-1] += "\n"
    fields = {f"skillName{slot}": skill_record, f"skillLevel{slot}": "1", initial: skill_record}
    for key, value in fields.items():
        if any(line.startswith(key + ",") for line in monster.lines):
            monster.set(key, value)
        else:
            monster.lines.append(f"{key},{value},\n")
    return {game_location(skill_record): skill.render(), game_location(pack_record): pack.render(),
            game_location(effect_record): effect.render()}


def display_tag(family, variant):
    return f"tagBME_{family['id']}_{variant['id']}"


def display_text(variant, tier):
    name = variant.get("display_name")
    if name is None:
        return None
    fail_unless(isinstance(name, str) and name.strip() == name and bool(name) and
                not any(c in name for c in "\r\n=\x00"), "Invalid display_name text")
    return f"{name} ({tier['name']})"


def build_variant(family, variant, tier):
    """Generate one configured variant; no family-specific branching."""
    fid = family["id"]
    source_record = variant["source_record"]
    monster = read_game_dbr(source_record)
    fail_unless(monster.get("templateName") == "database/templates/monster.tpl", "Wrong monster template")
    fail_unless(monster.get("monsterClassification") == variant["expected_classification"],
                "Unexpected source classification")
    label = display_text(variant, tier)
    if label is not None:
        monster.set("description", display_tag(family, variant))
    proto = tier["prototype"]
    fail_unless(variant["expected_classification"] == proto["parent_tier"].capitalize(),
                "Variant must use its exact tier parent")
    stats = proto["stats_vs_parent"]
    target_monster = variant["output_record"]
    prefix = f"{fid}_{variant['id']}"
    monster_namespace = "records/creatures/enemies/monsterexpansion/"
    fail_unless(target_monster == monster_namespace + prefix + ".dbr", "Unexpected variant output name")
    bio_record = monster_namespace + "bios/" + prefix + "_bio.dbr"
    damage_record = "records/skills/nonplayerskills/monsterexpansion/" + prefix + "_damage.dbr"
    damage_source = variant["damage_skill_source_record"]
    source_skills = [monster.get(f"skillName{n}") for n in range(1, 61)
                     if monster._locations(f"skillName{n}")]
    fail_unless(source_skills.count(damage_source) == 1,
                "Configured damage skill must be assigned exactly once")

    bio_source = monster.get("characterAttributeEquations")
    fail_unless(bio_source.startswith("records/creatures/enemies/bios/"),
                "Unexpected parent bio; needs manual review")
    bio = read_game_dbr(bio_source)
    fail_unless(bio.get("templateName") == "database/templates/characterattributeequations.tpl",
                "Unexpected bio template")
    bio.set("characterLife", scaled_expression(bio.get("characterLife"), stats["health"]))
    bio.set("characterDefensiveAbility", scaled_expression(
        bio.get("characterDefensiveAbility"), stats["defense"]))
    monster.set("characterAttributeEquations", bio_record)

    damage = read_game_dbr(damage_source)
    fail_unless(damage.get("templateName") == "database/templates/skill_passive.tpl",
                "Expected skill_passive for damage source")
    # Physical base damage is one contribution to final damage; this is
    # NOT a guaranteed final 10% damage boost after all bonuses are applied.
    for key in ("offensivePhysicalMin", "offensivePhysicalMax"):
        damage.set(key, scaled_series(damage.get(key), stats["damage"]))
    for idx in range(1, 61):
        field = f"skillName{idx}"
        if any(line.startswith(field + ",") for line in monster.lines) and monster.get(field) == damage_source:
            monster.set(field, damage_record)

    scale = monster.get("scale")
    try:
        factor = Decimal(scale) * Decimal(str(proto["model_scale_vs_parent"]))
    except InvalidOperation as exc:
        raise GenerationError("Monster scale is not numeric") from exc
    fail_unless(factor.is_finite() and Decimal("0.1") <= factor <= Decimal("20"),
                "Unsafe monster scale")
    monster.set("scale", f"{factor:.6f}")
    # Preserve original monsterClassification, actorRadius, actorHeight, description,
    # skill timing and spawn references pending in-game compatibility tests.

    aura_files = build_cosmetic_aura(monster, proto, prefix, tier["name"])
    result = {
        **aura_files,
        game_location(target_monster): monster.render(),
        game_location(bio_record): bio.render(),
        game_location(damage_record): damage.render(),
    }
    return result


def build_plan(families, tier_by_id, include_spawns=False):
    """One complete manifest per invocation; reject output collisions."""
    files, variants, pools, tags = {}, [], [], {}
    pool_mappings = {}
    def merge(records):
        fail_unless(not set(files) & set(records), "Duplicate generated output path")
        files.update(records)
    for family in families:
        if not family["enabled"]:
            continue
        for variant in family["variants"]:
            tier = tier_by_id[variant["tier"]]
            merge(build_variant(family, variant, tier))
            label = display_text(variant, tier)
            if label is not None:
                tag = display_tag(family, variant)
                fail_unless(tag not in tags, "Duplicate display tag")
                tags[tag] = label
            variants.append({"family": family["id"], "variant": variant["id"], "tier": variant["tier"],
                             "source": variant["source_record"], "output": variant["output_record"],
                             "runtime_verified": False})
        if include_spawns:
            for config in family["pools"]:
                pool_mappings.setdefault(config['record'], []).append((family, config))
    for mappings in pool_mappings.values():
        record, text, report = build_merged_pool(mappings, tier_by_id, REFERENCE)
        merge({game_location(record): text})
        pools.append(report)
    fail_unless(files, "No enabled variants selected")
    if tags:
        merge({TEXT_SOURCE: "".join(f"{key}={value}\n" for key, value in sorted(tags.items()))})
    manifest = {"schema_version": 2, "phase": "data_driven_families",
                "families": [f["id"] for f in families if f["enabled"]],
                "include_spawns": include_spawns, "variants": variants, "pools": pools,
                "text_source": TEXT_SOURCE.as_posix() if tags else None,
                "files": sorted(p.as_posix() for p in files),
                "notes": ["Variant runtime flags default to unverified; see docs for existing boar evidence.",
                          "Pool conversion shares apply only to mapped entries within their own selection groups.",
                          "Champion ratios/map coverage, exact tint and collision/reach need playtesting."]}
    files[Path("manifest.json")] = json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    return files


def configured_plan(family="all", include_spawns=False):
    fail_unless(family == "all" or bool(VALID_NAME.fullmatch(family)), "Invalid family selector")
    errors = check_configs(REFERENCE)
    fail_unless(not errors, "; ".join(errors))
    families = [json.loads(path.read_text(encoding="utf-8"))
                for path in sorted((REPO / "config/families").glob("*.json"))
                if family == "all" or path.stem == family]
    fail_unless(families, f"No configured family: {family}")
    tiers = json.loads((REPO / "config/tiers.json").read_text(encoding="utf-8"))["tiers"]
    files = build_plan(families, {t["id"]: t for t in tiers}, include_spawns)
    if include_spawns:
        from global_spawns import load_settings, build_global_spawn, OUTPUT_RECORD
        settings = load_settings(REPO)
        if settings is not None:
            fail_unless(OUTPUT_RECORD not in files, "Global equation output collision")
            files[OUTPUT_RECORD] = build_global_spawn(settings, REFERENCE)
            manifest = json.loads(files[Path("manifest.json")])
            manifest["global_spawning"] = settings
            manifest["files"] = sorted(p.as_posix() for p in files if p != Path("manifest.json"))
            files[Path("manifest.json")] = json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    from player_stats import load_settings as load_player_stats, build_player_stats, OUTPUT_RECORD as PLAYER_RECORD
    player_settings = load_player_stats(REPO)
    if player_settings is not None:
        fail_unless(PLAYER_RECORD not in files, "Player stats output collision")
        files[PLAYER_RECORD] = build_player_stats(player_settings, REFERENCE)
        from devotion import build_shrines
        shrine_files, devotion_report = build_shrines(player_settings.get("devotion"), REFERENCE)
        fail_unless(not set(shrine_files) & set(files), "Devotion shrine output collision")
        files.update(shrine_files)
        manifest = json.loads(files[Path("manifest.json")])
        manifest["player_stats"] = player_settings
        if devotion_report is not None:
            manifest["devotion"] = devotion_report
        manifest["files"] = sorted(p.as_posix() for p in files if p != Path("manifest.json"))
        files[Path("manifest.json")] = json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    from player_movement import load_settings as load_movement, build_player_movement
    movement_settings = load_movement(REPO)
    if movement_settings is not None:
        movement_files, movement_report = build_player_movement(movement_settings, REFERENCE)
        fail_unless(not set(movement_files) & set(files), "Player movement output collision")
        files.update(movement_files)
        manifest = json.loads(files[Path("manifest.json")])
        manifest["player_movement"] = movement_settings
        manifest["player_movement_records"] = movement_report
        manifest["files"] = sorted(p.as_posix() for p in files if p != Path("manifest.json"))
        files[Path("manifest.json")] = json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    from player_basics import load_settings as load_basics, build_player_basics, ENGINE_OUTPUT
    basics_settings = load_basics(REPO)
    if basics_settings is not None:
        # Compose starting life/energy with any pre-existing movement record.
        prior_players = movement_files if movement_settings is not None else {}
        basics_files, basics_report = build_player_basics(basics_settings, REFERENCE, prior_players)
        fail_unless(ENGINE_OUTPUT not in files, "Game-engine output collision")
        fail_unless(not (set(basics_files) & set(files)) - set(prior_players),
                    "Unexpected player basics output collision")
        files.update(basics_files)
        manifest = json.loads(files[Path("manifest.json")])
        manifest["player_basics"] = basics_settings
        manifest["player_basics_records"] = basics_report
        manifest["files"] = sorted(p.as_posix() for p in files if p != Path("manifest.json"))
        files[Path("manifest.json")] = json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    from player_skills import load_settings as load_skills, build_skills
    skill_files, skill_report = build_skills(load_skills(REPO), REFERENCE)
    fail_unless(not set(skill_files) & set(files), "Player skill output collision")
    files.update(skill_files)
    manifest = json.loads(files[Path("manifest.json")])
    manifest["player_skills"] = skill_report
    manifest["files"] = sorted(p.as_posix() for p in files if p != Path("manifest.json"))
    files[Path("manifest.json")] = json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    return files


def write_staged(files, output_root, overwrite=False):
    """Write only inside a dedicated stage root, after preflighting all targets."""
    root = Path(output_root)
    fail_unless(root.absolute() == OUTPUT.absolute(), "Generator output root must remain generated/MonsterExpansion")
    fail_unless(not root.is_symlink() and not root.parent.is_symlink(),
                "Refusing symlinked generator output")
    for path, content in files.items():
        fail_unless(not path.is_absolute() and ".." not in path.parts,
                    f"Unsafe relative output: {path}")
        target = root / path
        for parent in (target, *target.parents):
            if parent == root.parent:
                break
            fail_unless(not parent.is_symlink(), f"Symlink in output tree: {parent}")
        if target.exists():
            fail_unless(target.is_file(), f"Output path not a normal file: {target}")
            current = target.read_text(encoding="utf-8")
            fail_unless(current == content or overwrite,
                        f"Generated file differs: {target}; use --replace-generated intentionally")
    for path, content in files.items():
        target = root / path
        if target.exists() and target.read_text(encoding="utf-8") == content:
            continue
        target.parent.mkdir(parents=True, exist_ok=True)
        with tempfile.NamedTemporaryFile("w", encoding="utf-8", newline="", dir=target.parent,
                                         prefix=".tmp-me2-", delete=False) as handle:
            temp = Path(handle.name)
            try:
                handle.write(content)
            except BaseException:
                temp.unlink(missing_ok=True)
                raise
        try:
            os.replace(temp, target)
        finally:
            temp.unlink(missing_ok=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--family", default="all", help="Configured family id, or all (default)")
    parser.add_argument("--include-spawns", action="store_true", help="Include the scoped configured family pools override")
    parser.add_argument("--write", action="store_true", help="Stage the output in generated/ (ignored by Git)")
    parser.add_argument("--replace-generated", action="store_true", help="Replace changed generated files (requires --write)")
    args = parser.parse_args()
    try:
        fail_unless(not args.replace_generated or args.write,
                    "--replace-generated requires --write")
        files = configured_plan(args.family, args.include_spawns)
        print(f"Configured families: {args.family}; pools: {args.include_spawns}")
        for p in sorted(files):
            print(f"  {'WRITE' if args.write else 'PLAN '} {p} ({len(files[p])} chars)")
        if args.write:
            write_staged(files, OUTPUT, overwrite=args.replace_generated)
            print("Staged in generated/MonsterExpansion/. Rebuild/install required.")
            if not args.include_spawns:
                print("No pool emitted. Existing staged pool overrides are NOT removed; see docs/DATA_DRIVEN_FAMILIES.md.")
        else:
            print("Dry run only. Re-run with --write to stage files (not into Asset Manager).")
        return 0
    except (GenerationError, DBRError, ValueError, KeyError, OSError) as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
