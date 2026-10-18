# Grim Dawn — Ben MonsterExpansion

An AI-assisted Grim Dawn mod project to expand the existing monster hierarchy, beginning with the base game's monsters and spawn pools. The goal is **recognizable tier visuals, progressively stronger stats, and increasingly interesting combat behavior**, while preserving the original game feel.

> **Status (October 18, 2026):** ME1 complete; ME2 Veteran Boar DBR generation and pre-ME3 isolated console-spawn staging helper committed. Generated monster records are **not yet confirmed compiled or tested in-game**. Normal spawn pools, tier FX/UI colors, custom spawner GUI and the other new tiers are not implemented.

## Project location and workflow

- **Repository:** [ben0kay/Ben_MonsterExpansion](https://github.com/ben0kay/Ben_MonsterExpansion)
- **Branch:** `main`
- **Local Asset Manager working directory:** Located on the user's `M:` drive under a `Modding\Grim Dawn\Working` directory (the complete path and intended mod build folder should be confirmed before writing build scripts).
- **Extracted reference root:** `Working\database\records\`
- **Workflow:** Edit code/config/DBR mod sources in GitHub + VS Code (ChatGPT/Codex), pull locally, compile with Grim Dawn Asset Manager, test in-game, iterate.
- **ReferenceFiles/** contains selected extracted base-game `.dbr` examples to guide design. Treat originals as references, not files to overwrite.

## Agreed nine-tier hierarchy

The ordering below is **enemy tier hierarchy**, *not* Grim Dawn's game difficulty (Normal/Veteran/Elite/Ultimate).

| Order | Tier | Type | Color identity | Hex | Intended appearance / combat identity |
| ---: | --- | --- | --- | --- | --- |
| 1 | **Common** | Original | Grey | `#A4A4A4` | Standard enemies; vanilla appearance and attacks |
| 2 | **Veteran** | **New** | Green | `#81AF71` | Subtle green tint/glow; modest stat increase; may move or attack faster |
| 3 | **Champion** | Original | Yellow | `#D5B743` | Preserve the existing champion role and recognizable look |
| 4 | **Elite** | **New** | Amber | `#E49A36` | Noticeable warm glow; tougher than comparable champions; sometimes extra skills or more frequent ability use |
| 5 | **Hero** | Original | Orange | `#D57832` | Preserve named heroes and their characteristic abilities |
| 6 | **Ascended** | **New** | Violet | `#AF69D2` | Strong violet aura; enhanced hero variants, improved ability use and additional skills where suitable |
| 7 | **Boss** | Original | Purple | `#9370C4` | Preserve major boss encounters and identity |
| 8 | **Nemesis** | Original | Red | `#D64B51` | Preserve faction-specific Nemesis threats |
| 9 | **Apex** | **New** | Crimson/Pink | `#E94488` | Extremely rare, intimidating pinnacle enemies; dramatic aura, exceptional combat challenge and special rewards |

These colors are **design targets**, not evidence that each can be applied to all game UI surfaces.

### Visual identity requirements

1. **Enemy appearance:** Differentiation through supported textures/tints, glow or particle effects, auras and potentially scale; prefer a distinctive, readable tier silhouette/effect rather than recoloring everything indiscriminately.
2. **Enemy name and health bar:** **Desired:** a matching distinct color for each of the nine tiers **where technically possible**. Built-in Grim Dawn monster classifications control some UI presentation. **Do not assume new nameplate/health-bar colors can be added by DBR alone**; investigate and prototype supported behavior before claiming this feature works.
3. **Consistency:** A Veteran boar and Veteran skeleton should convey the same tier color without forcing identical skills or model assets. Keep color values centralized in future configuration.

### Stat progression requirements

- New tiers must represent a meaningful increase above the preceding comparable tier.
- Relevant stats may include health, damage, defenses, resistances, attack/movement speed and experience/loot rewards.
- **Do not use a single global flat formula** for all monster families; compare within a family/role and respect the different base-game stat equations.
- Exact multipliers are **not agreed yet**. Balance with playtesting, preferably from minimal, testable changes.
- Preserve sensible Normal/Elite/Ultimate difficulty scaling rather than conflating it with monster rarity tiers.

### Physical size and combat reach requirements

- **Agreed:** Each new tier should be visually larger than its **appropriate parent monster/variant**, in addition to its distinct color, stats, and abilities. Keep the growth noticeable but generally modest; preserve original-tier monsters at vanilla sizes unless a specific override is approved.
- **Example design targets (not locked gameplay values):** Veteran 1.10× common; Elite 1.10× champion; Ascended 1.15× hero; Apex roughly 1.20–1.35× an appropriate high-tier source model. No universal size factor for all Bosses/Nemeses or unrelated families.
- **Evidence from current references:** `boar_a01.dbr` has `scale=1.0, actorRadius=0.75`; `boar_b01.dbr` has `scale=1.6, actorRadius=0.75`; `boar_h01.dbr` has `scale=2.0, actorRadius=0.70`. Scale and actorRadius are clearly separate record fields; their *actual runtime collision behavior* requires a playtest.
- **Functional scaling, not cosmetic scaling only:** Investigate/update collision footprint, melee engagement/reach, compatible radius/cleave attacks, charges, projectile and FX spawn offsets, attack VFX and overhead nameplate positioning where relevant. Avoid globally multiplying every skill radius or movement parameter.
- **Combat integrity:** Large creatures should neither whiff melee hits due to undersized range nor hit players beyond the visible attack. Verify pathfinding around doorways, bridges and other narrow terrain before enabling huge models.
- **Data-driven:** Future family/tier configuration should support `visual_scale` and separate optional `collision_radius`, `melee_reach`, `aoe_radius`, `fx_offset`/family-specific overrides, but first inspect supported fields from the original enemy and skill records. Do not assume these are literal DBR field names.

### Ability behavior requirements

- Higher tiers may **gain additional compatible abilities**, enhance existing abilities or **use certain skills more often**.
- Not every enemy must gain a new skill at each tier; variety should depend on family, role and difficulty.
- Ability selection, cooldown/delay/frequency and compatibility must be established from real Grim Dawn monster/controller/skill records before implementing.
- Make abilities and frequency overrides data-driven where practical, with per-family exceptions.

## Technical strategy / engine constraints

- Keep the game's existing `monsterClassification` values; **Veteran, Elite, Ascended and Apex are custom gameplay tiers, not new engine enum values**.
- Implement new tiers via separate derived monster `.dbr` variants plus suitable spawn pool/proxy changes and any supporting skills, attribute-equation records, loot and visual assets.
- The design color cannot necessarily be reproduced in nameplates or HP bars without unsupported engine/UI modifications. Prototype a visual fallback (tint/aura/effect) first.
- Prefer generation/configuration scripts over manually editing hundreds of records. A future generator must use true DBR field names, preserve original references, validate paths and avoid accidental edits to the extracted game's source records.
- Keep build products, large extracted assets and private local directories out of Git by default.

## Reference files received

All of these are in [ReferenceFiles/](ReferenceFiles/):

- `boar_a01.dbr`: common boar; `monsterClassification,Common`; bio reference `records/creatures/enemies/bios/bio_boar_01.dbr`.
- `bio_boar_01.dbr`: common boar attribute equations, including level-based life and offensive/defensive attributes.
- `boar_b01.dbr`: champion boar; `monsterClassification,Champion`; different bio record and skills.
- `boar_h01.dbr`: hero boar; `monsterClassification,Hero`; different bio record and additional hero-specific skills.
- `p_beasts_boar_n.dbr`: a boar proxy pool selecting common/champion/hero variants, weighted spawns and level rules.
- `beasts_boar_n.dbr`: proxy pointing to the above pool.
- `lv1_weak.dbr`, `limit_area000.dbr`: level variance and level range examples.

**Updated reference inventory (October 18, 2026):** The repository now contains over 21,000 extracted `.dbr` reference records. Additional material is organized under `ReferenceFiles/creatures/enemies/`, `ReferenceFiles/skills/nonplayerskills/`, `ReferenceFiles/nonplayerskills/`, `ReferenceFiles/proxies/`, `ReferenceFiles/fx/`, `ReferenceFiles/ui/`, `ReferenceFiles/controllers/`, and `ReferenceFiles/items/` (including loot tables and affixes). The boar bio, champion/hero and referenced attack records are present. The new files are **references**, not automatically compiled mod sources.

**Repository hygiene:** The repository is public and includes substantial extracted game data; consider keeping additional unmodified source assets local and switching to a private repository. Build scripts should never overwrite the original extracted records or include the entire reference set in the distributed mod.

## Implementation passes

1. **ME1 — Architecture/config (complete):** tier config, boar family mapping, read-only validator, preview and architecture specification.
2. **ME2 — DBR tooling (first boar slice implemented):** safe DBR cloning, health/defense + physical-base-damage scaling and staged outputs; not yet compiled or in-game tested.
3. **ME3 — Vertical slice:** create a working **Veteran Boar** and a spawn pool modification; compile/test in Grim Dawn.
4. **ME4 — Tier expansion:** introduce Elite and Ascended to suitable existing families with validated ability changes.
5. **ME5 — Apex prototype:** rare encounter, distinctive visuals and rewards; test rarity/performance.
6. **ME6 — Scale-up:** generalize to additional monster families without hardcoded per-creature generators.

**Next immediate step:** Follow `debug/README.md` to generate/stage three Veteran Boar DBRs, build the Custom Game with Grim Dawn Asset Manager, and spawn the Veteran Boar via the console. Confirm it renders, moves, attacks, takes hits and behaves at the intended scale. Only then modify a narrowly scoped spawn pool for ME3.

For the earlier path/hierarchy note, see [PROJECT_NOTES.md](PROJECT_NOTES.md).

## ME1 implementation files

- [Architecture and workflow](docs/ARCHITECTURE.md)
- [Tier settings](config/tiers.json)
- [Boar family mapping](config/families/boar.json)
- [Read-only config validator](scripts/validate_config.py)
- [Read-only prototype preview](scripts/preview_variants.py)

Run `python scripts/validate_config.py` to validate the checked-in reference mappings.

## ME2: generate the first Veteran Boar (staging only)

```powershell
python scripts/validate_config.py
python -m unittest discover -s tests -v
python scripts/generate_variants.py
python scripts/generate_variants.py --write
```

The generated DBRs are staged under `generated/MonsterExpansion/database/records/`, excluded from Git. **They are not installed, spawned or compiled into Grim Dawn yet.** Current size is visually +10%; melee reach/hitbox changes and green color are not implemented until investigated and tested. The +10% damage target presently scales only one physical-base-damage passive, not all outgoing damage. More details: [ME2 architecture](docs/ARCHITECTURE.md).

## First playable console-spawn test (pre-ME3)

See [debug test instructions](debug/README.md). After generating the Veteran Boar, run:

    python scripts/prepare_console_test.py --stage

Then build the selected Ben_MonsterExpansion mod in Asset Manager and load a Custom Game. The manual console command is:

    game.Spawn "records/creatures/enemies/monsterexpansion/boar_veteran_01.dbr"

Not a clickable UI; spawning occurs near the player, not 256 pixels ahead. No normal spawn pools are edited.


## Project handoff — current checkpoint (October 18, 2026)

This section is a durable handoff for continuing work across ChatGPT conversations. **Do not mistake committed tooling for a proven playable mod.**

### Verified repository work

| Area | Current state | Evidence / entry point |
| --- | --- | --- |
| ME1 design | Implemented nine-tier order, provisional colors/multipliers, boar mapping and read-only validation/preview tools | `config/tiers.json`, `config/families/boar.json`, `scripts/validate_config.py`, `scripts/preview_variants.py` |
| ME2 first variant | Python generator and tests committed. Clones one boar monster DBR plus a bio and physical-damage skill into staged output; no vanilla records edited | `scripts/generate_variants.py`, `tests/` |
| Veteran Boar behavior | Configured +30% health, +8% defensive ability, +10% physical passive base damage and +10% model scale; these are narrow generated-data targets, **not in-game measurements** | ME2 source and tests |
| Debug preparation | Isolated helper committed to inspect/stage exactly three generated records into the Asset Manager mod source after explicit `--stage`; dry-run by default | `scripts/prepare_console_test.py`, `debug/README.md` |
| In-game test | Not yet verified: Asset Manager compilation, Custom Game loading, console spawning, hit registration, size and positioning | Await user test results |
| Natural spawning | Not implemented for Veteran; vanilla pool/proxy references were researched but have not been modified | `ReferenceFiles/proxies/` |
| Tier visuals and combat footprint | Nine color identities agreed; no custom glow/HP bar/nameplate visuals. Scale field is modified for Veteran, but collision and melee reach are not proven | Configuration and design notes |

### Immediate order of work

1. **Pre-ME3 / first playable debug test:** Pull latest `main` locally. Follow [debug/README.md](debug/README.md): validate and test, generate with `--write`, inspect/stage with `prepare_console_test.py --stage`, compile only the selected custom mod with Asset Manager, select the Custom Game and try `game.Spawn "records/creatures/enemies/monsterexpansion/boar_veteran_01.dbr"`. Compare against a vanilla Common Boar. Record any build errors and in-game findings. Never overwrite the base game or copy the entire extracted reference library into the mod.
2. **ME3 / natural spawning:** Once the direct spawn works, copy the smallest relevant boar pool/proxy path into mod sources, add a controlled low-frequency Veteran Boar entry and test natural appearance. Preserve vanilla pool behavior and level restrictions as far as possible; tune weights after observation.
3. **Debug tool evolution:** Desired eventual *in-game* on-demand GUI opened via hotkey, with tier/family selection (start with a boar), and a spawn action targeting roughly **256 pixels in front of the player along the facing direction**, subject to Grim Dawn's actual coordinate and scripting capabilities. **This is a request/design, not an implemented GUI.** Keep it modular and debug-only, separate from normal spawns. The current console method spawns at/near the player instead.
4. **ME4 / tiers and presentation:** Prototype Elite above Champion and Ascended above Hero. Add visually readable tier colors/auras/FX, modest family-relative size increases and compatible abilities or usage-frequency changes. Test whether name/HP-bar color can be customized; do not depend on unsupported engine enums.
5. **ME5 / Apex:** Design very rare Apex threats with distinct identity, encounter controls and appropriate rewards. Preserve vanilla Boss and Nemesis significance.
6. **ME6 / scale-up:** Expand reusable data-driven family mappings/generation, spawn rarity/weights, difficulty and level gating, stat progression, ability behavior and loot across monster families after the boar slice is validated.

### Accepted design decisions to preserve

- **Tier order:** Common → Veteran → Champion → Elite → Hero → Ascended → Boss → Nemesis → Apex. The **new** gameplay tiers are Veteran, Elite, Ascended and Apex; vanilla classifications remain unchanged.
- Each tier should become more threatening through a mix of stats, attack behavior, ability selection/frequency and rarity; **new tiers should be physically larger relative to their appropriate parent**. Align hitbox, melee reach and FX placement with visible size when engine records support it; don't enlarge just the mesh and assume the combat footprint follows.
- Tier color targets are detailed in the table above. Distinct in-world FX are the primary reliable target; health-bar/nameplate colors need independent feasibility testing.
- Spawning is intended to be data-driven using the game's actual proxy/pool DBRs, *not* random edits to engine binaries. Existing boar references reveal Common/Champion/Hero pool entries, level restrictions and weighted selection; no global spawn probability has been agreed.
- No bulk monster generation until compilation and in-game behavior are proven for a single boar.
- Treat `ReferenceFiles/` as read-only extracted examples, not mod build input. Generated files and staging outputs remain isolated; preserve original game data.

### Continuation checklist

- [x] Nine-tier specification and family/config scaffolding
- [x] Safe first Veteran Boar DBR generator and unit tests committed
- [x] Console-test preparation script and instructions committed
- [ ] Local generation and staging confirmed
- [ ] Asset Manager build succeeds for custom mod
- [ ] Direct console spawn works in a new Custom Game
- [ ] Veteran stats, scale, collision, pathing and melee reach checked in-game
- [ ] Narrow Veteran Boar natural spawn-pool integration
- [ ] Visible Veteran green effect and further tier prototypes
- [ ] Investigate/debug hotkey GUI and exact forward spawning
- [ ] Expand generator, abilities, rarity/loot and additional families

**Handoff note:** When resuming, first inspect latest `main`, especially this README, `debug/README.md` and the generation/staging scripts. Ask for the *results* of the first local in-game spawn test, not for earlier architecture decisions already documented here.
