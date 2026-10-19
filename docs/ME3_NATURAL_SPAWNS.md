> **October 19 update:** [Current config-driven families guide](DATA_DRIVEN_FAMILIES.md) supersedes old schema, record counts and config keys below. Generate/stage all families for 30 DBRs. Original boar visuals and proxy/pool selection were verified by the user; new zombies remain untested in-game.

# ME3 — natural Veteran Boar spawns

Implemented for first playtest, October 18, 2026. Natural spawning and its
Veteran:Champion ratio are NOT yet verified in-game.

## Changes and scope

`records/proxies/area001/beasts_boar_n.dbr` references
`records/proxies/pools/p_beasts_boar_n.dbr` through `pool1`. We emit a modified
copy of that pool at its original record path inside the custom mod. We do
not alter the proxy or map, and never overwrite the extracted reference file.
The engine resolving this mod pool override from existing world encounters
is the first in-game acceptance check; record inspection alone cannot prove it.

Only encounters using this exact pool are affected, wherever placed. This is
not a promise that every boar encounter, region, expansion or difficulty uses
this pool. Among uploaded DBRs, the area001 proxy above is the only direct
reference found. Map placement data was not inspected, so no exact test location
is claimed. The `_n` suffix alone does not prove a game-difficulty scope.

The existing four regular entries keep weights 40/30/20/10 and their original
level rules. New regular slot 5 points to the existing custom Veteran Boar,
with weight 25 and the same level-variance equation as regular slot 1.
No minimum level gate is added beyond its inherited eligibility, allowing early
Veterans where this pool is used. All original pool fields remain unchanged:
spawnMin=2, spawnMax=9, championChance=15, championMin=0, championMax=2,
Champion/Hero weights, Hero minimum levels and limits, and pool equation.

This gives **25/(100+25) = 20% of eligible regular weighted selections** to
Veteran and 80% to Common. It does not mean 20% of all encounters, guaranteed
one Veteran per pack, or an established 2.5:1 Veteran:Champion ratio. Champion
selection is separate; that ratio is a playtest target, not an engine field.
Do not multiply championChance by 2.5 or treat it as the observed Champion share.

## Master tier settings

`config/tiers.json` -> Veteran -> `prototype`:

- `cosmetic_aura`: the approved nature-glow preset and enabled toggle, moved
  from the boar config without changing any generated cosmetic/monster DBR.
- `natural_spawns.regular_pool_weight`: **25**, provisional tuning control.
- `natural_spawns.target_veterans_per_champion`: **2.5**, reporting target only;
  changing this does not auto-adjust weight. Calibrate weight from playtests.
- `model_scale_vs_parent`: existing monster-size control, independent of glow.

Aura intensity/particle scale controls are still not proven or exposed. Current
appearance is approved unchanged; exact configured hex/tint remains unverified.
Only the boar family is implemented; future reviewed families can consume these
shared tier defaults. This is not automatic generation for all enemies.

`config/families/boar.json` -> `natural_spawns` explicitly enables this reviewed
pool, records its proxy, reserves unused slot 5 and selects slot 1 level rules.
The older `first_prototype.planned_spawn_integration=false` describes the isolated
ME2 generator baseline; ME3 requires the separate `--include-spawns` option.

## Build and test

Run inside your local `Working/mods/Ben_MonsterExpansion` repository:

```powershell
git pull
python -m unittest discover -s tests -v
python scripts/validate_config.py
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Expect **seven DBRs**, including `database/records/proxies/pools/p_beasts_boar_n.dbr`.
Then select the mod in Asset Manager, F7, install the rebuilt mod `.arz` exactly
as before, and restart the Custom Game for fresh population. No resource archive
or new map is required for this test. Keep using the same difficulty while
measuring; fresh sessions avoid counting previously populated areas repeatedly.

1. Confirm the build log includes the custom pool and no missing-record errors.
2. Optional console-spawn the custom boar to confirm the known visual baseline.
   This does NOT test the pool.
3. Explore naturally populated boar encounters. Identify green-glow Veterans,
   Common Boars, Champions and named Heroes separately; do not count console spawns.
4. Record Common / Veteran / Champion / Hero counts per session. Start with
   at least 100 naturally spawned boars; use more sessions if Champions are scarce.
   Zero Champions makes the ratio undefined, not proof that it is too high.
5. Verify Common remains most frequent; target roughly 2–3 Veterans per Champion
   over a larger sample, rather than forcing a per-pack composition.
6. Check level scaling, movement, melee and death FX; current 92 HP is only the
   previous test level, not an expected value at every level.

If none appear, first share the Asset Manager pool build log, installed `.arz`
path and areas visited. Check pool resolution and which proxy is present before
raising the weight or changing unrelated spawn settings.

## Rollback that also replaces an already compiled pool

Set family `natural_spawns.enabled` to `false`, then rerun the same commands
WITH `--include-spawns` and both replacement flags. The generator emits the
original vanilla pool contents at the override path. Rebuild/install and start
a fresh session. The Veteran remains console-spawnable with its approved glow.

Omitting `--include-spawns` only stops emitting/staging a pool; it does NOT
remove an old staged or compiled override. Likewise, merely deleting a source
DBR may leave a stale record in an incremental `.arz`. Use the explicit vanilla
pool rollback above.

## Verification and checkpoint

20 Python tests pass: preserving every original pool field, exact addition of
one regular entry, inherited level equation, no other emitted proxy paths,
unchanged monster/bio/damage/glow outputs, config validation, exact staging
allowlists and vanilla-content rollback. Engine pool fallback/override behavior,
map coverage, observed rarity and collision/melee behavior still need playtests.

The previous cosmetic playtest passed: user spawned Veteran Boar with visible
green glow and 92/92 HP, confirmed movement was good and approved its appearance.
The earlier failed spawn was a console typo (`veteran01` vs `veteran_01`), not a
build or aura regression. Do not repeat that investigation.
