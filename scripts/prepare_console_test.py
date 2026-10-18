#!/usr/bin/env python3
"""Stage the generated Veteran Boar inside the Asset Manager mod source.

Usage: python scripts/prepare_console_test.py [--stage] [--replace-staged]
Only --stage writes files. Builds and in-game spawning remain manual.
"""
import argparse
import json
import os
import sys
import tempfile
from pathlib import Path

from generate_variants import REPO, OUTPUT, build_variant, GenerationError
from validate_config import check_configs

MOD_NAME = "Ben_MonsterExpansion"
ALLOWED = {
    Path("database/records/creatures/enemies/monsterexpansion/boar_veteran_01.dbr"),
    Path("database/records/creatures/enemies/monsterexpansion/bios/boar_veteran_01_bio.dbr"),
    Path("database/records/skills/nonplayerskills/monsterexpansion/boar_veteran_01_damage.dbr"),
}
AURA_ALLOWED = {
    Path("database/records/skills/nonplayerskills/monsterexpansion/boar_veteran_01_cosmetic.dbr"),
    Path("database/records/fx/monsterexpansion/boar_veteran_01_cosmetic_chfxpak.dbr"),
    Path("database/records/fx/monsterexpansion/boar_veteran_01_cosmetic_fx.dbr"),
}
COMMAND = 'game.Spawn "records/creatures/enemies/monsterexpansion/boar_veteran_01.dbr"'


def require(condition, why):
    if not condition:
        raise GenerationError(why)


def preflight():
    errors = check_configs(REPO / "ReferenceFiles")
    require(not errors, "; ".join(errors))
    family = json.loads((REPO / "config/families/boar.json").read_text(encoding="utf-8"))
    tiers = json.loads((REPO / "config/tiers.json").read_text(encoding="utf-8"))["tiers"]
    tier = next(t for t in tiers if t["id"] == "veteran")
    require(family["first_prototype"]["tier"] == "veteran", "Prototype is no longer Veteran")
    current = build_variant(family, tier)
    planned = set(current) - {Path("manifest.json")}
    require(planned in (ALLOWED, ALLOWED | AURA_ALLOWED), "Unexpected output set; inspect the generator before staging")
    require(OUTPUT.is_dir() and not OUTPUT.is_symlink(), "Run generate_variants.py --write first")
    for path, expected in current.items():
        require(not path.is_absolute() and ".." not in path.parts, "Unsafe output path")
        file = OUTPUT / path
        require(file.is_file() and not file.is_symlink(), f"Missing generated file: {file}")
        require(file.read_text(encoding="utf-8") == expected,
                f"Stale generated file: {file}. Regenerate before staging.")
    return {k: current[k] for k in sorted(planned)}


def stage(files, repo=REPO, replace=False):
    require(repo.name == MOD_NAME and repo.parent.name.lower() == "mods",
            "Repo must live inside Asset Manager Working/mods/Ben_MonsterExpansion")
    require(set(files) in (ALLOWED, ALLOWED | AURA_ALLOWED), "Refusing unexpected game database paths")
    require(not (repo / "database").is_symlink(), "Refusing linked mod database directory")
    updates = []
    for path, text in sorted(files.items()):
        require(not path.is_absolute() and ".." not in path.parts and
                path.as_posix().startswith("database/records/"), "Unsafe target")
        target = repo / path
        for item in (target, *target.parents):
            if item == repo:
                break
            require(not item.is_symlink(), f"Linked output path: {item}")
        if target.exists():
            require(target.is_file(), f"Target is not a file: {target}")
            require(target.read_text(encoding="utf-8") == text or replace,
                    f"Changed staged file: {target}. Use --replace-staged deliberately.")
        updates.append((target, text))
    for target, text in updates:
        if target.exists() and target.read_text(encoding="utf-8") == text:
            continue
        target.parent.mkdir(parents=True, exist_ok=True)
        temp = None
        try:
            with tempfile.NamedTemporaryFile("w", encoding="utf-8", newline="",
                                             dir=target.parent, prefix=".me-stage-",
                                             delete=False) as handle:
                temp = Path(handle.name)
                handle.write(text)
            os.replace(temp, target)
        finally:
            if temp is not None:
                temp.unlink(missing_ok=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--stage", action="store_true", help="Stage only allowlisted generated DBRs into the mod's database/records")
    parser.add_argument("--replace-staged", action="store_true", help="Replace modified staged DBRs (requires --stage)")
    args = parser.parse_args()
    try:
        require(args.stage or not args.replace_staged, "--replace-staged requires --stage")
        files = preflight()
        for path in sorted(files):
            print(f"{'STAGE' if args.stage else 'PLAN '} {path}")
        if args.stage:
            stage(files, replace=args.replace_staged)
            print(f"PASS: staged {len(files)} DBRs. No spawn pools edited and no .arz built.")
        else:
            print("Dry run only; add --stage to copy files into this Asset Manager mod.")
        print("After building and loading the Custom Game, enter: " + COMMAND)
        return 0
    except (GenerationError, ValueError, OSError, KeyError, StopIteration) as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
