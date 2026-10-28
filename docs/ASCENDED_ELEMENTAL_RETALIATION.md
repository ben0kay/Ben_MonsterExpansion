# TM2 — Ascended elemental on-hit counterattacks

**Status: configured and committed on `dev`, NOT yet generated/compiled or verified in-game.**
Only custom Ascended actors are targets. Original Heroes, Elites, Veterans and every
original enemy skill remain untouched. Existing Ascended rage remains independent.

## Why the chance is real

The native `Skill_OnHitAttackRadius` class supports `onHitActivationChance`.
This means a **15% chance on each qualifying hit while the skill is available**;
it does **not** mean 15% of Ascended spawns receive a skill, and it is **not**
a probability on the separate low-health rage trigger. The cooldown limits
repeat activations. Precise handling of damage-over-time, blocked hits and
cooldown timing still needs in-game testing.

## Current tuning

- All **curated** Ascended Hero archetypes receive one compatible on-hit retaliation
  skill if they have a free skill slot and no native on-hit radius passive.
- `activation_chance_percent = 15`, `cooldown_seconds = 8`,
  `radius_meters = 3`.
- Rank `charLevel/4+1`; original 60-rank native damage curve is retained,
  moved to the correct element field where appropriate. Conservative balance
  and high-level scaling have not yet been observed in-game.
- Original `Skill_OnHitAttackRadius` records are cloned into
  `records/skills/nonplayerskills/monsterexpansion/*_retaliation.dbr`.
  Native FX packs supply element-matched radius visuals. **No base files
  are edited.**
- The original Prawn Poison Nova supplies Poison. The Aether Obelisk
  Vindictive Aether supplies Aether; Fire, Cold, Lightning and Chaos use
  its rank curve *moved* to the corresponding damage field, together with
  a matching vanilla radius FX pack. Those four combinations are **new,
  unverified gameplay compositions**, not claims of existing vanilla skills.

## Curated individual-Hero mapping

| Element | Example matched Hero archetypes | Mapped variants |
| --- | --- | ---: |
| Aether | Arcane/Timewarped Aetherials, Aether Zombie Hounds | 6 |
| Poison | Diseased Aetherial, Plague Hound, toxic Prawn, Diseased Thorned Horror | 5 |
| Fire | Burning Aetherials, fire Rift Hounds, Burning Prawn | 5 |
| Cold | Coldheart/Frozen Aetherials, frost Yetis, Frozen Thorned Horror | 7 |
| Lightning | Electrified Aetherials and Prawns, lightning Gazers | 8 |
| Chaos | Chaos Prawn, Cave Prawn, Rift Hound, Gazer and Thorned Horror | 5 |
| **Total** | **36 of 137 configured Ascended Hero variants** | **36** |

The allowlist uses **exact Hero source record stems**, e.g.
`aetherialcolossus_h01` (Electrified → Lightning) and
`aetherialcolossus_h02` (Burning → Fire); matching all
`aetherialcolossus` as Aether would be incorrect. Explicitly unmatched
Vampiric, physical-only and other ambiguous Hero archetypes are left alone.

These are **configured matches, not guaranteed assignments**.
The generator skips an actor when it inherits a native on-hit radius
ability or has no vacant ordinary skill slot, reporting the outcome in
`generated/MonsterExpansion/manifest.json` ->
`retaliation_coverage.ascended` (`mapped`, `attached`,
`native_onhit`, `no_free_slot`, `unmapped`, `by_element`).
The remaining 101 are intentionally unmapped until their actual elemental
identity and compatible effects are reviewed. Do not infer an element
blindly from every monster filename, or add several reactive skills to
one Hero.

## Config/rollback

`config/tiers.json` ->
`tiers[id=ascended].prototype.elemental_retaliation`.

- `enabled=false` disables the entire mechanic independently from rage.
- `activation_chance_percent`, `cooldown_seconds`, `radius_meters`
  control the shared balance.
- `profiles[element].hero_stems` is an **exact, reviewed Hero source
  record allowlist**, not a species-wide rule. Different Heroes from the
  same species can belong to different elemental profiles.
- `profiles[element].source_skill_record` and
  `radius_effect_record` reference native on-hit skills and FX packs.
- Rebuild with `--replace-generated` and `--replace-staged` when
  turning it off; stale previous compiled content must be replaced.

## Lightweight validation and in-game test

From the repository root, after `git switch dev` and `git pull origin dev`:

```powershell
python scripts/validate_config.py
python -m unittest discover -s tests -p test_elemental_retaliation.py
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Check the manifest coverage first, then compile **Asset Manager F7** and
install the mod. Spawn a selected generated `output_record` from
`config/families/discovered_ascended.json` via `game.Spawn`.
Confirm correct native elemental FX and actual damage on a hit,
that many hits do **not** always proc, and an approximately eight-second
minimum gap between activations. Repeat with both melee/pets and multiple
monster families. Check damage and visual spam at high character levels.
Verify parent Hero is unchanged and the separate red low-health rage
can still activate. A successful generator run does **not** prove engine
FX compatibility or cooldown mechanics.

**Deferred:** additional families, true per-spawn skill rolls,
reinforcement summons and low-health-gated summons. No changes to
natural monster spawn/conversion percentages.
