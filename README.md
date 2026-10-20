# Grim Dawn — Ben MonsterExpansion

Expand Grim Dawn's monster families with reusable, config-driven tier variants,
while retaining the original game's enemies, roles and encounters.

**Current checkpoint — October 19, 2026:** The original Veteran Boar builds,
spawns, has verified +30% HP (92 vs 71 at one test level), and has a green glow
approved by the user. Spawning the vanilla boar proxy selected a custom Veteran,
confirming the modified pool works. The user has also confirmed a naturally spawned green Veteran zombie in an early
Lower Crossing house. Frequency and broader map coverage remain unmeasured. The generator is now generic and includes **boars plus starting
zombies**, ready for the next build/playtest. Python checks: **28 passing tests**.

## Build this version

Run in the local repository under `Working/mods/Ben_MonsterExpansion`:

```powershell
git pull
python scripts/validate_config.py
python -m unittest discover -s tests -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Expect **30 DBRs + 1 text source**: four monster variants plus supporting records and six pool
overrides. **New name-label step:** build the Text_EN source asset and install the
mod’s `resources/Text_EN.arc` alongside its `.arz`; see [Veteran names](docs/VETERAN_NAMES.md). Select the custom mod in Asset Manager, build with F7, copy its rebuilt
`.arz` into the installed mod, and restart the Custom Game. Do not compile the
reference tree into the mod. See [current build/test and rollback guide](docs/DATA_DRIVEN_FAMILIES.md)
and [Windows Asset Manager guide](docs/BUILD_AND_TEST.md).

Direct starter zombie test:

```text
game.Spawn "records/creatures/enemies/monsterexpansion/zombie_veteran_starter_01.dbr"
```

Early-zombie pool test (new command not yet playtested):

```text
game.Spawn "records/proxies/area001/zombie_e.dbr"
```

The existing boar direct-spawn command remains:

```text
game.Spawn "records/creatures/enemies/monsterexpansion/boar_veteran_01.dbr"
```

Keep the underscore before `01`: an earlier failure was a console-path typo,
not an aura regression. Existing boar proxy test:

```text
game.Spawn "records/proxies/area001/beasts_boar_n.dbr"
```

## Data-driven configuration

| Location | Responsibility |
| --- | --- |
| `config/tiers.json` | Shared stats, model scale, cosmetic preset and Common conversion share |
| `config/families/boar.json` | Two source boars, generated variants and one reviewed pool |
| `config/families/zombie.json` | Starter/normal zombie variants and five reviewed early pools |
| `scripts/generate_variants.py` | Generic variant/support record generation and manifest |
| `scripts/natural_spawns.py` | Generic regular-slot weight splitting and level-rule inheritance |
| `scripts/prepare_console_test.py` | Stage exactly the freshly validated generated plan |
| `scripts/validate_config.py` | Validate config, source records, proxy references and pool mappings |
| `scripts/preview_variants.py` | Read-only generation preview |

Adding another reviewed family requires JSON, not enemy-specific Python logic.
Generation defaults to all enabled families. `--family boar` or `--family zombie`
selects one family; use matching options for generation/staging. The current
implementation supports ordinary bio/physical-passive cloning, not universal
ability rewriting or automatic conversion of every monster.

Veteran baseline: 1.30× health, 1.08× defensive ability, 1.10× physical base-damage
passive, 1.10× visible model scale, approved vanilla nature-glow particle. The
passive adjustment is not a guaranteed 10% increase in final damage. Original
name/classification, textures, collision and existing skills remain intact.
Cosmetic skill and initial slots are selected safely without overwriting occupied
slots. Glow intensity/particle scale controls and exact RGB tint remain unproven.

**Spawning policy:** Convert 20% of each mapped Common entry's weight into its
corresponding Veteran. Preserve the remaining Common share, original variants,
level restrictions, total encounter counts and all Champion/Hero selection rules.
The 2.5 Veterans-per-Champion target is reporting context, not a guaranteed ratio.
Limited/forced entries, loot droppers, summons, corpses and scripted encounters
are excluded pending separate policies. Pool overrides affect encounters resolving
those exact paths; opening-map placement coverage still needs playtesting.

## Tier hierarchy and design

These tiers are monster hierarchy, distinct from Normal/Veteran/Elite/Ultimate
game difficulty. Custom tiers are separate generated DBRs, not new engine enums.

| Order | Tier | Origin | Target color | Parent / identity |
| ---: | --- | --- | --- | --- |
| 1 | Common | Vanilla | Grey `#A4A4A4` | Original baseline |
| 2 | Veteran | New | Green `#81AF71` | Derived from suitable Common variants |
| 3 | Champion | Vanilla | Yellow `#D5B743` | Preserve vanilla role; glow not guaranteed |
| 4 | Elite | New | Amber `#E49A36` | Derived from suitable Champions |
| 5 | Hero | Vanilla | Orange `#D57832` | Preserve named heroes and skills |
| 6 | Ascended | New | Violet `#AF69D2` | Selected enhanced Hero variants |
| 7 | Boss | Vanilla | Purple `#9370C4` | Preserve major encounters |
| 8 | Nemesis | Vanilla | Red `#D64B51` | Preserve faction threats |
| 9 | Apex | New | Crimson/Pink `#E94488` | Rare, curated pinnacle encounters |

Color values are design targets, not proof of name/health-bar color support.
The Veteran effect uses the approved vanilla particle without actor tint.
Higher tiers should be larger relative to suitable parents, stronger and potentially
use compatible extra abilities or altered frequency. Exact balance is provisional;
respect family/role/difficulty differences rather than a universal flat formula.
Collision footprint, melee/charge reach, skill radii and FX offsets require real
field inspection and playtesting; mesh scale does not prove these scale together.
Do not multiply every range indiscriminately. No bulk generation before reviewed
family sources and a successful small playable slice.

## Implementation phases and next work

| Phase | State |
| --- | --- |
| ME1 design/config/validation | Complete |
| ME2 Veteran Boar generation/build/direct test | Passed; approved green visual, HP verified |
| ME3 boar proxy/pool selection | Passed by user; rarity and natural map coverage still pending |
| Generic family pipeline + starting zombies | Implemented; 25 tests pass, new build/playtest pending |
| Elite/Ascended variants and abilities | Pending source/mechanism research |
| Apex encounter/reward prototype | Pending |
| Broader family coverage | Add reviewed configs after zombie test |
| Debug hotkey GUI / exact forward spawn | Requested, unimplemented; console only for now |

Next in-game checks: starter and normal zombie direct spawns, green effect on
movement/death, early proxy selection, opening-area natural encounters and larger
sample rarity. Boar02 retains its own vanilla stats/skills; its new Veteran and
the refactored pool need testing. The original boar six-record regression stays
byte-identical. Do not mark zombie results as verified from Python tests.

## Local paths and references

- Repository: [ben0kay/Ben_MonsterExpansion](https://github.com/ben0kay/Ben_MonsterExpansion), `main`.
- Working: `M:\BACKUPS\D_Drive\2025_11_01_D_Drive_Backup_Manual\My Media Content\Modding\Grim Dawn\Working\`
- Build: sibling `Build\`; repository under `Working\mods\Ben_MonsterExpansion\`.
- `ReferenceFiles/`: read-only extracted DBRs. `ReferenceFiles/Resources/`: templates,
  particle assets and textures used to establish supported fields/dependencies.
- Generated output: `generated/MonsterExpansion/` (ignored). Asset Manager source:
  repo `database/records/` (ignored). Original extracted game data is never edited.

Rollback a pool by setting its config `enabled=false`, then regenerate/stage with
`--include-spawns`, rebuild and reinstall: the exact vanilla pool is emitted.
Skipping/removing a family or omitting pool generation does NOT remove stale
staged/compiled records. See the current guide before rolling back.

## Documentation and working rules

- [Veteran name labels and new text-archive build step](docs/VETERAN_NAMES.md)
- [Current generic architecture and tests](docs/DATA_DRIVEN_FAMILIES.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Asset Manager/build/install reference](docs/BUILD_AND_TEST.md)
- [Earlier ME3 investigation](docs/ME3_NATURAL_SPAWNS.md)
- [Earlier aura evidence and test](docs/VETERAN_AURA_TEST.md)
- [Debug commands](debug/README.md)
- [Original project notes](PROJECT_NOTES.md)

Research actual records/templates → establish mechanism → implement minimal
reversible change → test/build/playtest → record only verified results. No invented
DBR fields, speculative PFX patches, vanilla archive edits or unrelated player
balance changes. Player level/devotion/pet proposals discussed separately are not
implemented by this monster-family pass.
