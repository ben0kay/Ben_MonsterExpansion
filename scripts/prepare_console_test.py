#!/usr/bin/env python3
"""Stage configured families inside the Asset Manager mod source.

Usage: python scripts/prepare_console_test.py [--stage] [--replace-staged]
Only --stage writes files. Builds and in-game spawning remain manual.
"""
import argparse
import json
import os
import sys
import tempfile
from pathlib import Path

from generate_variants import REPO, OUTPUT, configured_plan, GenerationError, TEXT_SOURCE
from dbr import DBRError

MOD_NAME = "Ben_MonsterExpansion"


def require(condition, why):
    if not condition:
        raise GenerationError(why)


def preflight(family="all", include_spawns=False):
    # Recompute from validated config; never trust a supplied manifest allowlist.
    current = configured_plan(family, include_spawns)
    require(OUTPUT.is_dir() and not OUTPUT.is_symlink(), "Generate with --write first")
    for path, expected in current.items():
        file = OUTPUT / path
        for parent in (file, *file.parents):
            if parent == OUTPUT.parent:
                break
            require(not parent.is_symlink(), f"Linked generated path: {parent}")
        require(file.is_file() and file.read_text(encoding="utf-8") == expected,
                f"Missing/stale generated file: {file}. Regenerate with matching options.")
    return {p: text for p, text in current.items() if p != Path("manifest.json")}


def stage(files, repo=REPO, replace=False, family="all", include_spawns=False):
    require(repo.name == MOD_NAME and repo.parent.name.lower() == "mods",
            "Repo must live inside Asset Manager Working/mods/Ben_MonsterExpansion")
    expected = configured_plan(family, include_spawns)
    expected.pop(Path("manifest.json"))
    require(files == expected, "Staging contents differ from the validated configuration plan")
    require(not (repo / "database").is_symlink(), "Refusing linked mod database directory")
    updates = []
    for path, text in sorted(files.items()):
        require(not path.is_absolute() and ".." not in path.parts and
                (path.as_posix().startswith("database/records/") or path == TEXT_SOURCE), "Unsafe target")
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
    parser.add_argument("--family", default="all", help="Same family selector used for generation")
    parser.add_argument("--include-spawns", action="store_true", help="Verify/stage configured pool overrides as well")
    parser.add_argument("--stage", action="store_true", help="Stage only allowlisted generated DBRs into the mod's database/records")
    parser.add_argument("--replace-staged", action="store_true", help="Replace modified staged DBRs (requires --stage)")
    args = parser.parse_args()
    try:
        require(args.stage or not args.replace_staged, "--replace-staged requires --stage")
        files = preflight(args.family, args.include_spawns)
        for path in sorted(files):
            print(f"{'STAGE' if args.stage else 'PLAN '} {path}")
        if args.stage:
            stage(files, replace=args.replace_staged, family=args.family, include_spawns=args.include_spawns)
            count = sum(p.suffix == ".dbr" for p in files)
            print(f"PASS: staged {count} DBRs and {len(files) - count} text source(s). No archives built.")
            if TEXT_SOURCE in files:
                print("NEW TEXT: Auto-Create Asset for source/Text_EN/tags_benmonsterexpansion.txt in Asset Manager, F7, then install resources/Text_EN.arc AND the .arz. See docs/ENEMY_NAMES.md.")
            if not args.include_spawns:
                print("Existing staged pool overrides are NOT removed. See docs/DATA_DRIVEN_FAMILIES.md for rollback.")
        else:
            print("Dry run only; add --stage to copy files into this Asset Manager mod.")
        print("Build/install, then test direct variants and proxy commands in docs/DATA_DRIVEN_FAMILIES.md.")
        return 0
    except (GenerationError, DBRError, ValueError, OSError, KeyError, StopIteration) as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
