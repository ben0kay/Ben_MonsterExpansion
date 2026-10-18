# Grim Dawn — Ben MonsterExpansion

An AI-assisted Grim Dawn mod project to expand the existing monster hierarchy, beginning with the base game's monsters and spawn pools. The goal is **recognizable tier visuals, progressively stronger stats, and increasingly interesting combat behavior**, while preserving the original game feel.

> **Status (October 18, 2026):** ME1 complete; ME2 Veteran Boar compiled/spawned successfully, 92 vs 71 HP verified, green glow live-tested and approved by user. ME3 scoped natural-spawn implementation is ready for its first in-game test: weight 25 vs Common total 100 (20% of regular selections), unchanged Champion/Hero rules and pack counts. Target 2–3 Veterans per Champion (2.5 midpoint) remains unmeasured. Debug GUI and later tiers remain pending.

> **Current instructions:** [ME3 natural spawn build/test and rollback](docs/ME3_NATURAL_SPAWNS.md). Use `--include-spawns` on generation AND staging; expect seven DBRs. Tier glow/spawn defaults live in `config/tiers.json`. Earlier no-aura/no-spawn/three-record descriptions below are historical; this checkpoint supersedes them.

## Project location and workflow

- **Repository:** [ben0kay/Ben_MonsterExpansion](https://github.com/ben0kay/Ben_MonsterExpansion)
- **Branch:** `main`
- **Local Asset Manager working directory:** `M:\BACKUPS\D_Drive\2025_11_01_D_Drive_Backup_Manual\My Media Content\Modding\Grim Dawn\Working\` (confirmed). Build uses sibling `Build\`; repository is `Working\mods\Ben_MonsterExpansion\`.
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
2. **ME2 — DBR tooling and Veteran Boar direct spawn (working):** safe DBR cloning/staging; successfully compiled and spawned in a Custom Game; +30% HP validated against Common Boar (92 vs 71). Other stats/scale only configured, not measured.
3. **ME3 — Natural spawn-pool vertical slice (implemented, runtime pending):** one mod pool override adds Veteran to regular selections; weight 25 vs Common 100. Preserve Champion/Hero behavior; verify natural frequency, level behavior and combat. See `docs/ME3_NATURAL_SPAWNS.md`.
4. **ME4 — Tier expansion:** introduce Elite and Ascended to suitable existing families with validated ability changes.
5. **ME5 — Apex prototype:** rare encounter, distinctive visuals and rewards; test rarity/performance.
6. **ME6 — Scale-up:** generalize to additional monster families without hardcoded per-creature generators.

**Next immediate step / Codex handoff:** First research a **subtle cosmetic green Veteran aura**, proving the monster-side attachment mechanism from real vanilla DBRs and validating effect asset availability; do not change generators until the mechanism is established. Independently continue ME3 scoped spawn-pool research; test movement, collision, melee, scaling and damage. See the live-test and blockers section below.

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

The generated DBRs are staged under `generated/MonsterExpansion/database/records/`, excluded from Git. **The generated output has since been staged locally, compiled into the mod and spawned successfully in-game.** Current size is visually +10%; melee reach/hitbox changes and green color are not implemented until investigated and tested. The +10% damage target presently scales only one physical-base-damage passive, not all outgoing damage. More details: [ME2 architecture](docs/ARCHITECTURE.md).



**Build/install reference:** [Windows Asset Manager build and in-game testing guide](docs/BUILD_AND_TEST.md).

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
| Veteran Boar behavior | Configured +30% health, +8% defensive ability, +10% physical passive base damage and +10% model scale; these are narrow generated-data targets, **HP verified in-game (92 Veteran vs 71 Common); remaining stats not measured** | ME2 source and tests |
| Debug preparation | Isolated helper committed to inspect/stage exactly three generated records into the Asset Manager mod source after explicit `--stage`; dry-run by default | `scripts/prepare_console_test.py`, `debug/README.md` |
| In-game test | **PASS:** Asset Manager compiled three DBRs into ~57 KB `.arz`; game recognized Custom Game; custom boar console spawn rendered, showed HP bar and took damage. **PASS:** 92 Veteran HP vs 71 vanilla at tested conditions. Not verified: other combat stats, dimensions, collision, pathing/attacks | User's in-game screenshots and test report (2026-10-18) |
| Natural spawning | Not implemented for Veteran; vanilla pool/proxy references were researched but have not been modified | `ReferenceFiles/proxies/` |
| Tier visuals and combat footprint | Nine color identities agreed; no custom glow/HP bar/nameplate visuals. Scale field is modified for Veteran, but collision and melee reach are not proven | Configuration and design notes |

### Immediate order of work

1. **Pre-ME3 / first playable debug test — PASSED:** In-game command spawned custom Veteran Boar successfully. At tested conditions: 92 HP versus 71 vanilla. Preserve this working baseline. Rebuild steps are in [docs/BUILD_AND_TEST.md](docs/BUILD_AND_TEST.md); do not touch original archives.
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
- [x] Local generation and staging confirmed by successful build
- [x] Asset Manager build succeeds for custom mod (~57 KB `.arz`)
- [x] Direct console spawn works in Custom Game; 92 Veteran HP vs 71 vanilla
- [ ] Veteran stats, scale, collision, pathing and melee reach checked in-game
- [ ] Narrow Veteran Boar natural spawn-pool integration
- [ ] Visible Veteran green effect and further tier prototypes
- [ ] Investigate/debug hotkey GUI and exact forward spawning
- [ ] Expand generator, abilities, rarity/loot and additional families

**Handoff note:** When resuming, first inspect latest `main`, especially this README, `debug/README.md` and the generation/staging scripts. The first in-game spawn test has now **passed**. Continue from the Codex investigation block below rather than repeating the same initial test.

## Codex implementation handoff — first live playtest and blocked cosmetic FX (October 18, 2026)

### Confirmed firsthand in-game results

- User created/selected `Ben_MonsterExpansion` in Asset Manager under the expected Working/mods directory. Restarting Asset Manager resolved initial mod-list caching.
- Asset Manager build log recorded updates to the custom boar, bio and physical damage skill DBRs and produced `Build/mods/Ben_MonsterExpansion/database/Ben_MonsterExpansion.arz` (~57 KB). No reported build errors.
- User copied the compiled mod to the actual game install, selected **Custom Game → Ben_MonsterExpansion ~ world001.map** and successfully entered the world.
- Built-in developer console command worked: `game.Spawn "records/creatures/enemies/monsterexpansion/boar_veteran_01.dbr"`.
- Custom Veteran Boar appeared with valid model and health bar; user hit it and observed HP decrease. In follow-up comparison the user confirmed **Veteran 92/92** and vanilla **Common 71/71** at the test encounter. Increase = **(92/71 - 1) × 100 = 29.58%**, consistent with the configured 1.30× health equation and integer rounding.
- Do **not** confuse the initial 71 HP observation with proof that the Veteran had 71 base HP; the two-variant comparison and user's explicit identification settle the observed 92 vs 71 reading.
- Still **unproven**: physical damage increase in combat, defensive ability change, exactly 10% apparent scale, collision and attack reach, movement/pathfinding, spawn probabilities. Do not mark these as passing just because the monster rendered.

### Immediate research task for Codex — subtle Veteran green aura, investigate BEFORE implementation

**Desired appearance:** faint muted green (`#81AF71`) body-adjacent glow, discreet at screen scale; original boar textures/silhouette retained; no dramatic flames, flying particles or excessive brightness; **purely cosmetic** (no stat buffs, hazards or aura damage). Only the custom Veteran Boar, never Common Boar. User explicitly requested investigation/confirmation *before* code or generator changes.

**Relevant evidence gathered (not a completed implementation):**

- `ReferenceFiles/creatures/enemies/boar_a01.dbr` (Common parent): normal monster template; references `deathEffect`, `gibEffect`, `lightRig`, `mesh` and existing skills, but inspection did not reveal an obvious `spawnAura`-style field. **Do not invent a new DBR field**.
- `ReferenceFiles/fx/creatures/aetheraura01_sm01.dbr`, `boneratpoisonaura01.dbr` and `boarfireaura01.dbr` are `database/templates/effect.tpl` with `Class,EffectEntity` and `effectFile,fx/particlesystems/creature/...pfx`. They prove effect records exist but **not** how to attach one permanently to the boar, nor that the underlying `.pfx` assets are present/distributable.
- Numerous `ReferenceFiles/fx/creatures/` examples include `glownature01_large.dbr`, `poisonaura02_sm.dbr`, `aetheraura01_sm01.dbr`, `boneratpoisonaura01.dbr`. The effect names alone do **not** establish their visual subtlety, compatibility or safe reuse.
- Read-only vanilla files in `ReferenceFiles/skills/nonplayerskills/`, `ReferenceFiles/nonplayerskills/` and creature monster records can help trace real persistent aura/buff skill references. Differentiate **visual FX** from **gameplay auras**: adding a skill may modify combat even if it displays an effect.
- `boar_a01.dbr` carries `scale` and `actorRadius` as separate fields. No validated collision/reach changes were made by the existing generator.

**Codex research deliverable (no implementation until this is answered):**
1. Find a *specific vanilla monster DBR → assigned skill (if relevant) → effect DBR → `.pfx` chain* that actually produces a continuously visible creature-attached effect. Record exact paths and real fields, plus whether continuous effect is guaranteed on spawn or requires cast/activation.
2. Establish a reliable **cosmetic-only** approach (or report that available DBRs cannot prove one). If a passive/buff skill is required, identify the minimal non-combat template/settings and possible AI activation, dispel/death, performance or duration issues.
3. Determine whether effect asset bytes/texture resources are available for packaging. The extracted repository primarily includes reference DBRs; `.pfx`, texture and mesh files are not necessarily included.
4. Check if effect tint/intensity/opacity is editable via proven DBR fields or actually requires Particle Editor/`.pfx` changes; do not equate `color_hex` in JSON with a runtime tint.
5. Suggest the smallest reversible single-boar test and acceptance criteria; **only after evidence** propose generator/config implementation. Preserve successful HP behavior and three-record staging safeguards. If a fourth effect/skill record is necessary, update allowlists, tests and documentation deliberately, not by bypassing safety checks.

### Other outstanding issues / sequencing for Codex

- **ME3 natural spawns:** Inspect `ReferenceFiles/proxies/pools/p_beasts_boar_n.dbr` and `ReferenceFiles/proxies/beasts_boar_n.dbr` with related level/weight fields; propose the smallest copied pool change with low Veteran frequency. Confirm whether existing proxies resolve overridden pool paths within the mod and avoid changing vanilla records.
- **Debug UX:** Current debug tool is **not a GUI**, only console spawning via `game.Spawn`. Desired eventual hotkey-opened menu with monster/tier selection and forward spawn roughly 256 screen pixels/appropriate engine world units ahead of the player's facing; research feasibility before implementation.
- **Visual scale and attack integrity:** Validate `scale` runtime impact separately from `actorRadius`, melee reach, FX position and pathing. Do not multiply all ranges universally.
- **README maintenance:** Earlier ME1/ME2 design documents sometimes describe pre-playtest states and remain historical; this section and the status/phase table above are authoritative for the live-test checkpoint. Update docs when verified, not from guesses.

### Working rule

**Research first → cite exact engine record paths/fields → propose minimal test → implement only after mechanism is established → rebuild/test in Custom Game → record results.** No speculative new template fields or mass variant generation.
