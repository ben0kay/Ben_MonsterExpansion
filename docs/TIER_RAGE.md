# Low-health rage — Elite and original Hero rollout

**Status:** Implemented in the `dev` **generator/config**, not yet rebuilt
or verified in-game as a group. The user visually confirmed the prior
one-Elite-boar prototype: red Last Stand-style streaks at low HP.
The native engine mechanics are already proven on that boar; broad actor
coverage, skipped records, engine behaviour and multiplayer remain to test.

## Scope and meaning of Hero

- **Custom Elites**: all compatible active Elite variants generated from the
  current 124 configured Champion parents, using their existing family config.
  There is **no new discovery scan** and no change to pool selection or the
  33% Champion→Elite conversion.
- **Original Hero tier**: any compatible *native Hero-class monster actor*
  discovered automatically in the extracted base/GDX1/GDX2
  `ReferenceFiles/creatures/enemies` logical record tree. These actors
  receive overrides **at their original game DBR paths**, so existing
  map/pool references to a vanilla Hero use the modified record.
  This may include quest-specific actors classified Hero; it does
  **not** change Boss, Nemesis or Champion-classified monsters.
  The effective source is resolved as GDX2 > GDX1 > base.
- **Ascended**: not part of this rollout. They are separately generated
  Hero-derived actors with their own DBRs and violet glow. Their native Hero
  parents receive rage, but the separately generated Ascended copies do
  not automatically inherit it. We can design independent Ascended mechanics
  later.
- **Veterans**: no rage; the previously proposed 20%-chance idea remains
  deferred. No Champion/Hero spawn-rate changes in this rollout.

## Configuration

Both switches live in `config/tiers.json`:

- `tiers[id=elite].prototype.low_health_rage`
- `tiers[id=hero].low_health_rage` (no vanilla Hero stat prototype is added)

Both currently have `enabled=true`, `target_mode=all`, and the
following buff settings:

| DBR effect field | Value |
| --- | ---: |
| `lifeMonitorPercent` | **30** (when HP falls below 30%) |
| `skillActiveDuration` | **12 seconds** |
| `skillCooldownTime` | **180 seconds** |
| `offensiveTotalDamageModifier` | **+15** |
| `characterRunSpeedModifier` | **+10** |
| `skillActivatedAuraName` | `records/fx/skillsother/buff/dranghoul_laststand_selfloop_fx01.dbr` |

Each ability uses `Skill_PassiveOnLifeBuffSelf`. We deliberately do
**not** copy the original Dranghoul-specific Roar animation/sounds,
25 flat damage absorption, 500-point CC resistances or any other
unrequested boosts. Existing Elite golden glows and native Hero effects
are otherwise untouched.

`target_mode=selected` with `variant_ids` is retained for future
narrow **Elite** tests (`family_id:variant_id` values). Original Heroes
currently use automatic full-class selection; setting either tier's
`enabled=false` disables its modifications independently.

## Safety, coverage, and how the generator works

- `scripts/generate_variants.py` uses the established family-based
  pipeline for Elites. Each compatible Elite is assigned an additional
  namespaced `..._rage.dbr` through an unused ordinary
  `skillNameN/skillLevelN` slot after its existing cosmetic aura.
- For originals, `build_native_hero_rage` uses
  `references.records(REFERENCE, 'creatures/enemies')` to enumerate
  **all uploaded logical DBR records**, detect
  `monsterClassification=Hero`, and emit per-Hero
  original-path overrides and new namespaced rage skill DBRs.
- These are build-time DBR changes, not runtime skill-scanning or
  edited game archives. New native Hero actors added to the source
  reference folders will be included on a subsequent full generation,
  subject to the same guards.
- If a monster **already has a native low-health buff skill**, leave it
  alone rather than stacking two competing trigger effects.
- If there is **no free skillName/skillLevel slot** or a Hero actor has
  an unexpected template/class, skip that actor rather than overwriting
  existing abilities. As a result, **not every Hero is guaranteed a new
  rage effect**; the generated manifest reports original-Hero discovered,
  modified and skipped records/reasons. The count for Elites is determined
  by the generated rage DBRs relative to current enabled Elite variants.
  A skipped actor may already have its own low-health behaviour.
- The normal `game.Spawn` commands still work. No original
  `ReferenceFiles` contents are edited. The normal custom tier/pool
  conversion rates, drops, HP bonuses, model scaling and XP reward
  settings are unchanged.
- A normal `--family <one-family>` generation does not include the
  **global original-Hero overrides**; use the default **full** build for
  this feature. This avoids modifying unrelated Heroes during narrow tests.

## Rebuild and focused gameplay tests

From your local repo on `dev`:

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Rebuild in Asset Manager (F7), retain your updated `.arz` and text
assets, and start a fresh Custom Game session.

Test an Elite directly:

```text
game.Spawn "records/creatures/enemies/monsterexpansion/discovered_elites_elite_75bbb288ac65b5d4.dbr"
```

Test a known original Hero source:

```text
game.Spawn "records/creatures/enemies/hero/boar_h01.dbr"
```

Watch health fall gradually under 30% and check red streaks appear
for about 12 seconds and disappear. Test more than one model family
before concluding broad runtime coverage. A Hero that already had
a native low-life skill may be excluded; consult the manifest report
`native_hero_rage.skipped`.

## Rollback / scope control

To disable Hero rage only, change `tiers[id=hero].low_health_rage.enabled`
to `false`. To disable Elite rage only, change
`tiers[id=elite].prototype.low_health_rage.enabled` to `false`.
Regenerate, replace-stage and F7 rebuild.

**Important rollback detail:** the generator deliberately omits disabled
native-Hero overrides. The stage script does not automatically delete
previously compiled DBRs from Asset Manager working folders or archives.
If disabling Hero rage after installing it, remove stale Hero override
DBRs and their `nativehero_*_rage.dbr` dependencies from the staging
folder or rebuild from a clean working/mod source, while preserving all
other mod records. Merely toggling `enabled=false` and rebuilding atop
a stale staged DBR may leave the old override active. Consider an
explicit safe cleanup/vanilla restore pipeline for any production
rollout requiring guaranteed one-click rollback.

## Further plans

Elemental counterattacks, reinforcements, an independent Ascended ability,
and optional Champion/Hero frequency changes are **not** part of this
implementation. See [TIER_ENCOUNTER_MECHANICS_IDEAS.md](TIER_ENCOUNTER_MECHANICS_IDEAS.md).

**Validation:** Static generator/configuration review and focused regression
cases; **no full game or multi-hour test** has been performed here.
