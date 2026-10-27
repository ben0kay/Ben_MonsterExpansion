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
toggle, `skill_points_per_level.enabled`, and `devotion.enabled`.
Each section supports independent rollback without giving up the other changes:
2 attribute points per level, +6 per spent point, 2 Devotion points per shrine,
85 Devotion cap, and the configured skill-point awards.

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

## Skill-point progression — enhanced

The `skill_points_per_level` configuration in `config/player_stats.json`
adjusts the native `skillModifierPoints` award array by **level attained**,
with index 0 being the reward for reaching level 2. The original 199-entry
array already covers up to level 200. Levels above 150 keep their original
values, should the maximum level be changed later.

| Level reached | Native award | Mod award | Levels covered | Points awarded by the mod |
| --- | ---: | ---: | ---: | ---: |
| 2–50 | 3 | 3 | 49 | 147 |
| 51–60 | 2 | **3** | 10 | 30 |
| 61–90 | 2 | 2 | 30 | 60 |
| 91–100 | 1 | **2** | 10 | 20 |
| 101–150 | 1 | 1 | 50 | 50 |
| **Total through level 150** | | | **149** | **307** |

The unmodified source curve totals **237** level-up points through level 100
and **287** through level 150 if the native award table is kept alongside
the higher cap. The new curve totals **257** through level 100 and **307**
through level 150: **20 extra** points, coming entirely from levels 51–60
and 91–100. Quest rewards and any initial character points are excluded.

`skill_points_per_level.enabled=false` restores the exact native 199-entry
skill-point array independently, even while the character remains level 150.
Validation requires contiguous positive-integer reward bands beginning at
level 2, a per-level award between 1 and 20, and full coverage of the
configured level cap. No modification to mastery skill ranks is needed.

## Other progression preserved

- Attribute points: **2 per level**; Physique, Cunning and Spirit still
  gain **+6 per spent point**.
- Original per-level health/energy increments, leveling XP equation,
  mastery requirements, skill ranks and devotion-point awards/caps
  remain unchanged, except for the established existing modifications.
- Maximum level remains **150**. Cap validation accepts **100 to 200**,
  bounded by the 199 native skill-award entries.

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

Set `config/player_stats.json` > `skill_points_per_level.enabled` to
`false` to restore the original skill-point rewards without changing the
level 150 cap, attributes or devotion. To restore the native level cap too,
set `level_cap.enabled` to `false` (or set `max_level` to 100).
Then regenerate, **replacement-stage** and rebuild.
Both player actors' `maxLevel` and the shared `maxPlayerLevel` return to
100 while existing character movement, starting stats, attribute/devo settings
and other mod functionality remain intact. Do not lower the cap on a save
already above level 100 without first backing it up.
