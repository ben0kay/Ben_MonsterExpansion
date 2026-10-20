# Grim Dawn — Ben MonsterExpansion

Expand Grim Dawn's monster families with reusable, config-driven tier variants,
while retaining the original game's enemies, roles and encounters.

**Current checkpoint — October 19, 2026:** The original Veteran Boar builds,
spawns, has verified +30% HP (92 vs 71 at one test level), and has a green glow
approved by the user. Spawning the vanilla boar proxy selected a custom Veteran,
confirming the modified pool works. The user has also confirmed a naturally spawned green Veteran zombie in an early
Lower Crossing house. Frequency and broader map coverage remain unmeasured. The generator is now generic and includes **boars plus starting
zombies**. An additional **96 audited Veteran variants in 200 pools** are now enabled for the next build/playtest. Python checks: **48 passing tests**.

## DLC reference priority

Tools now use **GDX2 > GDX1 > base**, resolving each logical `records/...` path
from `ReferenceFiles/gdx2/database/records/`, then the corresponding `gdx1`
folder, then `ReferenceFiles/`. Generated paths keep the original game namespace.
Discovery includes expansion pool folders and deduplicates overridden records.

All 100 active variants / 206 pools validate with the uploaded DLC records.
Only the cave half-troll Veteran monster output changes versus the base-only
build; all other generated content, including pack equations, is identical.
A fresh scan found **48 additional candidate sources / 119 pools**, not enabled.
Six entries flag missing/invalid dependencies; see the generated JSON for details.
Player attributes are still unchanged; GDX1 and GDX2 player-level records match.

## Veteran discovery scanner

The scanner is implemented and has been run on the uploaded references:
**96 new mechanically compatible sources, 431 candidate regular selections,
200 candidate pools**, plus explicit reasons for excluded/review-required entries.
The reviewed snapshot is now enabled in `config/families/discovered_veterans.json`.
All 431 substitutions passed a generated-pool comparison: exact 80/20 split,
inherited level rules, unchanged Champion/count fields and existing mod output.
The 96 new variants still need in-game testing. Discovery itself remains read-only.

```powershell
python scripts/discover_veterans.py
python scripts/discover_veterans.py --write-report --draft-config
```

Default is read-only. Optional reports and a disabled aggregate config go only to
`generated/discovery/`; active config, DBRs and the playable mod stay unchanged.
New shared pools are combined once; existing boar/zombie sources and owned pools
are flagged for merge review rather than overwritten. Extracted English tag files
are missing; provide a Text_EN directory via `--text-root` for automatic names.

See [scanner instructions and limitations](docs/VETERAN_DISCOVERY.md) and
[scan snapshot](docs/VETERAN_DISCOVERY_REPORT.md). The enabled snapshot adds 96 variants;
unresolved names retain their vanilla text, while existing zombie labels remain intact.

## Global pack size

`config/master.json` now enables **1.5x regular pack size** through
`monster_spawning.pack_size_multiplier`. Set `1.0` for vanilla size, `2.0` for
2x, or `enabled=false` to emit the exact vanilla equation for rollback.
Settings require generate/stage **with `--include-spawns`**, F7 and reinstalling
the rebuilt `.arz`. Omitting the flag/removing the setting does not undo a
previously compiled override. This JSON is build input, not a live game setting.

The shared `records/proxies/proxypoolequation_01.dbr` changes only
`spawnMinEquation` and `spawnMaxEquation`; Champion equations remain byte-identical.
315 of 326 immediate reference pools use it (538 pool records across the full
reference tree). Any referencing pool is affected, including special encounters;
this global override cannot exclude particular pools. It adds monsters at existing
encounters, not new map placements. Existing limits still apply, and engine
rounding, placement/caps and actual pack increases need in-game testing.
Veteran selection remains 20% within eligible mapped selections.

## Build this version

Run in the local repository under `Working/mods/Ben_MonsterExpansion`:

```powershell
git pull
python scripts/validate_config.py
python -m unittest discover -s tests -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Expect **807 DBRs + 1 text source**: 100 monster variants with supporting records and 206 pool
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
classification, textures, collision and existing skills remain intact. Zombie
name labels use custom tags for `Walking Dead (Veteran)`, now verified in-game. Boar names retain their original tags.
Cosmetic skill and initial slots are selected safely without overwriting occupied
slots. Glow intensity/particle scale controls and exact RGB tint remain unproven.

**Agreed spawning policy:** Replace a portion of each eligible original enemy's
selection weight with a variant derived from that exact source. This is per
enemy selection, not per pack, and does not transform an already spawned enemy.

| Original selection | Stays original | Replacement | Implementation |
| --- | ---: | --- | --- |
| Common | 80% | 20% Veteran | Implemented for mapped boars/zombies |
| Champion | 67% | 33% Elite | Agreed; not implemented |
| Hero | 67% | 33% Ascended | Agreed; not implemented |
| Nemesis | 90% | 10% Apex | Provisional agreement; not implemented |

**Strict parent rules; no cross-tier fallbacks.** Elite must derive from Champion,
Ascended from Hero, and Apex from Nemesis. If a suitable parent is unavailable,
skip that variant. Bosses remain unchanged. Preserve source level/faction/quest
eligibility and encounter counts. Nemesis spawning needs independent investigation;
do not assume regular pool splitting can be applied to it unchanged.

The earlier 2.5 Veterans-per-Champion target is superseded as the governing
spawn rule by these per-parent conversion percentages; the current Common split
is still 20%. Existing config may retain the old target as reporting metadata.
Limited/forced entries, loot droppers, summons, corpses and scripted encounters
remain excluded pending explicit policies. Current code only splits mapped
regular Common entries; the other three conversions require implementation.
Pool overrides affect encounters resolving those exact paths.

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
| 9 | Apex | New | Crimson/Pink `#E94488` | Derived from Nemesis; provisional 10% replacement |

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
| Generic family pipeline + starting zombies | Implemented; natural Veteran zombie observed in an early Lower Crossing house |
| Generated Veteran zombie name labels | Passed in-game; correct header and original faction subtitle confirmed |
| Broader Veteran coverage | 96 additional audited variants enabled across 200 pools; build/runtime testing pending |
| Champion → Elite (33%) | Future: inspect Champion selections, preserve limits/eligibility, generate exact-parent variants and test |
| Hero → Ascended (33%) | Future: preserve named identity/skills and encounter restrictions; no Common/Champion fallback |
| Nemesis → Apex (10%) | Future: investigate Nemesis activation/spawning before implementing provisional replacement chance |
| Higher-tier visuals/abilities/rewards | Pending evidence, minimal prototypes and playtesting |
| Debug hotkey GUI / exact forward spawn | Requested, unimplemented; console only for now |

The generic generator, safe skill/initial-slot allocation, exact Common weight
splitting, validated staging and name-text generation are implemented; the latest
Python suite has **48 passing tests**. The original Veteran Boar's six-record
regression is byte-identical. 100 variants and 206 pool overrides generate
807 DBRs plus one English text source.

The user has now verified `Walking Dead (Veteran)` in the header with the green
glow and original Aether Corruption subtitle. Continue movement/death/combat checks
and larger rarity samples; this is not proof of every map placement or variant.

The discovery scanner and audited 96-variant activation are complete. Next work
is build/playtesting, English tag resolution and explicit handling of
existing-pool extensions/finite quotas. All strict tier-parent rules above remain.

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
