# Displaying Walking Dead (Veteran)

> Historical first-name prototype from October 19. The generator now supports
> automatic names for all custom tiers. See [current enemy-name guide](ENEMY_NAMES.md).

October 19, 2026. The user confirmed a green Veteran zombie appeared naturally
in an early Lower Crossing house. This verifies at least one opening-area map
encounter resolves a modified pool. It does not establish all map coverage or
frequency. The newly requested name labels still need an in-game check.

## What changes

Both configured zombie variants now have `display_name: "Walking Dead"`, matching
the name visible in the user's English game screenshot. The generator assigns a
unique custom `description` tag and emits English strings such as:

```text
tagBME_zombie_veteran_01=Walking Dead (Veteran)
tagBME_zombie_veteran_starter_01=Walking Dead (Veteran)
```

The tier suffix comes from its configured name. This is reusable for future
variants; `display_name` is optional. If absent, the original description tag
is preserved. Boar names stay unchanged because their exact English strings
have not been supplied/verified; do not guess names or override vanilla tags.
The mechanism requires explicit translated names for additional languages;
this pass generates only Text_EN.

No stats, glow, spawn weights or classification change in this pass. The existing
Walking Dead label is replaced only on the custom variants. Vanilla Walking Dead
and the faction/subtitle (e.g. Aether Corruption) retain their existing tags.

## Generate and stage

```powershell
git pull
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Expected: **30 DBRs + 1 text source**, at:

```text
source/Text_EN/tags_benmonsterexpansion.txt
```

## New Asset Manager step — text needs a resource build

1. Select **Ben_MonsterExpansion** in Asset Manager. Restart Asset Manager if the
   newly created Text_EN folder is missing; it may cache external directory changes.
2. Open the **Sources** tab, expand **Text_EN**, and locate
   `tags_benmonsterexpansion.txt`.
3. Right-click that file and select **Auto-Create Asset**. Do this once for the
   new text file. If it presents an unclear asset-type prompt, share a screenshot.
4. Build with **F7** and verify the log includes the text resource and no errors.
5. Install BOTH compiled files, preserving their directories:

| From the mod's build output | Installed custom mod destination |
| --- | --- |
| `database/Ben_MonsterExpansion.arz` | `mods/Ben_MonsterExpansion/database/Ben_MonsterExpansion.arz` |
| `resources/Text_EN.arc` (case may display differently) | `mods/Ben_MonsterExpansion/resources/Text_EN.arc` |

Use your existing sibling Build directory and actual Grim Dawn install as before.
Do not replace base-game Text_EN.arc or other original archives. If the mod's
resources folder does not exist in the installed location, create that folder.
Copying only the `.arz` is no longer sufficient for these custom names.

Restart the Custom Game and hover a newly spawned Veteran zombie. The top name
should read **Walking Dead (Veteran)**. Direct test if needed:

```text
game.Spawn "records/creatures/enemies/monsterexpansion/zombie_veteran_starter_01.dbr"
```

A `Tag not found: tagBME_...` label means the updated monster is loaded but its
text tag is not resolving. Check Auto-Create Asset, the resource build, English
game language and installed mod Text_EN.arc. Do not modify health-bar UI files.

## Evidence and checks

The official Grim Dawn Modding Guide describes string tag definitions in
Sources/Text_EN, source asset creation, and shipping compiled `.arc` resources:
https://www.grimdawn.com/downloads/Grim%20Dawn%20Modding%20Guide.pdf

28 Python tests pass, including generated tag-to-text resolution, unchanged
vanilla tags and boar records, validation of display strings and staging only
the exact recomputed text/DBR plan. Runtime archive loading and header appearance
still require the user's Asset Manager/game test.
