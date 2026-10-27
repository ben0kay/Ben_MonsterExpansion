# Configurable player level cap — 150

**Status:** Implemented on `dev`; generated DBR contents and in-game leveling
past 100 still require verification after updating/building the mod locally.

## What changes

`config/player_stats.json` now contains:

```json
"level_cap": {
  "enabled": true,
  "max_level": 150
}
```

The cap is independent of the existing `player_stats.enabled` attribute-point
toggle and `devotion.enabled`. A separate level-cap toggle allows a clean
rollback without giving up the 2 attribute points per level, +6 per spent point,
2 Devotion points per shrine, or 85 Devotion cap.

Three effective GDX2 > GDX1 > base game fields are patched when enabled:

| Generated DBR | Field | Native | Configured |
| --- | --- | --- | --- |
| `records/creatures/pc/playerlevels.dbr` | `maxPlayerLevel` | 100 | **150** |
| `records/creatures/pc/malepc01.dbr` | `maxLevel` | 100 | **150** |
| `records/creatures/pc/femalepc01.dbr` | `maxLevel` | 100 | **150** |

`build_player_stats` writes `playerlevels.dbr`; the new
`build_player_level_cap` step runs **after** the existing player movement and
starting health/energy composition, and changes only the two `maxLevel` fields.
No original `ReferenceFiles` are edited, no duplicate player actor records
are emitted, and the generated manifest includes the cap configuration and
actor-level report.

## Existing progression preserved

- The native 199-entry `skillModifierPoints` table already covers awards up
  to level 200, including **1 skill point per level from 91 onward**. We do
  **not** increase mastery/skill points per level in this pass.
- Attribute points: **2 per level**; Physique, Cunning and Spirit still
  gain **+6 per spent point**.
- Original per-level health/energy increments, leveling XP equation,
  mastery requirements, skill ranks, devotion-point awards and caps
  remain unchanged (except the separate established mod changes).
- Settings validate a requested cap between **100 and 200** and verify
  that the source skill-point table covers the requested level.

## Limitations and checks

Raising player max level **does not automatically extend enemy/world level
scaling**. Existing campaign world level-limit layers and some enemy proxies
may stop scaling monsters before the player reaches 150. Item drop/item level
ranges and endgame balance also have their own limits. Those are separate
tuning tasks, not silently changed here. A level cap recorded as 150 in DBRs
is **not proof of runtime progress past 100**; verify in-game.

Before testing on an existing character, **back up character saves**.
Existing-character leveling, level 101+ quest rewards/XP, monster spawning,
quest scripts and equipment behavior are not confirmed in-game. Prefer first
testing with a fresh custom-game character and checking actual level 101,
attribute/skill gains and enemies in a high-level area.

## Local rebuild

From the `dev` branch in the Asset Manager mod source:

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python -m unittest discover -s tests -p test_player_stats.py -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Build in Asset Manager (F7), install the rebuilt `.arz` alongside existing
custom text assets, and launch **Custom Game**. Check the level cap and leveling
on the rebuilt game, rather than assuming the repository commit installs it.

## Rollback

Set `config/player_stats.json` > `level_cap.enabled` to `false` (or set
`max_level` to 100), then regenerate, **replacement-stage** and rebuild.
Both player actors' `maxLevel` and the shared `maxPlayerLevel` return to
100 while existing character movement, starting stats, attribute/devo settings
and other mod functionality remain intact. Do not lower the cap on a save
already above level 100 without first backing it up.
