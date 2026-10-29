# Grim Dawn — Ben MonsterExpansion

**Current project handoff — October 27, 2026 | Working branch: `dev`**

A data-driven **Grim Dawn + Ashes of Malmouth + Forgotten Gods** custom-game mod.
The goal is to make an otherwise familiar playthrough **denser, longer, more varied
and more exciting**: distinctive tiers of stronger enemies, eventually with
their own combat mechanics; slightly enhanced mastery skills and pets; and
more flexible character progression. **Preserve the original monsters,
encounters, loot and game feel rather than replacing the campaign or making
everything wildly overpowered.**

> **Start here for future chats/Codex.** This README is the authoritative
> *high-level direction and status summary*. Check the current JSON and
> generators before editing, and use the linked technical docs for exact DBR
> fields, tests and limitations. **Make all edits/commits to `dev`**, never
> `main` unless explicitly requested. The [previous long-form README is
> archived](docs/README_HISTORY_2026-10-27.md).

## 1. Vision and design decisions

- Build **new enemy variants**, not engine-level monster classifications:
  **Common → Veteran → Champion → Elite → Hero → Ascended → Boss →
  Nemesis → Apex**. Veteran, Elite and Ascended are implemented;
  **Apex remains an unimplemented concept**.
- Let variants retain their *exact original parent*, skills, class,
  eligibility, faction/role and recognizable silhouette. Increase their
  relative stats, physical model size, visual identity and eventual **combat
  behaviour**. Don't indiscriminately rewrite all monsters or scripted bosses.
- **Ascended on-hit retaliation (TM2) is now configured for 135/137**
  custom variants, in addition to existing low-health rage. Eleven
  curated types include Aether, Poison/Acid, Fire, Cold, Lightning, Chaos,
  Vitality, Physical, Pierce, Bleeding and mixed Elemental.
  The 10% chance is **per qualifying hit**, with an 8s cooldown, not a
  10% random spawn chance. **No in-game test or Asset Manager build yet.**
  **AI1 smart enemy prototype is also configured** for one Ascended boar and
  one Ascended Gazer, with original controllers cloned and only conservative
  pursuit/ally-response/reposition changes. Local tests/build still pending.
  Capped reinforcement summoning remains a future prototype.
- Most upgrades should feel **noticeably better, not absurdly overpowered**:
  moderate damage, radius, cooldown and duration adjustments; retain native
  per-rank curves. The mod is also used for an **Occultist + Nightblade
  (Witch Hunter)** playthrough, with previous Occultist/Arcanist upgrades.
- **Shelved:** random 20% Veteran rage. **Deferred:** +10–15% more natural
  Champions or Heroes until observed normal encounter frequency warrants it.
  Keep vanilla Hero monsters independent of **custom Ascended**.
- Use **config-driven, independently reversible** changes. Read actual DBRs
  and native templates first. Add mechanics through existing supported game
  skills where possible, not invented fields, patched binaries or new AI.

## 2. Enemy tiers and natural encounters

| Tier | Origin / parent | Current catalog | Relative health | Physical base-damage passive* | Defensive ability | Model scale | Visual identity |
| --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| Veteran | Custom from Common | **148** | 1.30× | 1.10× | 1.08× | 1.10× | Green glow |
| Elite | Custom from Champion | **124** | 1.30× | 1.18× | 1.12× | 1.10× | Amber / golden glow |
| Ascended | Custom from Hero | **137** | 1.40× | 1.22× | 1.15× | 1.15× | Violet / purple glow |
| Apex | Proposed from Nemesis | **Not implemented** | 1.50× proposed | 1.25× proposed | 1.20× proposed | 1.20× proposed | Crimson/pink concept |

*The generator scales an existing **physical base-damage skill**, not
necessarily the monster's final total damage. Each multiplier is applied
to that variant's **own exact parent**, not cumulatively to other custom
tiers. These are not new `monsterClassification` values. Original
Common, Champion, Hero, Boss and Nemesis types remain present.

**Current natural selection mechanics:**

| Eligible original parent selection | Stays vanilla | Custom replacement | Current scope |
| --- | ---: | ---: | --- |
| Common | 80% | **20% Veteran** | Reviewed regular pool entries |
| Champion | 67% | **33% Elite** | Reviewed Champion entries |
| Hero | 67% | **33% Ascended** | Reviewed Hero entries with finite-quota safeguards |
| Nemesis | 100% | Apex idea: 10% someday | **Not implemented** |

- **409 configured custom variants**, using **377 merged pool overrides**
  at the previous catalog checkpoint. Elite coverage: 382 eligible selections
  in 255 pools; Ascended: 241 selections in 63 pools. These counts are
  catalog snapshots, not a claim of complete map coverage.
- `config/master.json`: **2× regular monster pack count** through
  `spawnMinEquation` / `spawnMaxEquation`; the original Champion-group
  chance and Champion count equations are **unchanged**. This can explain
  more naturally encountered Veterans; it does not directly multiply
  Champion/Hero spawns. Existing encounters receive more ordinary enemies,
  not extra map placements.
- `scripts/natural_spawns.py` splits **existing source weights**
  conditionally; it does not upgrade creatures after they spawn.
  Common selections and Champion/Hero selections use separate groups.
  Ascended preserves finite Hero quotas where demonstrably safe; special,
  forced, scripted or unsupported pools are intentionally excluded.
- Variant XP inputs target approximately **+30% Veteran**, **+30% Elite**,
  **+40% Ascended** relative to their parents. Actual XP depends on native
  XP formulas, level, difficulty and rounding. Original loot, enemy XP
  eligibility and global reward formulas are not intentionally changed.
- The existing **discovery scanners and reviewed family JSON catalogs** are
  reusable. To add an ability to already-enabled Elites or Ascended, **do
  not rescan their parent monsters**; extend the shared generator/config.
  An optional new scan is for finding *new* supported families/pools.

### Implemented low-health rage

The single **Elite boar** rage prototype was visibly confirmed by the
user in-game: red Last Stand-like streaks appeared when the enemy was
almost dead. That same ability is now **configured for all compatible
custom Elites and custom Ascended** (not original vanilla Heroes).

| Setting | Elite | Ascended |
| --- | ---: | ---: |
| Activation threshold | Below 30% HP | Below 30% HP |
| Duration | 12 seconds | 12 seconds |
| Cooldown | 180 seconds | 180 seconds |
| Total-damage modifier | +15% | +15% |
| Run-speed modifier | +10% | +10% |
| Visual FX | Red Dranghoul Last Stand particle | Same |

`config/tiers.json` controls `prototype.low_health_rage` separately
for Elite and Ascended; both are currently `enabled=true` with
`target_mode="all"`. The generator adds a **new native
`Skill_PassiveOnLifeBuffSelf`** to a free ordinary skill slot, preserves
the tier's cosmetic glow and inherited attacks, **skips** actors that
already have a native low-health skill, and does not overwrite occupied
slots. No Dranghoul-specific roar/sound or extra absorption is copied.

**Important status:** The **one Elite boar** was tested successfully,
not the full 124+137 rollout. The bulk config/generator is committed;
regenerate/build and test representative families. The generated
manifest reports `rage_coverage.elite` and `rage_coverage.ascended`,
including attachment/skipped counts. [Technical scope and tests](docs/TIER_RAGE.md).

### Ascended elemental retaliation — TM2 (configured, not tested)

The generator now supports **11 themed on-hit burst counterattacks**
for **135 of 137** custom Ascended variants: the original 36 mappings
plus 99 additional audited Hero archetypes. **Two Cave Prawns
(`prawncave_h02` and `prawncave_h03`) are deliberately excluded**:
they already inherit native `prawn_poisonnova_onhit01`, which remains
unchanged. Exact individual Hero records determine damage type, not
creature species alone. New profiles include Vitality, Physical
shockwave, Pierce, Bleeding and mixed Elemental (Fire/Cold/Lightning).
Each compatible mapped Ascended receives **one** native
`Skill_OnHitAttackRadius` clone, with **10% proc per qualifying hit**,
**8-second cooldown**, **3 m radius**, matching native element FX and
rank-scaled damage. The original Hero stays unchanged; native on-hit passives
and occupied skills are preserved, so **135 mapped does not guarantee 135
attached**. The two Cave Prawns retain their native on-hit skill. Rage remains
independent, and **its 30%-HP trigger has no activation chance**.

Configuration: `config/tiers.json` ->
`ascended.prototype.elemental_retaliation`. Generator manifest:
`retaliation_coverage.ascended` (mapped, attached, native-onhit skip,
no-free-slot skip, unmapped and elemental counts). **The configuration/code
is committed to `dev`, but is not yet generated/compiled or confirmed
in-game.** [TM2 setup and exact test steps](docs/ASCENDED_ELEMENTAL_RETALIATION.md).

### Ascended smarter AI — AI1a (two-enemy prototype)

Two *exact* Ascended Hero sources are assigned original-controller clones:
`boar_h01` gains +10 pursuit distance and +10 allied distress response,
while `gazer_h01` gains +10 normal reposition chance and +5 random
reposition chance. Original high dodge settings, skills, retreat behaviors
and vanilla controller DBRs stay unchanged. No other Ascended, Elite,
Veteran, source Hero or boss receives an AI override.

Feature flag: `config/tiers.json` →
`ascended.prototype.smart_ai.enabled`; generated controllers:
`records/controllers/enemy/monsterexpansion/*_ai.dbr`.
Manifest: `ai_coverage.ascended`. The **support role and broader
rollout remain unimplemented** until the prototypes are tested in-game.
Focused test: `python -m unittest discover -s tests -p test_ascended_ai.py`.
**Configured on `dev`; native behavior has not been verified in game.**
[AI1 notes, staged plan and in-game checklist](docs/ASCENDED_AI1_BEHAVIOR.md).

## 3. Player progression and game-wide quality-of-life

| Mechanic | Vanilla / expansion baseline | Current mod setting |
| --- | --- | --- |
| Maximum character level | **100** with DLC | **150** |
| Skill points reaching levels 2–50 | 3 per level | **3** (to level **60**) |
| Skill points reaching levels 51–90 | 2 per level | **2** (levels **61–100**) |
| Skill points reaching levels 91+ | 1 per level | **1** (levels **101–150**) |
| Total skill points from level-ups at 150 | **287** if native award table extends to 150 | **307** (+20) |
| Attribute points per character level | 1 | **2** |
| Physique / Cunning / Spirit per spent point | +8 | **+6** |
| Devotion points per restored shrine | 1 | **2** |
| Maximum Devotion points | 55 | **85** |
| Starting health / energy | 250 / 250 | **300 / 300** |
| Base run speed (player actor field) | 0.93 | **1.0695** (+15%) |
| Maximum movement-speed bonus | 135% | **145%** |
| Camera default / max zoom-out | 36 / 48 | **36 / 48** (kept/reverted) |

Skill-point **exact bands**: levels **2–60 = 3**, **61–100 = 2**,
**101–150 = 1**; **307 awarded through level 150**, excluding quest
rewards. The vanilla award table at its original level-100 cap
awards **237** level-up skill points. Mastery bar costs, native XP-to-level
equation, health/energy gains per level and quest point counts stay
unchanged. Current game/world monster level limits and loot progression
beyond level 100 **have not been extended** and need a separate audit.

Configs are `config/player_stats.json`,
`config/player_movement.json`, and `config/player_basics.json`.
Devotion edits apply to **60 distinct effective rewarding shrine DBRs**
from the provided base/AoM/FG references. Existing quest, shrine cost,
loot and difficulty conditions are preserved. The level cap is composed
into both male/female player actors as well as `playerlevels.dbr`.
These changes are DBR generation/build settings, **not live sliders**.

## 4. Masteries, abilities and pets

`config/player_skills.json` contains reversible, **rank-aware** overrides,
using the effective game DBR fields rather than flattening rank curves.
It covers Nightblade, Occultist, Arcanist, targeted Demolitionist skills,
and shared pets (not a universal buff to every mastery). All **13 exclusive-skill flags found in the
uploaded masteries** were cleared for the intended stacking behaviour;
actual in-game interactions still need testing.

### Nightblade

- Selected main, modifier, passive and dual-wield skills receive generally
  **+15%** improvements to their chosen damage/defensive curves;
  Blade Burst gains +15% Cold/Frostburn, +20% radius and shorter cooldown
  **1.8 → 1.5 s**.
- **Phantasmal Blades**: **4 / 5 / 6 / 7 blades** across its four rank
  bands (one more than original), **+25% Pierce/Bleeding**, projectile
  range **16 → 20 m**, visible projectile scale **0.75 → 0.90**.
- **Shadow Strike**: selected damage +15%, cooldown **3.5 → 2.975 s**;
  **Ring of Steel**, **Veil of Shadow** and **Blade Trap** get about
  +20% area/radius (Blade Trap also +15% effect duration).
- **Pneumatic Burst**: duration **60 → 72 s**, enhanced heal/regen;
  **Blade Spirits**: cap/burst **2** at ranks 1–15, **4** at 16–23,
  **5** at 24–26, plus +15% to selected attack damage fields.
  Blade Spirits are already persistent/invulnerable.

### New Nightblade skeleton skill line

The Necromancer-style line has been **attached to Nightblade's UI**
in a dedicated bottom horizontal row:
**Raise Skeletons → Undead Legion → Will of the Crypt**.
It uses copied mastery skill/button records; original Necromancer
mastery remains separately available.

- Raise Skeletons summons **4** initially (base summon/cap 3 → 4).
- Undead Legion retains vanilla additive capacity: **9 skeletons**
  at its ordinary **12/12 cap**, or **11** at overcapped **22/12**
  (excluding additional equipment bonuses). Will of the Crypt
  increases skeleton capabilities, **not** summon count.
- Shared skeleton scaling gets **+20% relative HP** and **+15%
  relative total damage**, retaining all 26 native ranks. Because the
  summoned skeletons use a shared native pet-scaling record, this also
  improves the **original Necromancer skeletons**.
- User has confirmed the initial Nightblade skeleton summon/button
  works in-game; the complete three-skill row, revised count and
  all modifier effects still need broader runtime confirmation.

### Occultist

- **Familiar and Hellhound** now each start with **2 maximum summons
  at ranks 1–7**, increase to **3 at ranks 8–14**, and **4 at ranks
  15–26** (normal skill cap 16, overcap 26). Each pet gets **+20%
  relative intrinsic HP** compared with the prior modded actor scaling.
  One pet is summoned per cast; native cooldowns are unchanged.
- **Sigil of Consumption**: +15% **radius at every rank**, duration
  **6 → 7.2 s** (+20%), cooldown **3 → 2.7 s** (−10%);
  original damage/cost curve unchanged. **Curse of Frailty**,
  Vulnerability, Bloody Pox, Dreeg's Evil Eye and related modifiers
  have modest targeted buffs (commonly +5–10%).
- **Doom Bolt** and selected pet/passive skills enhanced; Blood of
  Dreeg is a sustained toggle. Other pet abilities not explicitly
  configured remain vanilla.

### Demolitionist (first pass — configured, not yet tested)

- **Canister Bomb** gains **+10% main explosion radius** and small
  *rank-gated* fragment increases: unchanged at ranks 1–7; +1 min/max
  fragments at ranks 8–17; +2 at ranks 18–22. Native **4–6** fragments
  at rank 1 become **11–13** at rank 22 (original rank-22 **9–11**).
  **Improved Casing** increases each original explosion-radius rank by 10%.
- **Stun Jacks** explosion radius rises 10%; **Full Spread** adds one
  additional projectile from ranks 14–22 (6 at rank 22, from 5).
- **Explosive Strike** and **Grenado** get +10% radius;
  **Flashbang** gets +10% area radius; **Blackwater Cocktail** gains
  +12% radius and +10% duration at every rank.
- **Mortar Trap**: **+10% base shell explosion radius** and
  **+10% Heavy Ordnance radius curve**; lifetime **24 → 27.6 s**.
  Active mortar cap is now **1** at ranks 1–11, **2** at 12–17,
  **3** at 18–23 and **4** at 24–26 (up from a vanilla maximum of 3).
- **Thermite Mine**: **+10% attack radius** (2 → 2.2 m),
  lifetime **18 → 20.7 s**; launches **3 per cast** at ranks 1–15
  and **4 per cast** at 16–26. The total cap rises from **6**
  to **8** at ranks 16–22 and **9** at ranks 23–26.
- No Demolitionist raw damage curves, cooldowns, or defensive skills
  were changed. All **13 changed records** retain independent rollback;
  tests are committed but not run, and the pass has not been generated,
  F7-built or checked in-game.
- **New Demolitionist skeleton line:** cloned Necromancer
  **Raise Skeletons → Undead Legion → Will of the Crypt** in a dedicated
  bottom horizontal skill-tree row (slots 37–39). As with Nightblade,
  Raise Skeletons starts at **4**, reaches **9** with Undead Legion 12,
  and **11** at overcap rank 22. The original 33 Demolitionist UI
  buttons shift upward without replacing any existing skills.
  The two classes' skeleton attachment configs and rollback are independent.
  This new Demolitionist UI has **not** been verified in-game.

### Arcanist

- **Aether Ray**: beam range **16 → 22** and thickness **1.25 → 2**;
  Aether Ray, Disintegration, Devastation and selected offensive
  skills get rank-scaled damage boosts.
- **Devastation**: duration **5 → 8 s**, larger area and **2 → 3**
  projectiles per launch. **Mirror** becomes a moderated sustained
  toggle; Maiven's Sphere and selected buffs are enhanced.
- Targeted modest buffs (+5–10% to chosen fields) include Panetti's
  Replicating Missile, Trozan's Sky Shard, Callidor's Tempest,
  Olexra's Flash Freeze, Inner Focus, Arcane Will and Iskandra's
  Elemental Exchange support skills. Skill ranks and original
  other damage types are otherwise preserved unless explicitly
  configured.

These mastery changes are intended to be **playable rather than
overpowered**. Details, actual field names and untouched skills:
[Nightblade](docs/NIGHTBLADE_BALANCE.md),
[Nightblade skeleton layout](docs/NIGHTBLADE_SKELETONS_BUILD.md),
[Occultist/Arcanist and pet tuning](docs/PLAYER_SKILLS.md),
[Demolitionist first-pass balance](docs/DEMOLITIONIST_BALANCE.md),
[Demolitionist deployables](docs/DEMOLITIONIST_DEPLOYABLES.md),
[Demolitionist skeleton line](docs/DEMOLITIONIST_SKELETONS_BUILD.md).

## 5. Verified in game vs configured only

**Observed by the user in-game:**
- A **Veteran boar** directly spawned with green glow and increased
  health; the vanilla boar proxy also produced the Veteran variant.
- A **Veteran zombie** appeared naturally in an early Lower Crossing
  area; its `Walking Dead (Veteran)` display name and original
  faction subtitle were observed.
- Nightblade's initial **Raise Skeletons** button/summon worked.
- One **Elite boar** exhibited the red Last Stand-style rage effect
  while at low HP.

**Implemented in repo but not yet comprehensively verified in-game:**
full natural Elite/Ascended frequency, all tier-wide rage
attachments, new Ascended elemental retaliation (TM2), level-101–150 progression and rewards, 2 Devotion
points/shrine and the 85 cap, mastery balance and shared pet changes,
the complete Nightblade skeleton UI/cap, all 2× pack behaviours,
all character speed/stats overrides, multi-family gameplay and
multiplayer. Earlier focused Python tests passed for certain
checkpoints; **do not describe newly committed tests as executed
unless actually run**. Config/commit success alone does not prove
Asset Manager compilation or game behaviour.

## 6. Next priorities and ideas

1. **Rebuild and test configured TM2** on at least one Ascended from
   each of the eleven burst profiles. Verify visuals, damage, chance and
   cooldown independently from rage. Confirm two excluded Cave Prawns
   retain their native on-hit Poison Nova. Review manifest coverage and
   skip reasons before claiming 135 actual new attachments.
   **Future idea:** capped reinforcements, ideally themed to the same
   family. Low-HP-gated summons remain unproven; prevent recursive
   summons, repeated loot/XP and FX spam.
2. **Rebuild and verify** the full Elite/Ascended rage rollout across
   several species. Use generated `manifest.json` `rage_coverage`
   for per-tier assignment/exclusion counts.
3. **Evaluate** Champion/Hero frequency from actual gameplay.
   Proposed increases of +10–15% *relative* remain deferred:
   `championChance` changes Champion-group frequency, while
   Heroes use weights **within that same group**. More regular
   monsters from the current 2× setting do not by themselves
   double Champions.
4. Audit **level 101–150** world scaling, XP availability and loot.
   Consider further distinct high-tier powers, restrained rewards,
   names/FX, and eventually **Apex (Nemesis-derived)** only after
   investigating its distinct spawn rules. A debug spawn GUI was
   discussed but **is not implemented**; console spawning exists.
5. **Do not implement Veteran 20%-chance rage** without an explicit
   change in direction.

The researched DBR mechanics and proposed phases live in
[**Tier Encounter Mechanics Ideas — Codex plan**](docs/TIER_ENCOUNTER_MECHANICS_IDEAS.md).
**TM1 (rage) and TM2 (curated elemental on-hit retaliations) are configured** from that plan; TM2 has no native in-game verification yet. Other mechanics remain proposals.

## 7. Architecture, configuration and working rules

| Location | Responsibility |
| --- | --- |
| `config/tiers.json` | Tier stat, size, glow, XP, conversion shares, rage and elemental proc settings |
| `config/families/*.json` | Reviewed actual parents, custom variants, pool promotions and enabled selection |
| `config/master.json` | 2× regular pack-size multiplier |
| `config/player_stats.json` | Level cap, skill/attribute points, devotion |
| `config/player_basics.json`, `config/player_movement.json` | Base player health/energy, speed, camera |
| `config/player_skills.json`, `config/nightblade_skeletons.json` | Mastery balance and Nightblade skeleton tree |
| `scripts/discover_veterans.py`, `discover_elites.py`, `discover_ascended.py` | Read-only-by-default family/pool discovery; optional disabled draft configs |
| `scripts/generate_variants.py`, `scripts/creature_names.py` | Compose variant DBRs and auto-resolve custom tier labels from original/GDX1/GDX2 English creature tags |
| `scripts/natural_spawns.py`, `scripts/global_spawns.py` | Safe merged pool weights; global **regular-only** pack size |
| `scripts/validate_config.py`, `scripts/prepare_console_test.py` | Input/reference checks and guarded staging |
| `ReferenceFiles/` | **Read-only** extracted game DBRs and templates; never edit/copy wholesale |

**Reference priority:** `ReferenceFiles/gdx2/database/records` >
`ReferenceFiles/gdx1/database/records` >
`ReferenceFiles/original/database/records` (base). Outputs use original logical
`records/...` paths in the custom mod's `database/`.
The source **JSON files are build instructions**, not game-time
configuration. Do not change the original Grim Dawn archive files.

**Development conventions:** Work on `dev` and push there,
**not `main`**. Preserve existing content and avoid broad unrelated
refactoring. Prefer deterministic config, correct native template
fields, exact parent/reference provenance, free skill slots,
per-feature enable flags, safe rollback and minimal tests.
Do **not** run lengthy full test suites unless explicitly asked.
Do not overwrite active family JSON with disabled scanner drafts,
and never claim runtime success from static inspection alone.

## 8. Local build, install and direct tests

From the local custom mod repository under
`Working/mods/Ben_MonsterExpansion`:

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Then select the mod in **Grim Dawn Asset Manager**, build with
**F7**, install the rebuilt `.arz` and preserve/install the
`resources/Text_EN.arc` needed for automatic Veteran/Elite/Ascended labels.
Restart the **Custom Game**. Optional focused tests can be run
separately; no implicit new-game testing occurs on GitHub.
**Back up saves** before testing level cap/character progression.

Useful console spawns:

```text
game.Spawn "records/creatures/enemies/monsterexpansion/boar_veteran_01.dbr"
game.Spawn "records/creatures/enemies/monsterexpansion/zombie_veteran_starter_01.dbr"
game.Spawn "records/creatures/enemies/monsterexpansion/discovered_elites_elite_75bbb288ac65b5d4.dbr"
game.Spawn "records/creatures/enemies/monsterexpansion/discovered_ascended_ascended_b93dca01452e6643.dbr"
```

**Important:** When disabling a feature, regenerate **and replace
staged outputs**; merely removing an entry or omitting
`--include-spawns` will not remove previously compiled DBRs.
Stale, unused support files may remain in the staging directory.
Review the relevant rollback docs and perform clean rebuilds as needed.

## 9. Technical docs / further reference

- [Tier rage: Elite and Ascended, scope/rollback](docs/TIER_RAGE.md)
- [AI1 Ascended behavior prototypes and later rollout notes](docs/ASCENDED_AI1_BEHAVIOR.md)
- [Tier combat ability ideas and feasibility for Codex](docs/TIER_ENCOUNTER_MECHANICS_IDEAS.md)
- [Monster families and generation pipeline](docs/DATA_DRIVEN_FAMILIES.md)
- [Elite discovery, selection and test](docs/ELITES.md);
  [Ascended quotas and selection](docs/ASCENDED.md);
  [Veteran discovery](docs/VETERAN_DISCOVERY.md)
- [Variant XP rewards](docs/ENEMY_XP.md)
- [Player level 150 and skill-point progression](docs/PLAYER_LEVEL_CAP.md);
  [Devotion rewards/cap](docs/DEVOTION.md)
- [Player starting stats/camera](docs/PLAYER_BASICS.md);
  [movement](docs/PLAYER_MOVEMENT.md)
- [Nightblade balance](docs/NIGHTBLADE_BALANCE.md);
  [Nightblade skeleton attachment](docs/NIGHTBLADE_SKELETONS_BUILD.md);
  [Occultist/Arcanist/pet skills](docs/PLAYER_SKILLS.md)
- [Build and install](docs/BUILD_AND_TEST.md);
  [custom tier names](docs/ENEMY_NAMES.md);
  [console debug commands](debug/README.md)
- [Historical long-form README (archived)](docs/README_HISTORY_2026-10-27.md)

**Handoff rule:** For any new idea (especially the next Ascended
ability), **read this overview, inspect the actual current configs/
generator/DBRs, establish feasibility, then implement the smallest
reversible change on `dev` and document what was truly tested**.
