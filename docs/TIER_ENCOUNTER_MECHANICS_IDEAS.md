# MonsterExpansion — Tier Encounter Mechanics & Spawn Frequency Ideas

**Status:** RAGE (TM1) AND CURATED ASCENDED ELEMENTAL COUNTERATTACKS
(TM2) CONFIGURED/IMPLEMENTED IN GENERATOR (2026-10-27).
User visually confirmed one Elite boar low-health rage; the wider rollout
is not yet rebuilt or tested. TM2 uses six elemental on-hit profiles for
36 *individual, audited Hero archetypes*, at 15% on-hit activation chance,
8s cooldown and 3m radius, with no in-game build/test yet. Reinforcements
(TM3) and spawn-frequency changes (TM4/5) remain proposals.
See [ASCENDED_ELEMENTAL_RETALIATION.md](ASCENDED_ELEMENTAL_RETALIATION.md). Designed as a Codex
handoff for the existing **`dev`** branch of `ben0kay/Ben_MonsterExpansion`.
Never write to `main`. Follow the existing README and repository generators;
keep tests focused and avoid lengthy full-suite runs unless requested.

## Vision

Make the custom **Veteran (Common-derived), Elite (Champion-derived), and
Ascended (Hero-derived)** enemies feel like distinct threats, not merely
higher-HP variants. Some should become enraged at low health; some may summon
reinforcements; others may retaliate with elemental attacks. **Veteran rage is
shelved for now**; Champion/Hero spawn-frequency increases are **deferred**
until in-game Elite/Ascended natural frequency has been assessed. Candidate
future changes are +10–15% relative Champion and +10–15% Hero frequency. Preserve the existing 20% Veteran
conditional conversion and 33% Elite/Ascended conditional conversions, subject
to current pool safeguards. This should increase Elite/Ascended encounters
organically, without independently jacking up their conversion fractions.

Current tier definitions: `config/tiers.json`. Enabled snapshots: 148 Veterans,
124 Elites, 137 Ascended. Existing merged-pool generator:
`scripts/natural_spawns.py`. Actual numbers/coverage may evolve.

**Definitions:**
- “+15% spawn rate” defaults to a **relative multiplier**, not +15
  percentage points (e.g. 15% chance → **17.25%**, not 30%). Confirm during
  balancing if a different meaning is desired.
- Veteran rage probability was **explicitly scrapped/deferred** by the user.
  Do not implement a 20% chance or an 80/20 Veteran split. Only revisit on a
  new request.
- “Always enrages” means a compatible Elite or custom Ascended
  is assigned this passive and should activate below the threshold
  if it survives; overkill/death can bypass it. Existing native
  low-health skills and slot exhaustion are intentional exclusions.
- New rage applies only to eligible **custom Elite and Ascended
  variants**; not vanilla Hero, Common, Champion, Veteran, quest
  Boss or Nemesis records.

## Feasibility at a glance

| Proposal | Native DBR evidence | Implementation assessment |
| --- | --- | --- |
| Elite rage below 30% HP (100% eligible) | `Skill_PassiveOnLifeBuffSelf` and `lifeMonitorPercent` | **HIGH / low–moderate**: per-tier cloned low-life skill + safe skill-slot assignment; animation/FX/duplicated skills require audit |
| Ascended rage | Same low-life template + existing aura FX | **IMPLEMENTED in generator/config** at the same 30%/12s/+15%/+10% as Elite; broad in-game compatibility still needs testing |
| Veteran rage at 20% HP, ~20% spawn chance | Low-life template has threshold but **no explicit activation-chance field** in inspected template | **ON HOLD / not authorized**: user has shelved Veteran rage; retain feasibility note only, no implementation |
| Elite calls Veteran reinforcements | `Skill_SpawnPet` with `petBurstSpawn`, `petLimit`, `spawnObjects` | **HIGH for normal summon / moderate–hard for low-HP gated summon**; faction, target, lifetime, limits, loot, XP, and recursive spawns need testing |
| Elemental counterattack when struck | `Skill_OnHitAttackRadius`, `onHitActivationChance` | **TM2 CONFIGURED** for 36 individual Ascended Hero archetypes at 15% chance/8s/3m across six elements. Build/gameplay not yet verified; other Hero elements excluded pending audit. |
| +15% Champion-group chance | `proxypool.tpl` `championChance` field | **HIGH / moderate**: selectively multiply eligible nonzero pool chances by 1.15, clamp ≤100, preserve exclusions; note that this group also contains Heroes |
| +10–15% Hero selection | `nameChampionN` includes both Champions and Heroes; weights are `weightChampionN` | **HIGH / moderate–hard**: raise **combined Hero+Ascended selection mass** relative to Champion+Elite, while preserving each Hero's original 67/33 split and group quotas |
| More living Champion/Hero counts per encounter | `championMin`, `championMax` and their count equations | **CONDITIONAL / high regression risk**: can violate bounded-Hero quota proof. **Do not** casually raise `championMax` or global champion count equations. |

### Confirmed DBR evidence (exact files / fields)

1. `ReferenceFiles/skills/nonplayerskills/passivelyactivated/dranghoul_laststand.dbr`:
   `templateName=database/templates/skill_passiveonlifebuffself.tpl`,
   `Class=Skill_PassiveOnLifeBuffSelf`, `lifeMonitorPercent=33`,
   `skillActiveDuration=20`, `skillCooldownTime=180`,
   `offensiveDamageMultModifier=25`, `damageAbsorption=25`
   (**flat field; NOT** `damageAbsorptionPercent`), activated aura
   `records/fx/skillsother/buff/dranghoul_laststand_selfloop_fx01.dbr`,
   `skillSpecialAnimationName=Roar`, and Dranghoul-specific audio.
   `ReferenceFiles/creatures/enemies/dranghoul_warrior_a01.dbr` assigns
   this skill at `skillName7` / `skillLevel7=1`. A `b01` Dranghoul
   also references it.
2. Alternative rage template:
   `ReferenceFiles/skills/nonplayerskills/passivelyactivated/chthonianwarrior_enrage.dbr`:
   `lifeMonitorPercent=18`, `skillActiveDuration=18`, `skillCooldownTime=60`,
   `characterRunSpeedModifier=20`, `damageAbsorptionPercent=25`.
   **Prefer crafting new tier-specific records by selecting safe effects from
   these references**, rather than copying all 500-point CC resistances and
   large defensive abilities from Dranghoul Last Stand.
3. `ReferenceFiles/Resources/templates/skill_passiveonlifebuffself.tpl`
   exposes `lifeMonitorPercent`, `thresholdDuration`, duration/cooldown;
   the inspected template does **not** declare a proc probability for
   threshold activation. Contrast:
   `ReferenceFiles/Resources/templates/templatebase/skill_onhit.tpl`
   explicitly declares `onHitActivationChance`.
4. `ReferenceFiles/skills/nonplayerskills/passivelyactivated/prawn_poisonnova_onhit01.dbr`:
   `Class=Skill_OnHitAttackRadius`,
   `onHitActivationChance=25`, `skillTargetRadius=3`,
   `skillCooldownTime=8`. Another on-hit reference:
   `aetherobelisk_vindictiveaether.dbr` (Aether attack, 5s cooldown).
5. `ReferenceFiles/skills/nonplayerskills/summoning/gazer_summonzombie01.dbr`:
   `Class=Skill_SpawnPet`, `petBurstSpawn=3`,
   `petLimit=6`, `skillCooldownTime=8`,
   `spawnObjects=records/creatures/enemies/zombie_a01_summon.dbr`.
   `chthonic_cultist_summonportal01.dbr`: summons a portal with
   `petLimit=1`, `spawnObjectsTimeToLive=60`, 30s cooldown.
   `skill_spawnpetmonster.tpl` and `skill_ondeathspawnactor.tpl`
   also exist. Their presence **does not prove** an arbitrary summon can
   be triggered specifically at a low-health threshold.
6. `ReferenceFiles/proxies/pools/p_beasts_boar_n.dbr`:
   `championChance=15`, `championMin=0`, `championMax=2`;
   `nameChampion1=.../boar_b01.dbr` weight 900; six
   `nameChampion2..7=.../hero/boar_hXX.dbr` weights 8 each,
   with level gates and finite `limitChampionN=1` values.
   This is a concrete example of **Heroes and Champions sharing the
   Champion pool**. Champion-group conditional Hero weight = 48/948 ≈
   5.06% **before** level gating/caps. Independently multiplying Hero
   weights by 1.15 gives 55.2/(900+55.2) ≈ 5.78%; the latter is not
   a promise of exactly +15% observed Heroes after caps and level gating.
7. `ReferenceFiles/Resources/templates/proxypool.tpl` defines
   `championChance`, `championMin`, `championMax`, and
   `nameChampionN` / `weightChampionN` / `limitChampionN` entries.
   `ReferenceFiles/proxies/proxypoolequation_01.dbr` controls
   Champion count equations, currently preserved by the mod.

External corroboration (context, not a substitute for inspecting repo):
- Official Grim Dawn modding guide:
  https://www.grimdawn.com/downloads/Grim%20Dawn%20Modding%20Guide.pdf
  (the guide distinguishes regular vs Champion pool and their counts).
- Example community mod that increases Champions/Heroes by editing
  individual spawn pools, deliberately skipping special pools:
  https://forums.crateentertainment.com/t/rel-increased-champion-spawns/35124

## Implementation architecture (TM1/TM2 configured; later milestones proposed)

### TM0 — compatibility/prototype audit (must precede bulk implementation)

- Read `docs/ARCHITECTURE.md`, `docs/ASCENDED.md`,
  `docs/ELITES.md`, `docs/DATA_DRIVEN_FAMILIES.md`,
  `scripts/generate_variants.py`, `scripts/natural_spawns.py`,
  `scripts/validate_config.py` and relevant tests.
- Run a **read-only** compatibility census across the 409 enabled variants:
  occupied `skillName1..60` slots; currently attached cosmetic aura and
  `initialSkillName`/`initial2SkillName` reservations; existing on-life/
  on-hit buffs; monster skill schedules, class, FX/animation and death handling.
  Do not replace an original skill.
- Inspect every affected pool's `championChance`, `ignoreGameBalance`,
  `championMin/Max`, `limitChampionN`, forced `alwaysSpawnChampionN`,
  group level gates, available Champion group slots, and source proxy
  evidence; report eligible/skipped pools, **do not invent totals**.
- Preserve originals and established DBR namespace / reference precedence
  GDX2 > GDX1 > base. Keep generator deterministic and per-feature toggles.

### TM1 — low-health rage (Elite and custom Ascended rollout configured)

- Create **new namespaced DBRs** such as
  `records/skills/nonplayerskills/monsterexpansion/ben_{tier}_rage.dbr`;
  do not alter the original Dranghoul skill (it is used by vanilla Dranghouls).
  Prefer a simple no-roar self-buff first, using an existing verified aura FX.
- Proposed starting tuning (**ideas, not commitments**):
  - Veteran: **DEFERRED**. Do not implement until specifically requested;
    20% probability is not an engine-supported low-health DBR field.
  - Elite: low-health threshold **30%**, 100% of compatible Elites
    assigned this skill, duration **12s**, ~+15% damage, +10% speed,
    strong but readable FX. Do **not** automatically add CC immunity.
  - Ascended: threshold **35%**, 100% of compatible Ascended assigned
    rage as an optional design direction, duration **18s**,
    ~+20–25% damage, +10–15% speed, distinctive FX.
- `skillActiveDuration`, `lifeMonitorPercent` and
  `skillCooldownTime` exist. Set a long cooldown to avoid repeated
  rage in one fight; **confirm re-arming/retrigger conditions in-game**.
- Add via an unused `skillNameN/skillLevelN` slot, checking existing
  on-life effects and cosmetic initial skill slots. If a record's slots
  are occupied, **skip/report**; do not overwrite.
- Monster animations are not interchangeable. The source
  `skillSpecialAnimationName=Roar` may be missing on beasts/constructs.
  Avoid forced animation, sounds and unsupported FX attachments until
  confirmed on several families.
- **Shelved Veteran 20% concept (reference only):** Low-life template alone offers no activation-
  chance field. A supported *spawn-time* approximation is to split
  eligible Veteran weight **80% normal Veteran / 20% rage-capable Veteran**,
  each sharing the same family, loot, stats and Veteran tier identity.
  This needs **additional regular pool slot capacity** (15 per pool)
  and careful preservation of the existing 20% Common→Veteran share.
  If insufficient slots, skip/record limitation rather than altering
  unrelated chances. An alternative of enabling rage on 20% of Variant
  *types* is NOT a 20% per-spawn chance. A true threshold-roll proc would
  require verified alternative native mechanic or script; do not claim it.
- **Current implementation:** `config/tiers.json` now has
  `Elite.prototype.low_health_rage` and
  `Ascended.prototype.low_health_rage` both `enabled=true`,
  `target_mode=all`. Each applies at **30% HP**, +15% total
  damage and +10% movement speed for 12 seconds, with 180-second
  cooldown and the original Dranghoul aura. No `Roar` animation,
  Dranghoul-specific sound, absorption or CC immunity is copied.
  **Only the earlier Elite boar has been visually confirmed**.
- The original Hero parent records stay vanilla. New rage is
  attached only to the separately generated custom Ascended DBRs.
  Compatible variants that have a native low-health passive are
  skipped to prevent duplicate abilities.
- Both settings can be disabled independently; see
  [TIER_RAGE.md](TIER_RAGE.md) for complete scope and test instructions.
  Veteran rage is not currently part of this rollout.

### TM2 — elemental retaliations

**Current implementation:** `config/tiers.json` controls an independently
reversible **15% per qualifying hit**, **8s cooldown**, **3m radius**
`Skill_OnHitAttackRadius` clone for **36 exact source Hero archetypes**.
Aether, Poison, Fire, Cold, Lightning, Chaos have distinct native radius FX
and matching damage types. It skips monsters with native on-hit radius
skills or no safe skill slot and reports coverage in the generated manifest.
The 101 unmapped Ascended are intentionally unchanged. The generator/code
and focused tests were committed to `dev`; the mod has **not yet
been regenerated, compiled or validated in-game**. This is not a
random chance to assign an ability at spawn, and it does not alter
the low-health rage threshold. See the dedicated TM2 doc.

**Earlier exploratory guidance (for future tuning/expansion):**
- Reuse/clone `Skill_OnHitAttackRadius` for small appropriate attacks:
  Poison Nova for poisonous beasts, Aether burst for aetherials,
  Fire shockwave for fire-aligned monsters, etc. Derive compatible damage
  and VFX from actual source DBRs; avoid applying one elemental
  counterattack to every family without thematic review.
- Example initial proc **10–20% on qualifying hit**, **6–12s cooldown**,
  **2.5–3.5 m radius**, conservative damage; not an every-hit effect.
  Check source `onHitActivationChance` and cooldown semantics.
- Avoid stacking with an inherited matching on-hit skill; do not make
  effects spammy when the player has pets or high-frequency damage.
- Tier policy may be e.g. Elite **25–35% of compatible generated actors**
  receive *one* assigned special mechanic; Ascended higher. This is
  a separate proposed design from rage (do not silently activate).

### TM3 — reinforcements / Elite summons Veteran allies

- Confirm an ordinary `Skill_SpawnPet` can summon a specific
  namespaced Veteran actor with correct hostility, engagement, pathing
  and cleanup. For prototype, use **one eligible Elite**, 1–2 same-family
  lesser Veteran allies, e.g. 1-2 spawned per cast, cap **2–3 alive**,
  cooldown **25–40s**, lifetime **20–30s**.
- If the user wants the summon to occur **only after Elite HP <30%**,
  first demonstrate a native low-health-to-summon linkage. The
  `Skill_PassiveOnLifeBuffSelf` and `Skill_SpawnPet` records work
  separately; simply attaching both **does not establish gating**.
  If native binding cannot be proven, scope a normal combat cooldown
  summon instead and report the low-life limitation honestly.
- Spawn existing friendly-to-elite, **enemy-to-player** units, not
  player-allied pets; test collision/navigation and XP/loot. Dedicated
  reinforcement actor DBRs should **disable or reduce XP and loot**
  to prevent farming and double-rewarding. Verify their `giveXP`,
  `experiencePoints`, loot and kill credit, rather than inheriting
  the full generated Veteran rewards blindly.
- **Prevent recursive summoning**: reinforcements must not receive this
  same summoner skill; cap instances, lifetime and simultaneous active
  enemies. Avoid causing new pool selections or violating protected
  quest/campaign encounter constraints. Use only compatible families.
- If `Skill_SpawnPetMonster` or a native spawn variant provides safer
  monster ownership, compare with `Skill_SpawnPet` experimentally before
  committing to one solution.

### TM4 — +15% regular Champion-group encounters

- Preserve `config/master.json` existing **2× regular pack size**. The
  current generator changes regular `spawnMinEquation` and
  `spawnMaxEquation` ONLY; Champion count/chance is still vanilla. **User has
  deferred adding Champion spawn bonuses pending real playtesting.** Do
  NOT multiply the global common-spawn equation or
  `championMinEquation/championMaxEquation` as a shortcut.
- Independently configured, reversible **relative** multiplier
  `champion_chance_multiplier=1.15` for reviewed ordinary, nonzero,
  non-ignored pools: `new=min(100, native_championChance * 1.15)`.
  Example original 15 → 17.25. Keep 0 at 0, forced/special/scripted
  encounters excluded and report caps/rounding.
- Apply this to source pools even when they have **no active tier
  mapping**, if the goal is genuinely more regular Champions across the
  game. That requires a separate audited pool catalog/overlay generator
  beyond the existing 377 merged pools; do not claim global coverage from
  `scripts/natural_spawns.py` alone.
- For already mapped pools, compose the chance adjustment **after**
  merging Veteran/Elite/Ascended weights so one logical pool DBR is emitted.
  Keep exact rollback to vanilla source values when disabled.
- Effect on Elites: eligible Champion results still split approx
  **67% original Champion / 33% Elite**. No need to increase Elite
  conversion probability separately. Note that Champion pool also
  contains Heroes and that increased `championChance` does not guarantee
  a proportional +15% *observed* Champions under placement/limit rules.

### TM5 — +10–15% Hero encounters (distinct from TM4)

- There is **no separately verified `heroChance` field** in the
  inspected `proxypool.tpl`. Heroes are defined by
  `monsterClassification=Hero` among `nameChampionN` sources.
- Increase **total Hero parent + corresponding Ascended clone weight**
  relative to combined Champion + Elite weight inside the Champion
  selection group. For example, multiply each original Hero source
  weight by 1.10–1.15 **before** the 67%/33% Hero→Ascended split,
  or multiply both the already-split weights by the same ratio.
  Use integer-rational scaling to preserve exact relative ratios
  and finite integer capacity.
- Identify Heroes by resolving the actual monster's
  `monsterClassification`, **not** file/folder spelling alone.
  Do not accidentally classify Champion families as Heroes.
- Preserve each eligible Hero group's finite cap proof from
  `limit_policy_error` in `scripts/natural_spawns.py`:
  `championMax <= limitChampionN` and bounded group equations.
  **Do not increase `championMin`, `championMax`, limits, or global
  count equations** in this first implementation. Touching them can
  invalidate the present Ascended quota-safety guarantee.
- Example source `p_beasts_boar_n.dbr`: Champion weight 900, six
  Heroes of weight 8 each; conditional Hero share 48/948 ~5.06%.
  1.15x combined Hero weight becomes ~5.78% before gating/caps, so
  measured percentages will differ from the requested relative
  increase due to normalization, level gates and finite limits.
- **Composition matters**: +15% Champion-group chance (TM4) boosts
  the group as a whole; +10–15% Hero weights (TM5) changes the
  within-group mix. Doing both will affect overall Hero appearances
  multiplicatively-ish, NOT as a clean independent +15% Hero result.
  Report expected before/after selection distribution by pool,
  including Elite/Ascended share, rather than promising global rates.
- Extra Heroes naturally produce more eligible Ascended outcomes where
  current 33% conversion applies; protect special/quest/Nemesis pools.

### TM6 — balancing, observability and tests

- Keep **feature flags** independently enabled/disabled in new JSON
  settings (prefer `config/tiers.json` for tier mechanics and a separate
  scoped spawn-frequency config only if needed). Never remove config
  records to “disable”: emit vanilla-safe rollback DBRs.
- Leave original source DBRs untouched. All new records live in
  `records/creatures/enemies/monsterexpansion/` or
  `records/skills/nonplayerskills/monsterexpansion/` as appropriate,
  with user-friendly debugging metadata.
- Ensure no generated output collisions with cosmetic aura, damage
  passives, named variants, 377 merged pools, or other game mods.
- Add focused fixture-based tests for DBR payload, threshold, triggered
  skill slots, template/class match, chance math, hero weight-split
  preservation, finite-Hero quotas, blocked pools, slot exhaustion,
  rollback, and deterministic output; **do not perform extensive
  full-suite testing unless explicitly requested**.
- Lightweight in-game test matrix:
  1. Spawn known Vanilla Dranghoul and confirm it is unchanged.
  2. Spawn one modified Elite and confirm a single rage at ~30% HP.
  3. Veteran rage is shelved; no Veteran rage/probability tests for now.
  4. Spawn on-hit counterattack prototype; confirm proc/cooldown/VFX
     without excessive effects from DoTs or multi-hit attacks.
  5. Spawn reinforcements, verify enemy faction, damage, XP/loot
     settings, duration/caps and no recursive spawning.
  6. Compare **fresh sessions and large samples** of the same
     eligible ordinary pools at the same player level and difficulty.
     Count Common, Veteran, Champion, Elite, Hero, Ascended separately;
     report skipped level-gated and finite-quota pools.
  7. Check multiplayer if intended; aura spam and many spawned allies
     may hurt performance.
- Build only after updating/validating config, then generate/replace
  staging and Asset Manager F7. Never assume a successful Python
  generation proves native engine behaviour.

## Proposed milestone sequence / decision gates

1. **TM0:** read-only compatibility scan of any subsequent *bulk* target tier;
   initial one-monster prototype uses an already known enabled Elite.
2. **TM1a (implemented in config/generator):** low-health rage
   on all compatible custom Elite and Ascended variants. The
   original one-Elite boar test was successful; new variants still
   need gameplay verification.
3. **TM1b:** Veteran rage **shelved**. Do not implement without a new request.
4. **TM2 (implemented in generator/config):** curated Ascended elemental
   on-hit retaliation on 36 archetypes, not originally proposed Elite
   blanket coverage. **Pending:** local validation, regen, F7 and
   gameplay confirmation across six effects.
5. **TM3:** one capped Elite→Veteran reinforcement prototype, then
   investigate low-life-specific gating.
6. **TM4 (deferred):** audited optional +10–15% relative Champion-group chance across
   eligible ordinary source pools, preserving all existing pool merging.
7. **TM5 (deferred):** +10–15% Hero preference by eligible Hero+Ascended weights,
   retaining 33% Ascended fraction and finite group caps.
8. **TM6:** finish enable/disable switches, short regression coverage,
   documentation and in-game verification.

**Current priority:** validate/regenerate/stage/build both TM1 rage and
TM2 Ascended elemental retaliation; confirm native on-hit FX/chance/damage
and cooldown across representative archetypes. Only then consider TM3
(capped summoning). Veteran rage and Champion/Hero spawn-rate
increases remain deferred. No original Hero override should be introduced.

## Note for Codex

TM1a is configured for all compatible Elite and Ascended variants;
only the earlier single Elite boar rage was observed in-game. TM2 has been
added for 36 audited Ascended Hero archetypes but has not been tested
in-game. TM3–TM5 remain design proposals, not authorization to
implement every milestone at once. Before editing, explain the selected milestone,
current repo state, affected records, which mechanics are confirmed
versus hypothetical, and minimal test plan. Use `dev` only, push
there, and leave `main` intact.
