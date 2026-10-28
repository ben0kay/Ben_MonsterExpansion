# TM2 — Ascended chance-on-hit themed retaliation

**Status (2026-10-28): configured and committed on `dev`; needs a local
generator/build and in-game verification.** This feature alters generated
custom Ascended monsters only, never vanilla Heroes or other tiers.
Existing Elite/Ascended low-health rage remains independent.

## Native Cave Prawn exclusions

`prawncave_h02` (Chiricrix, Frozen) and `prawncave_h03`
(Blucrix, Defender) already inherit the native
`prawn_poisonnova_onhit01.dbr` skill (`Skill_OnHitAttackRadius`).
**Do not change or duplicate those attacks.** Their natural native
chance/cooldown remain untouched. They are intentionally not in the new
retaliation mapping.

## Activation and tuning

- All *mapped, compatible* Ascended get **one** new themed on-hit
  radius counterattack via an unused `skillNameN/skillLevelN` slot.
- Shared `onHitActivationChance=10` is **a 10% chance per qualifying
  incoming hit while ready**, not a spawn chance and not a low-HP roll.
- Shared `skillCooldownTime=8` seconds reduces proc spam;
  shared `skillTargetRadius=3` meters makes a close-range burst.
  Multi-hit, DoT, damage and cooldown behavior need gameplay checks.
- Rank `charLevel/4+1` keeps a native 60-rank damage curve. The
  ordinary source is the native Aether Obelisk on-hit radius skill;
  Poison uses the native Prawn Poison Nova curve. All clone changes
  use existing DBR fields and source FX packs, without modifying
  reference or vanilla Hero records.
- The five expanded profiles use the native damage fields:
  `offensiveLifeMin` (Vitality),
  `offensivePhysicalMin` (Physical),
  `offensivePierceMin` (Pierce);
  Bleeding has 25% of the source curve as physical impact + 50% as
  `offensiveSlowBleedingMin` over 2 seconds; mixed Elemental splits
  the source curve equally between Fire, Cold and Lightning.
  These are **proposed conservative starting values**; final actual
  damage, bleed timing and animation/FX suitability need testing.

## Exact Hero mapping

An exact `hero_stems` allowlist was reviewed against the original
Hero description and skill names. Each Hero belongs to **at most one**
profile; same species can have different elements (e.g. Electrified
boar is not treated as a Burning boar).

| Theme | Native visual concept | Mapped custom Ascended |
| --- | --- | ---: |
| Aether | Arcane blast | 20 |
| Poison/Acid | Poison Nova | 27 |
| Fire | Fire tempest | 15 |
| Cold | Ice tempest | 14 |
| Lightning | Lightning tempest | 13 |
| Chaos | Chaos tempest | 14 |
| Vitality | Vitality counterstrike | 11 |
| Physical | War Cry impact/shockwave | 13 |
| Pierce | Ring of Steel burst | 3 |
| Bleeding | Shower of Blades burst | 4 |
| Mixed Elemental | Elemental blast (Fire/Cold/Lightning) | 1 |
| **Total configured** | **36 earlier + 99 newly assigned** | **135 of 137** |

**Excluded:** exactly two native Cave Prawns, left unchanged.

**Configured ≠ guaranteed attached.** The generator preserves inherited
on-hit radius attacks and skips a monster with no spare ordinary skill
slot, logging all outcomes under
`generated/MonsterExpansion/manifest.json` ->
`retaliation_coverage.ascended` (`mapped`, `attached`,
`native_onhit`, `no_free_slot`, `unmapped`, `by_element`).
A native on-hit radius skill discovered on any other original Hero
is preserved instead of overwritten or doubled.

## Configuration and rollback

`config/tiers.json` ->
`tiers[id=ascended].prototype.elemental_retaliation`.

- Global `enabled`, `activation_chance_percent`,
  `cooldown_seconds`, `radius_meters` apply consistently to
  all eleven profiles.
- Each profile has a native `source_skill_record`,
  `radius_effect_record`, and an explicit `hero_stems` list.
  No automatic element guess based on the species filename.
- `enabled=false` removes generated attachments on regeneration.
  Replace staged/compiled files during rebuild; previously compiled
  mod content is not automatically removed by changing JSON.

## Focused local validation, build and test

From repository root:

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python -m unittest discover -s tests -p test_elemental_retaliation.py
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Review the `manifest.json` retaliation coverage, then compile with
**Asset Manager F7** and install the current custom game. Use
`config/families/discovered_ascended.json` `output_record`
values for `game.Spawn`. Test at least one Hero for each new
damage category, plus both Cave Prawns to confirm unchanged native
skills. Confirm new burst visuals, damage type, no excessive spam,
the expected cooldown, original skills, and independent low-HP rage.
The generator/tests alone cannot prove native FX or on-hit behavior.

**Not implemented by TM2:** reinforcement summoning, low-health
summon gating, random skill assignment at spawn, or changes to
natural monster spawn rates/weights.
