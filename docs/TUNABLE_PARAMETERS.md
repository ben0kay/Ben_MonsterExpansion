# More tunable Grim Dawn parameters (read-only catalog)

These values were inspected in the uploaded original/effective DLC DBR records.
They are **not enabled changes** in this mod unless otherwise noted. Some
settings need engine or in-game verification before adopting.

| Parameter | Current reference | Source logical record | Potential mod use |
| --- | --- | --- | --- |
| Base player run speed | 0.93 | `creatures/pc/{male,female}pc01.dbr` | **Active** +15% to 1.0695, both sexes |
| Starting life | 250 → **300 active** | Same player records | Starting base life; displayed total also depends on bio/progression |
| Starting mana/energy | 250 → **300 active** | Same player records | Starting base energy |
| Life regeneration | 1.0 | Same player records | Faster passive recovery; confirm units |
| Mana regeneration | 1.0 | Same player records | Faster energy recovery; confirm units |
| Offensive / defensive ability | 65 each | Same player records | Slight starting combat-stat tweaks |
| Base attack / cast speed | 1.25 each | Same player records | Faster attacks/casting; check animation and cap interactions |
| Visible character model scale | 1.05 | Same player records | Cosmetic player sizing; reach/collision not verified |
| Player movement speed cap | 135 → **145 active** | `game/gameengine.dbr` | Allows higher movement-speed bonuses |
| Attack / cast speed caps | 200 / 200 | `game/gameengine.dbr` | Allow more speed from gear/skills (balance risk) |
| Camera distance | min 20, default **36**, max **48** | `game/gameengine.dbr` | Default restored; in-game zoom remains adjustable |
| Camera pitch | min 38, default 46, max 52 | `game/gameengine.dbr` | Change camera angle |
| Potion stack limit | 100 | `game/gameengine.dbr` | Stack more potions |
| Maximum player level | native 100 → **150 active** | `creatures/pc/playerlevels.dbr` and `creatures/pc/{male,female}pc01.dbr` | Configurable cap up to 200; world/monster scaling is separate |
| Health increase per level | 20 | `creatures/pc/playerlevels.dbr` | More health from leveling |
| Energy increase per level | 16 | `creatures/pc/playerlevels.dbr` | More energy from leveling |
| Skill-point awards per level | `skillModifierPoints` rank array | `creatures/pc/playerlevels.dbr` | Tweak per-level skill-point distribution |
| Experience curve | `experienceLevelEquation` formula | `creatures/pc/playerlevels.dbr` | Faster/slower leveling (not a constant multiplier) |
| Devotion point cap | source 55 → mod 85 | `creatures/pc/playerlevels.dbr` | **Already active**, together with 2 points/shrine |
| Attribute points per level | source 1 → mod 2 | `creatures/pc/playerlevels.dbr` | **Already active** |
| Attribute gain per spent point | source +8 → mod +6 | `creatures/pc/playerlevels.dbr` | **Already active** |

All logical paths above are relative to `records/`. Player character references
are found in `ReferenceFiles/gdx2/database/records/` in the uploaded data.
The base `gameengine.dbr` is in `ReferenceFiles/game/`. Always use
GDX2 > GDX1 > base resolution before generating a new override.

Do not edit source reference files. The requested speed cap and camera defaults
are implemented via a focused reversible game-engine override.
The player level 150 cap is independently configured and composed into existing
player DBRs. See [Player basics](PLAYER_BASICS.md) and
[Player level cap](PLAYER_LEVEL_CAP.md). Other changes remain proposals.
