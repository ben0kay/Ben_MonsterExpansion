# Occultist / Arcanist playthrough pass 1

Configuration: config/player_skills.json. Included automatically in ordinary
validation, generation, manifest and staging, alongside existing monster variants,
pack size and attributes. Effective GDX2 > GDX1 > base references are used.
Never edit ReferenceFiles. No engine build or in-game verification is claimed.

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
- Familiar and Hellhound: one per type at ranks 1-7, two per type at ranks 8-26.
  One summon per cast; equipment summon-limit bonuses remain untouched and may
  raise the final limit further. These pets already have no summon expiry.
  They can die and must be resummoned, including after a new session as usual.
- Each pet actor rank gains +10% health modifier at rank 1, +2 percentage
  points per further rank (+60% at rank 26), added to its original modifier.
  Pet innate/primary attack damage uses the same damage scaling above.
  Existing player-level scaling and pet equipment bonuses remain.
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
their activation behaviour. No Necromancer balance changes beyond global
exclusivity removal. No extra buffs to unspecified skills in this first pass.

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
- Distortion, Supercharged and Proliferation
  (`arcanemissile2/3/4`): +8% to specified flat Aether/elemental
  damage fields; Proliferation explosion radius +10% (0.3 -> 0.33).
  Projectile fragment counts, resistance reduction and crowd control unchanged.
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

Current full generation expects 2,995 DBRs plus one English text source (99 skill overrides, including the new Sigil record). The Windows build and in-game performance are not yet verified.

Historical validation (prior to the movement/basics/Sigil passes): 76 tests checked. The full run passed 73 and exposed three stale
file-count expectations after the shrine-reference upload; all three passed on
rerun after correcting those expectations. Config validation and combined
generation pass. Staging idempotence, edit protection and manifest preflight
pass in temporary Asset Manager directory fixtures. No Windows archive built.
