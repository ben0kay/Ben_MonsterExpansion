#!/usr/bin/env python3
"""Generate one validated monster variant and an optional scoped mod pool override.

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
from natural_spawns import build_pool_override
from validate_config import check_configs, reference_path

REPO = Path(__file__).resolve().parents[1]
REFERENCE = REPO / "ReferenceFiles"
OUTPUT = REPO / "generated" / "MonsterExpansion"
VALID_NAME = re.compile(r"^[a-z][a-z0-9_]*$")


class GenerationError(ValueError):
    pass


def fail_unless(ok, reason):
    if not ok:
        raise GenerationError(reason)


def game_location(relative_record):
    """Produce relative path under staged database/. No arbitrary destinations."""
    source = reference_path(relative_record, REFERENCE)
    return Path("database") / Path("records") / source.relative_to(REFERENCE)


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


def get_source(family, tier):
    sources = [s for s in family["source_records"] if s["tier"] == tier]
    fail_unless(len(sources) == 1, f"Cannot find unique source tier {tier}")
    return sources[0]


def build_cosmetic_aura(monster, prototype, prefix):
    """Single-boar visual test: self-only toggle, no inherited combat bonuses.

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
    fail_unless(effect_source == "records/fx/creatures/glownature01_large.dbr",
                "Only researched nature glow is supported in this playtest")
    effect = read_game_dbr(effect_source)
    fail_unless(effect.get("templateName") == "database/templates/effect.tpl",
                "Unexpected cosmetic effect template")
    particle = effect.get("effectFile")
    fail_unless(particle == "fx/particlesystems/creature/pfx_glownature_01_lg.pfx",
                "Unexpected nature glow particle")
    fail_unless((REFERENCE / "Resources" / particle).is_file(), "Missing particle reference")
    # Do not overwrite another initial skill or occupied skill slot.
    fail_unless(not any(line.startswith("initialSkillName,") and line.split(",")[1]
                        for line in monster.lines), "Parent initial skill needs manual review")
    fail_unless(not any(line.startswith(("skillName6,", "skillLevel6,"))
                        for line in monster.lines), "Parent skill slot 6 is occupied")
    skill_record = f"records/skills/nonplayerskills/monsterexpansion/{prefix}_cosmetic.dbr"
    pack_record = f"records/fx/monsterexpansion/{prefix}_cosmetic_chfxpak.dbr"
    effect_record = f"records/fx/monsterexpansion/{prefix}_cosmetic_fx.dbr"
    # All keys are established by uploaded templates; no attack radius, damage,
    # stat bonuses, reservation, weapon enchantment, cast animation or sound.
    skill = DBR("""templateName,database/templates/skill_buffselftoggled.tpl,
Class,Skill_BuffSelfToggled,
FileDescription,Cosmetic Veteran glow - no combat bonuses,
instantCast,1,
notDispelable,1,
skillMaxLevel,1,
skillManaCost,0.000000,
skillActiveLifeCost,0.000000,
skillActiveManaCost,0.000000,
""" + f"charFxPakSelfNames,{pack_record},\n")
    # Tint semantics are not proven for particles; disable rather than tint the
    # boar's original texture by accident. Exact muted green remains a target.
    pack = DBR("templateName,database/templates/charfxpak.tpl,\n"
               "particleEffectAttachPoints,FXCentered,\n"
               f"particleEffectNames,{effect_record},\nuseTintColor,0,\n")
    if monster.lines and not monster.lines[-1].endswith("\n"):
        monster.lines[-1] += "\n"
    fields = {"skillName6": skill_record, "skillLevel6": "1", "initialSkillName": skill_record}
    for key, value in fields.items():
        if any(line.startswith(key + ",") for line in monster.lines):
            monster.set(key, value)
        else:
            monster.lines.append(f"{key},{value},\n")
    return {game_location(skill_record): skill.render(), game_location(pack_record): pack.render(),
            game_location(effect_record): effect.render()}


def build_variant(family, tier, include_spawns=False):
    """Read only references; return {relative staged path: generated contents}."""
    first = family["first_prototype"]
    fail_unless(first["tier"] == tier["id"], "Only configured first prototype is supported in ME2")
    fail_unless(first["status"] == "not_generated" and first["planned_spawn_integration"] is False,
                "ME2 must not integrate spawn pools")
    fid = family["id"]
    fail_unless(bool(VALID_NAME.fullmatch(fid)), "Invalid family id")
    source = get_source(family, first["source_tier"])
    source_record = source["record"]
    monster = read_game_dbr(source_record)
    fail_unless(monster.get("templateName") == "database/templates/monster.tpl", "Wrong monster template")
    fail_unless(monster.get("monsterClassification") == source["expected_classification"],
                "Unexpected parent classification")
    proto = tier["prototype"]
    stats = proto["stats_vs_parent"]

    target_monster = first["future_output_record"]
    prefix = f"{fid}_{tier['id']}_01"
    monster_namespace = "records/creatures/enemies/monsterexpansion/"
    fail_unless(target_monster == monster_namespace + prefix + ".dbr", "Unexpected prototype output name")
    bio_record = monster_namespace + "bios/" + prefix + "_bio.dbr"
    damage_record = "records/skills/nonplayerskills/monsterexpansion/" + prefix + "_damage.dbr"
    damage_source = first["damage_skill_source_record"]
    source_skills = [monster.get(f"skillName{n}") for n in range(1, 25)
                     if any(line.startswith(f"skillName{n},") for line in monster.lines)]
    fail_unless(source_skills.count(damage_source) == 1,
                "Configured damage skill must be assigned to the monster exactly once")

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
    for idx in range(1, 25):
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

    aura_files = build_cosmetic_aura(monster, proto, prefix)
    result = {
        **aura_files,
        game_location(target_monster): monster.render(),
        game_location(bio_record): bio.render(),
        game_location(damage_record): damage.render(),
    }
    spawn_summary = {"included": False}
    if include_spawns:
        pool_record, pool_text, spawn_summary = build_pool_override(family, tier, REFERENCE)
        result[game_location(pool_record)] = pool_text
    manifest = {
        "schema_version": 1,
        "phase": "ME3" if include_spawns else "ME2",
        "natural_spawns": spawn_summary,
        "family": fid,
        "tier": tier["id"],
        "vanilla_source": source_record,
        "output_monster": target_monster,
        "files": sorted(p.as_posix() for p in result),
        "settings_provisional": stats,
        "model_scale_vs_parent": proto["model_scale_vs_parent"],
        "color_target_only": tier["color_hex"],
        "cosmetic_aura": {"enabled": bool(aura_files), "runtime_verified": True,
                          "particle_tint_verified": False, "uses_base_game_particle": True},
        "not_implemented": [
            "natural spawn frequency calibration", "exact tier tint and aura intensity", "name and health bar UI color",
            "melee/charge hitbox and range scaling", "compilation and in-game testing",
            "uniform total damage multiplier"
        ],
    }
    if not include_spawns:
        manifest["not_implemented"].append("spawn pool integration")
    result[Path("manifest.json")] = json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    return result


def write_staged(files, output_root, overwrite=False):
    """Write only inside a dedicated stage root, after preflighting all targets."""
    root = Path(output_root)
    fail_unless(root.absolute() == OUTPUT.absolute(), "ME2 output root must remain generated/MonsterExpansion")
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
    parser.add_argument("--family", default="boar", help="ME2 currently supports boar")
    parser.add_argument("--include-spawns", action="store_true", help="Include the scoped ME3 boar pool override")
    parser.add_argument("--write", action="store_true", help="Stage the output in generated/ (ignored by Git)")
    parser.add_argument("--replace-generated", action="store_true", help="Replace changed generated files (requires --write)")
    args = parser.parse_args()
    try:
        fail_unless(not args.replace_generated or args.write,
                    "--replace-generated requires --write")
        fail_unless(bool(VALID_NAME.fullmatch(args.family)), "Invalid family name")
        validation = check_configs(REFERENCE)
        fail_unless(not validation, "; ".join(validation))
        family = json.loads((REPO / "config" / "families" / f"{args.family}.json").read_text(encoding="utf-8"))
        tiers = json.loads((REPO / "config" / "tiers.json").read_text(encoding="utf-8"))["tiers"]
        selected = [t for t in tiers if t["id"] == family["first_prototype"]["tier"]]
        fail_unless(len(selected) == 1, "Expected exactly one configured prototype tier")
        files = build_variant(family, selected[0], include_spawns=args.include_spawns)
        print(f"{'ME3' if args.include_spawns else 'ME2'}: {family['display_name']} / {selected[0]['name']}")
        for p in sorted(files):
            print(f"  {'WRITE' if args.write else 'PLAN '} {p} ({len(files[p])} chars)")
        if args.write:
            write_staged(files, OUTPUT, overwrite=args.replace_generated)
            print("Staged in generated/MonsterExpansion/. Rebuild/install required.")
            if not args.include_spawns:
                print("No pool emitted. Existing staged pool overrides are NOT removed; see docs/ME3_NATURAL_SPAWNS.md.")
        else:
            print("Dry run only. Re-run with --write to stage files (not into Asset Manager).")
        return 0
    except (GenerationError, DBRError, ValueError, KeyError, OSError) as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
