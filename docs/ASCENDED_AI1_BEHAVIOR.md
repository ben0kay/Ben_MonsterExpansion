# AI1 — Smarter custom enemy controllers

**Plan recorded 2026-10-28 and committed before any code changes.**
**AI1a status:** implemented in config/generator with focused tests on `dev`;
not yet run locally, compiled or gameplay verified.
**AI1b status:** future proposal only; no general rollout.
**Branch:** `dev` only. Treat reference DBRs as read-only.

## Goal

Add **modest, role-appropriate controller improvements** to custom Ascended
enemies, without replacing original attack skills, pathfinding, animations,
faction, pool eligibility, combat statistics or source Hero controllers.

This is native `ControllerMonster` behavior tuning, **not** a custom
scripted AI or a promise of flanking / coordinated tactics.

## Verified DBR evidence

- Monsters use `controller,records/controllers/enemy/....dbr`.
- The source `boar_h01` uses `controller_raptor.dbr`, already
  with `DodgeChance=70` and `ChanceToRespondToDistressCall=75`.
- The source `gazer_h01` uses `controller_gazer.dbr`, already
  with `DodgeChance=75`, `RepositionChance=45`, and
  `randomRepositionChance=20`.
- The native `database/templates/controllermonster.tpl` defines
  `DodgeChance`, `DodgeDelay`, `FleeBehavior`, `FleeChance`,
  `RepositionChance`, `randomRepositionChance`,
  `ChanceToRespondToDistressCall`, `MaxPursuitDistance`,
  healing priority fields, and pet-targeting fields.

## Three desired AI personalities

1. **Aggressive melee:** pursue a little more persistently and assist
   allies more readily. Do not add fleeing or increase already high
   dodge rates. Example: boars, raptors and Flesh Hulks.
2. **Evasive ranged/caster:** modestly increase movement/reposition
   attempts, respecting strong preexisting dodge behavior; retain
   existing retreat conditions. Example: Gazers and spellcasters.
3. **Support caster/summoner (future rollout):** improve aid to allies
   only when appropriate native heal/buff skills are present. Preserve
   existing targeting and avoid unintended permanent retreat.

## Implementation gates

### AI1a — small prototype (configured/implemented; awaiting local tests)

- Scope **only two exact Ascended source Hero stems**:
  `boar_h01` (aggressive) and `gazer_h01` (evasive).
- Read each *individual* source monster's actual `controller`
  reference, resolve against the base/DLC reference precedence,
  verify its native `controllermonster.tpl` / `ControllerMonster`,
  then copy the entire controller DBR to a **per-variant namespaced**
  record in `records/controllers/enemy/monsterexpansion/`.
- Edit only reviewed, already-existing controller fields:
  - `boar_h01`: `MaxPursuitDistance` +10 (75→85);
    `ChanceToRespondToDistressCall` +10 (75→85).
  - `gazer_h01`: `RepositionChance` +10 (45→55);
    `randomRepositionChance` +5 (20→25).
  - Clamp chance settings at 100 and enforce safe positive distances;
    preserve the original high 70/75 dodge chances.
- Attach the cloned controller to **only the generated Ascended actor**;
  leave original Hero, Elites, Veterans and all other monsters untouched.
- Expose a validated independent `enabled` toggle in `config/tiers.json`
  (under Ascended prototype), and deterministic named Hero/profile lists.
- Fail closed on missing/unexpected source controller or properties,
  duplicate assignments or output collisions.
- Focused tests (`tests/test_ascended_ai.py`): exact target/clone mapping,
  controller template, changed values, unmodified original fields and
  skills, off switch, no unintended changes to other variants, no
  source-Hero overrides, unsafe-delta rejection and manifest coverage.
- Regenerate/stage/build manually. **No claim of runtime compatibility
  until the user sees the behavior in Grim Dawn.**

### AI1b — later rollout (not authorized yet)

- Observe AI1a in-game and adjust if dodging/fleeing looks awkward.
- Review other Hero controllers for genuine aggressive/evasive/support
  roles; build **per-variant exact allowlists**, never classify all
  monsters solely by species name.
- Test representative support healer/summoner with native skills;
  add controlled target/retreat changes only after verifying efficacy.
- Roll out to compatible Ascended variants with a coverage/skip report.
- Consider custom Elite profiles only after a separate decision.

## Generated outputs and coverage

The feature is in `config/tiers.json` → `tiers[id=ascended].prototype.smart_ai`.
`profiles[role].hero_stems` provides exact native Hero file stems;
`adjustments` supplies the approved additive per-field values. The two
chosen sources are `boar_h01` and `gazer_h01`. Generated controllers are
at `records/controllers/enemy/monsterexpansion/<family>_<variant>_ai.dbr`.
Generator reports `ai_coverage.ascended` (mapped, attached, unmapped,
by_profile) in `generated/MonsterExpansion/manifest.json`.

**The source Hero controller is always preserved**. A missing native field,
invalid controller template, or out-of-range adjusted value must fail the
build, not silently rewrite the game's original controller.

## Compatibility & rollback

- This feature is independent of the existing low-health rage,
  on-hit retaliation, cosmetic aura, XP and spawn conversion systems.
- Do not edit `ReferenceFiles/` or vanilla logical controller paths.
- Turning `enabled=false` makes newly generated Ascended monsters
  reference their original controller DBRs. **Rebuild and replace staged
  and compiled content**; the JSON file is not read by the game at runtime.
- Stale, unused namespaced controller files can remain on disk if
  older staging is not cleaned; do a clean Asset Manager rebuild if
  comparing on/off tests.
- Changing AI parameters may have no visible effect on some models
  depending on AI state, combat circumstances or animations.

## Build / manual check

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python -m unittest discover -s tests -p test_ascended_ai.py
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Use Asset Manager F7, then compare spawned original `boar_h01` /
`gazer_h01` against the two custom Ascended versions with several
enemies nearby and room to move. Look for repeated positioning, pursuit,
assisting behavior, and any AI regressions. No engine test is run here.
