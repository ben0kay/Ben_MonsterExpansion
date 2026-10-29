# Occultist / Arcanist playthrough pass 1

Configuration: config/player_skills.json. Included automatically in ordinary
validation, generation, manifest and staging, alongside existing monster variants,
pack size and attributes. Effective GDX2 > GDX1 > base references are used.
Never edit ReferenceFiles. No engine build or in-game verification is claimed.

## October 27 — pet health (+20%) and skeleton damage (+15%)

This pass updates existing pet-actor overrides in `config/player_skills.json` for
all Familiar and Hellhound ranks and adds one shared Necromancer skeleton
pet-scaling override. The skeleton buff applies to the attached Nightblade
Raise Skeletons line and to the original Necromancer summons because they
reference the same pet skill. The skeleton passive also applies a +15%
relative boost to its native total-damage curve across all 26 ranks.
The generator remains DLC-aware, configurable
and reversible; no original `ReferenceFiles` change is made.

Focused tests are committed in `tests/test_player_skills.py` for the
1.20 health-multiplier ratio at all 52 Occultist actor ranks, both 1.20
HP and 1.15 base-damage multipliers over all 26 skeleton scaling ranks,
full-field preservation and individual rollback.
Tests are not executed in this GitHub-only session. Regenerate, stage and
build with Asset Manager F7 to apply these changes in-game.

## Active changes

- All 13 exclusive flags found in uploaded mastery records are cleared, including
  other masteries. This permits the intended stacking; verify in game.
- Aether Ray: beamThickness 1.25 -> 2, maxRange 16 -> 22.
  Beam thickness is the native beam field; collision and particle appearance must
  be checked in game. No speculative particle edits are made.
- Aether Ray, Disintegration, Devastation and Doom Bolt: nonzero damage
  fields multiply by 1.15 + 0.015 * (rank - 1), preserving their original curves.
  This is +15% at rank 1, +37.5% at rank 16, +52.5% at rank 26.
  Zero damage types stay zero; costs and damage conversions remain.
- Devastation: duration 5 -> 8 seconds, target radius 6.5 -> 8,
  explosion radius 2.8 -> 3.5, projectiles per launch 2 -> 3.
  More projectiles help compensate for the larger area; profile in crowded fights.
- Sigil of Consumption: each original rank-specific projectileExplosionRadius
  value is multiplied by 1.15 (rank 1: 3.5 -> 4.025; rank 8: 4.4 -> 5.06;
  rank 22: 5.5 -> 6.325). The entire 22-rank progression is preserved.
  Duration 6 -> 7.2 seconds (+20%) and cooldown 3 -> 2.7 seconds (-10%).
  Damage, life-steal, energy cost, targeting and all other DBR fields remain
  unchanged. A 15% radius boost corresponds to ~32% greater circle area;
  this follows the requested radius-based scaling rather than area-only scaling.
- Doom Bolt: radius 3.5 -> 4.5; recharge 4 seconds minus 0.04 per
  additional rank (3.16 seconds at rank 22).
- Maiven's Sphere: original absorption plus 1 + 0.15 * (rank - 1)
  percentage points, capped at 38%. Original damage penalty preserved.
- Familiar and Hellhound: **2 per type at ranks 1–7**, **3 per type at ranks
  8–14**, and **4 per type at ranks 15–26**. Rank 15 unlocks four without
  equipment overcapping (normal cap 16; ultimate 26). One pet is summoned
  per cast, with the original 18-second cooldown; equipment summon-limit
  bonuses remain untouched and may raise the final limit further. Pets
  have no summon expiry, but can die and must be resummoned, including
  after a new session as usual.
- Familiar and Hellhound actors (all 26 ranks for each) originally received
  +10% health modifier at rank 1, +2 percentage points per further rank
  (+60% at rank 26). A subsequent +20% **relative-health** pass multiplies
  the previously modded actor HP multiplier by 1.20, so those modifiers now
  run **+32% at rank 1 to +92% at rank 26** (formula: new bonus =
  20 + 1.2 * previous bonus). This is not merely adding 20 points. Their
  innate/primary attack damage bonuses are unaffected by this health pass.
- Nightblade Raise Skeletons uses the original Necromancer skeleton actors:
  `records/skills/playerclass08/pets/petskill_skeleton_basescaling.dbr`
  now modifies **two** original 26-rank curves independently:
  `characterLifeModifier = 20 + 1.2 * vanilla` (+20% relative HP,
  rank 1: 0 -> 20; rank 26: 175 -> 230), and
  `offensiveTotalDamageModifier = 15 + 1.15 * vanilla`
  (+15% relative base-scaling total damage, rank 1: 0 -> 15;
  rank 26: 365 -> 434.75). The percentage-point offset ensures the
  `100 + bonus` factor scales as intended. **This also buffs Necromancer's
  original skeletons**, since both masteries use the same pet scaling
  record. Original Necromancer player skills, summon caps and pet attack
  behavior remain unchanged. Other item/mastery bonuses can affect final
  health and damage. Blade Spirit is invulnerable and receives no HP change.
  Gear-summoned pets and other masteries are not globally modified.
- Blood of Dreeg: native radius toggle, 100 energy reserved, duration/cooldown/
  cast cost removed. Regeneration is increased by 1.20 + 0.01 * (rank - 1).
  Its instant percentage heal is removed to avoid repeated healing on toggle
  activation; the regeneration and remaining buff/modifier benefits persist.
- Mirror of Ereoctes: native self toggle, 150 energy reserved; original temporary
  100% absorption replaced by 8% at rank 1 plus 0.5 percentage points per rank
  (18.5% at rank 22, ceiling 20%). Duration/cooldown/cast cost removed.
  Sphere and Mirror are intended to stack; final engine absorption is not assumed
  to equal the simple sum. Existing skill names/descriptions may still describe
  temporary effects; dynamic stats and this document describe the changes.

Only temporary player-activated buffs in these two masteries are converted.
Attacks, channels, debuffs, ground spells and conditional defensive procs retain
their activation behaviour. Other than the separate shared skeleton pet-health pass described above, no
Necromancer player-skill balance changes beyond global exclusivity removal. No extra buffs to unspecified skills in this first pass.

## Arcanist pass 2 — moderate passive and offensive buffs

This pass preserves every original rank curve (including overcap ranks), applies
only 5–10% multipliers to selected numbers, and leaves all other damage types,
energy costs, skill prerequisites, resist reductions, debuff strengths and pet
skills unchanged. The global `config/player_skills.json` enabled flag and
per-record `enabled` flags still support exact vanilla rollback.

### Passive and sustained aura skills
- Inner Focus (`passive01`): +8% over the native Spirit and Offensive Ability
  *modifier* curves, per rank.
- Arcane Will (`passive02`): +8% to native Defensive Ability and energy regen
  curves. Proc activation, duration, cooldown and damage buff unchanged.
- Mental Alacrity (`passive03`): +8% to flat energy and +5% to cast-speed
  bonus curves. Does not change global player cast-speed caps.
- Fabric of Reality (`passive04`): +10% native flat Aether/Chaos damage
  and +8% to their percentage damage-bonus curves.
- Iskandra's Elemental Exchange (`elementalinfusion1_buff`): +8% to energy
  regeneration bonus and flat elemental damage; reserve costs untouched.
- Overload (`elementalinfusion2`): +8% to its flat OA and Aether-resistance
  curves; electrocute/burn/frostburn and reserved energy unchanged.
- Elemental Balance (`elementalinfusion3`): +8% to its critical damage
  bonus curve; damage-over-time modifiers unchanged.

### Offensive skills
- Panetti's Replicating Missile (`arcanemissile`): +10% base flat
  elemental damage and +10% base explosion radius (0.5 -> 0.55).
  Main missile child-fragment counts are 5 exactly at ranks 1–3 (vanilla 3);
  5–6 at ranks 4–11 (vanilla 3–4); and 5–7 at ranks 12–26
  (vanilla 3–5). Both native 26-rank min/max fields are explicitly
  configured in `config/player_skills.json`, preserving the usual
  damage/radius improvements and the original single primary projectile.
- Distortion, Supercharged and Proliferation
  (`arcanemissile2/3/4`): +8% to specified flat Aether/elemental
  damage fields; Proliferation explosion radius +10% (0.3 -> 0.33).
  Proliferation's separate Aether fragment counts, resistance reduction
  and crowd control remain unchanged.
- Trozan's Sky Shard (`skyshard1`): +10% original Cold/Lightning flat
  damage and original per-rank explosion radius (1.4 -> 1.54 at rank 1,
  3.3 -> 3.63 at rank 26). Cooldown 3.0 -> 2.85 seconds (-5%);
  energy cost and targeting unchanged.
- Frozen Core / Shattered Star (`skyshard2/3`): +8% flat frostburn and
  Lightning components, respectively; freeze, slow and crit values unchanged.
- Callidor's Tempest (`razorwind1`): +10% native Aether/Fire flat
  damage and per-rank target radius (4.2 -> 4.62 at rank 1,
  5.8 -> 6.38 at rank 26). Inferno (`razorwind2`) gets +8%
  Lightning and burn components; transmuter remains untouched.
- Olexra's Flash Freeze (`chillingsurge_buff`): +10% Cold damage,
  +8% original per-rank radius (5 -> 5.4 at rank 1, 18 -> 19.44
  at rank 22), +10% original per-rank duration (2 -> 2.2 seconds
  at rank 1, 6 -> 6.6 at rank 22). Cooldown, freezing/resist stripping unchanged.
  Absolute Zero (`chillingsurge2`): +8% frostburn component; debuffs unchanged.

**No further changes** to Aether Ray, Disintegration, Devastation, Maiven's
Sphere, Mirror, Reckless Power, Star Pact, Nullification or Arcanist's mastery bar.
This is still a build-time data pass; in-game behaviour and UI values need testing.

## Occultist pass 3 — modest offensive and passive upgrades

This balances 16 newly managed Occultist records and extends the existing
Possession override without reversing its non-exclusive flag. All numeric
multipliers apply to each original rank's own value, including overcap ranks,
not a fixed bonus taken from rank 1. Values are build-time, and need in-game
verification.

### Offense / debuffs
- Curse of Frailty (`curse1_buff`): +10% original per-rank radius and
  +10% original per-rank duration. Rank 1 radius 3 -> 3.3; rank 16
  11.8 -> 12.98; rank 1 duration 5 -> 5.5 seconds. Slow/other debuffs unchanged.
- Vulnerability (`curse2`): +5% relative to original negative
  Chaos, Elemental, Vitality and Poison/Acid resistance values. For example,
  -21 becomes -22.05 at rank 8, preserving the native 20-rank curve.
  Defensive Ability reduction is unchanged. Percent displays may round.
- Bloody Pox (`pox1_buff`): infection duration 5 -> 5.5 seconds,
  and +8% native flat Vitality and Bleeding damage at every rank.
- Wasting (`pox2`): +8% flat Vitality damage; enemy OA penalty unchanged.
- Black Death (`pox3`): +10% native Poison DoT field;
  confusion chance and duration unchanged.
- Dreeg's Evil Eye (`evileye1`): +10% original poison/acid damage
  fields and base projectile explosion radius 0.5 -> 0.55.
- Focused Gaze (`evileye1b`): 4 -> 3.8 second cooldown (-5%);
  damage multiplier, projectile FX and mana cost untouched.
- Blood Burst (`evileye2`): +10% original per-rank explosion radius.
  Rank 1 0.5 -> 0.55; rank 22 3 -> 3.3.
- Terrifying Gaze (`evileye3`): +8% flat Vitality damage; poison
  modifiers, stun, confusion and critical damage left unchanged.
- Vile Eruption (`evileye4`): **only max fragment count** +1 from
  rank 12 onward, based on the native integer curve (e.g. rank 12 max
  7 -> 8, rank 22 max 8 -> 9). Ranks 1-11, minimum fragments,
  projectiles and explosion radius are untouched.
- Destruction (`sigilofdestruction2`): +8% original flat Chaos/Fire
  damage values per rank, while retaining the previously updated main Sigil
  (7.2s, 2.7s cooldown, +15% per-rank radius).

### Passives / buffs
- Solael's Witchfire (`witchfire1`): +5% to its native attack-speed
  bonus curve, +8% to flat Chaos damage. Flat Defensive Ability unchanged.
- Second Rite (`witchfire2`): +8% to the Chaos damage bonus and
  +5% to the critical damage bonus. Vitality resistance unchanged.
- Aspect of the Guardian (`bloodofdreeg2`): +5% to the original
  physical resistance curve. Poison resistance and Blood of Dreeg's
  earlier sustained toggle stay unchanged.
- Possession (`possession1`): +8% relative Chaos/Vitality damage
  bonus and Vitality damage-over-time bonus curves. Non-exclusive
  `exclusiveSkill=0` remains. Chaos resistance unchanged.
- Bonds of Bysmiel (`bondsofbysmiel1_petbonus`): +8% *relative*
  to the original pet-health bonus curve, not +8 percentage points.
- Manipulation (`bondsofbysmiel2_petbonus`): +5% relative native
  pet total-damage and total-speed bonuses; no pet counts changed.

Not part of this pass: Occultist mastery-bar attributes, Familiar/Hellhound
Mend Flesh, Storm Spirit, Hellfire or Lightning Strike pet abilities.
Existing Doom Bolt, Summon Familiar, Summon Hellhound and Blood of Dreeg
main-buff rules remain untouched. For each new record, setting
`enabled: false` restores the exact effective original DBR after regeneration;
Possession is still a single record with its prior exclusivity override.

## Pyromancer Fire synergy — focused Occultist additions

A small cross-mastery compatibility pass adds **direct Fire damage** to
two Occultist spells for Demolitionist + Occultist play, preserving all
existing Poison/Acid, Vitality and Chaos damage, modifiers, cooldowns,
projectiles and effects. No conversion is performed.

| Skill DBR | New `offensiveFireMin` by skill rank | Rank 1 | Rank 22 |
| --- | --- | ---: | ---: |
| `records/skills/playerclass03/doombolt1.dbr` | **8%** of each native rank's `offensiveChaosMin + offensiveLifeMin` | 34.4 | 318.88 |
| `records/skills/playerclass03/evileye1.dbr` | **15%** of each native rank's `offensivePoisonMin` | 1.2 | 64.5 |

Both fields were `0.000000` in the effective original reference; the
game's DBR attack templates accept 22-rank real-valued damage curves.
This pass writes explicit 22-rank positive Fire curves as
semicolon-separated strings through the **existing** per-record `set`
overrides in `config/player_skills.json`. Source equations are evaluated
against the native original values, not previously buffed output, so the
increase stays conservative. Prior Doom Bolt Chaos/Vitality rank scaling and
cooldown/radius improvements, plus Dreeg's Evil Eye poison/acid scaling,
remain unchanged.

The main synergy is with **Thermite Mine's elemental resistance reduction**,
**Curse of Frailty/Vulnerability's elemental resistance reduction**, and
fire-oriented character damage bonuses from Demolitionist/equipment.
`Destruction` already adds Fire damage to Sigil of Consumption; it is
untouched. **No summon damage, Demolitionist raw damage, other Occultist
spells, loot or XP** are changed by this pass.

No new projectile visuals or Burning damage-over-time are added: the
spells will keep their native appearance, but should show the added Fire
component in their tooltips after building. Tests check exact field
isolation, all 22 added values, preserved native curves, and per-skill
rollback. They have not been run in the GitHub-only authoring session,
and in-game behavior still needs verification.

## Tuning and rollback

Each record has set (literal DBR values) and curves (numeric rank transforms).
Curve formula: source[rank] * (multiplier + rankIndex * multiplier_per_rank)
+ add + rankIndex * add_per_rank, optionally capped. rankIndex starts at zero.
A scalar source can be expanded with ranks; existing array lengths otherwise stay.
All target fields must exist, except the template-supported mana reservation
field on Mirror, which is explicitly sourced from a native aura record.

Change the top-level enabled flag to false to emit exact effective vanilla records
for every managed path, then regenerate, stage, rebuild and reinstall.
Per-record enabled=false restores that record. Do not delete managed entries to
roll back: an old compiled override could remain. Toggle conversions span wrapper
and buff records; disable both Blood of Dreeg records together.

## Build and play

Run the README's normal full validate/test/generate/stage commands, then F7 in
Asset Manager and install the rebuilt .arz and Text_EN.arc. JSON is build input,
not a live setting. This environment does not compile the Windows game database.

Check:
1. Possession, Reckless Power and Star Pact remain active simultaneously.
2. Blood of Dreeg and Mirror stay on beyond their former duration; energy
   reservation is applied once and released when switched off.
3. Blood of Dreeg still reaches allies/pets and Aspect of the Guardian works.
4. Summoning twice at rank 8 keeps two pets; a third cast respects the limit.
5. Ray's visible width versus actual hits, range and channel energy use.
6. Devastation coverage/performance; Doom Bolt and pet damage during progression.

Report skill name, allocated/effective rank, equipment modifiers and what feels
weak/strong. Those details let us adjust the shared config during the playthrough.

Current full generation expects 3,011 DBRs plus one English text source (115 skill overrides, including the new Sigil record). The Windows build and in-game performance are not yet verified.

Historical validation (prior to the movement/basics/Sigil passes): 76 tests checked. The full run passed 73 and exposed three stale
file-count expectations after the shrine-reference upload; all three passed on
rerun after correcting those expectations. Config validation and combined
generation pass. Staging idempotence, edit protection and manifest preflight
pass in temporary Asset Manager directory fixtures. No Windows archive built.
