> **Custom zombie names:** Now requires building the text asset and copying Text_EN.arc as well as the .arz. See [instructions](../docs/VETERAN_NAMES.md).

> **October 19 update:** [Current config-driven families guide](../docs/DATA_DRIVEN_FAMILIES.md) supersedes old schema, record counts and config keys below. Generate/stage all families for 30 DBRs. Original boar visuals and proxy/pool selection were verified by the user; new zombies remain untested in-game.

> **Natural-spawn update:** See [ME3 instructions](../docs/ME3_NATURAL_SPAWNS.md) for the current seven-record build, `--include-spawns` flags, centralized tier settings and rollback. The console-only workflow below does not remove an existing pool override.

# Debug Enemy Spawner — Console Prototype (pre-ME3)

Goal: spawn an individual monster on demand WITHOUT changing original spawn pools.

Current test uses the built-in Grim Dawn Custom Game console; no GUI/hotkey yet. Spawn occurs at/near the player, NOT precisely 256 pixels in front. The Veteran Boar now includes an unverified cosmetic nature-glow test; exact green coloring and custom name/HP-bar appearance remain unimplemented. See [the aura test guide](../docs/VETERAN_AURA_TEST.md).

## A. Stage the record (in VS Code Terminal)

Run from the repository root under your Asset Manager Working/mods/Ben_MonsterExpansion folder:

    git pull
    python -m unittest discover -s tests -v
    python scripts/validate_config.py
    python scripts/generate_variants.py --write --replace-generated
    python scripts/prepare_console_test.py
    python scripts/prepare_console_test.py --stage --replace-staged

The last command stages ONLY the six allowlisted monster/bio/damage/cosmetic skill/FX pack/effect .dbr files into the repo's database/records path, which Asset Manager can build. The folder is Git-ignored. Do not put the entire ReferenceFiles directory in your mod. No original game files or spawn pools are changed. Changed staged records require the explicit --replace-staged flag.

## B. Build with Asset Manager

1. Launch AssetManager.exe from the installed Grim Dawn folder; select Work Offline.
2. Tools > Options: Working directory must be the PARENT of the mods directory (your M: drive .../Modding/Grim Dawn/Working), not the repo itself. Tools directory is the actual Grim Dawn install.
3. Use a separate safe Build directory (for example the Working folder) during the first build, not your live Grim Dawn install. Accidentally rebuilding the base game can damage original game archives.
4. Mod > Select > Ben_MonsterExpansion. If it is missing, or the editor suggests deleting/overwriting the repo, STOP and send a screenshot. The tool may require Mod > New, but do not run it blindly over existing files.
5. CONFIRM Ben_MonsterExpansion is selected; then Build > Build (F7), inspect the output log for success.

The desired compiled file is Ben_MonsterExpansion.arz, typically in the Build directory's mods/Ben_MonsterExpansion/database folder. Its exact location depends on your Asset Manager Options.

## C. Make the Custom Game available

If the build destination differs from the installed game, copy ONLY Ben_MonsterExpansion.arz into:

    <Grim Dawn game installation>/mods/Ben_MonsterExpansion/database/Ben_MonsterExpansion.arz

Backup existing Custom Game saves and launch Grim Dawn > Custom Game > Ben_MonsterExpansion (select world001 if offered). Use a new test character.

## D. Open the console and spawn

In a Custom Game, press tilde/backtick (~) or apostrophe (depends on keyboard). Type:

    game.Spawn "records/creatures/enemies/monsterexpansion/boar_veteran_01.dbr"

Control comparisons (vanilla):

    game.Spawn "records/creatures/enemies/boar_a01.dbr"
    game.Spawn "records/creatures/enemies/boar_b01.dbr"
    game.Spawn "records/creatures/enemies/hero/boar_h01.dbr"

Optional safety while testing:

    game.God true

and turn off with:

    game.God false

The generated Veteran currently preserves its Common name/classification; inspect its slightly larger size and combat. Elite/Ascended/Apex Boar records do NOT exist yet.

## E. Report the result

1. Does Ben_MonsterExpansion show under Custom Game?
2. Does the console open?
3. Can you spawn a vanilla boar?
4. Can you spawn the Veteran Boar?
5. Does the new boar render, path, and hit correctly?

If the original boar spawns but the custom boar doesn't, show the exact console response and Asset Manager build log. Do not edit base game archives.

Useful sources:
- https://forums.crateentertainment.com/t/console-commands-reference/32174
- https://forums.crateentertainment.com/t/tool-gd-console-unlocker-change-ravager-reset-mogdrogen-teleport-warp-if-stuck-etc-in-main-campaign/145961/20
- https://www.grimdawn.com/downloads/Grim%20Dawn%20Modding%20Guide.pdf
