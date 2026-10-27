# Low-health rage — Elite + Ascended tiers

**Status:** Implemented in `dev` config/generator; not yet recompiled
or tested across all monster families. The user visually confirmed the
original **single Elite boar** rage prototype in-game (red Last Stand-style
streaks when its HP dropped below the threshold).

## Scope — important distinction

- **Elites:** all compatible **124 configured** custom Elite variants
  generated from original Champion parents.
- **Ascended:** all compatible **137 configured** custom Ascended variants
  generated from original Hero parents.
- **Original Heroes:** **unchanged**. This was explicitly clarified by
  the user: they meant **Ascended, NOT vanilla Hero**. We do not emit any
  original-path Hero monster overrides.
- **Veterans:** unchanged; their proposed 20%-chance rage is shelved.
- Original Champions, original Heroes, Bosses, Nemeses, quest actors,
  and natural spawn rates/weights are unchanged.

The 124 and 137 values are catalog sizes, **not guaranteed counts of
new rage assignments**. A variant inheriting an existing native low-HP
ability will retain that ability without an extra rage skill. Others
with no free ordinary skill slot are skipped. These cases can be audited in the generation output
`generated/MonsterExpansion/manifest.json` under
`rage_coverage.elite` and `rage_coverage.ascended`, which report
`targeted`, `attached`, `inherited_low_health`, and
`no_free_slot` counts.

## Configuration

Both tier toggles are in `config/tiers.json`:

- `tiers[id=elite].prototype.low_health_rage`
- `tiers[id=ascended].prototype.low_health_rage`

Both are **enabled**, `target_mode="all"` with no allowlist required.
For focused testing, `target_mode="selected"` accepts an explicit
`variant_ids` array of strings `family_id:variant_id`.

| DBR field | Elite | Ascended |
| --- | --- | --- |
| `lifeMonitorPercent` | 30 | 30 |
| `skillActiveDuration` | 12 seconds | 12 seconds |
| `skillCooldownTime` | 180 seconds | 180 seconds |
| `offensiveTotalDamageModifier` | +15% | +15% |
| `characterRunSpeedModifier` | +10% | +10% |
| `skillActivatedAuraName` | `dranghoul_laststand_selfloop_fx01.dbr` | Same |

The aura is the existing **red Last Stand particle** the user observed.
Both use `Skill_PassiveOnLifeBuffSelf` and an unused
`skillNameN/skillLevelN` slot, created by the common
`scripts/generate_variants.py` helper. The original Dranghoul Roar
animation, sounds, extreme CC resistances and damage absorption
are **not** copied.

Rage uses the native health-threshold passive, with no new discovery
scan and no changes to Champion→Elite or Hero→Ascended probability
(33% conditional shares), pack sizes, loot, XP, base stats or native
monster records. Existing golden Elite and violet Ascended cosmetic
auras remain in place, with the red rage FX layered while active.

## Compatibility and rollback safeguards

- Both custom tiers use the existing pre-reviewed JSON family variants:
  `config/families/discovered_elites.json` and
  `config/families/discovered_ascended.json`. Future enabled custom
  variants inherit the tier default automatically when generated.
- The generator checks native `skillName1..60` references for an
  existing `Skill_PassiveOnLifeBuffSelf` before attaching our copy.
  If present, it preserves that ability rather than stacking two
  competing low-HP buffs. If there is no free `skillName/skillLevel`
  slot, it skips the rage addition rather than overwriting.
- The generator does not touch the source files in `ReferenceFiles`;
  it writes new namespaced `..._rage.dbr` alongside modified
  generated **custom Elite/Ascended** actor records.
- The rage feature is independently reversible for each tier by
  setting the respective `low_health_rage.enabled=false` and
  regenerate + replace-stage + F7 rebuild. Note: a disabled feature
  leaves previously generated `..._rage.dbr` dependencies on disk
  unless explicitly cleaned, but regenerated actor DBRs stop
  referencing them. Do not trust leftover files as evidence of
  current generated behaviour.
- No native Hero DBR override is generated, and no separate
  original-Hero discovery/scanner is introduced.

## Local regenerate and gameplay checks

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Then Asset Manager F7, install the updated mod archive, and run
a fresh Custom Game session. Native game/build verification is
**not** established by a successful repository commit.

Known Elite direct-spawn test:

```text
game.Spawn "records/creatures/enemies/monsterexpansion/discovered_elites_elite_75bbb288ac65b5d4.dbr"
```

To choose an Ascended test candidate, select any
`variants[].output_record` from
`config/families/discovered_ascended.json`. An original Hero
source name from `variants[].source_record` is **not the same
actor** as an Ascended variant, and should not gain this rage.

Carefully reduce the Elite/Ascended to **below 30% HP** and look for
the red Last Stand particle lasting about 12 seconds. On naturally
raging parents with existing low-health mechanics, confirm native
behaviour has been preserved. Verify in-game on multiple families
before treating the broad rollout as fully confirmed.

Future elemental counterattacks, reinforcement summoning and
optional increases to Champion/Hero spawn rates remain in
[TIER_ENCOUNTER_MECHANICS_IDEAS.md](TIER_ENCOUNTER_MECHANICS_IDEAS.md).
