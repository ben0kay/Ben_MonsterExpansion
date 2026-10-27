# Nightblade skeleton skill line

Target: `dev`. Requires Ashes of Malmouth and Forgotten Gods. The user confirmed
that the earlier base button accepts points, hotbar assignment and casting.
The full bottom-row layout and modifier behavior remain to be checked in-game.

## Current layout and attachment

The effective Nightblade tree has 34 named entries. Add the base and its two
modifiers consecutively at slots **35, 36, 37**, matching native Necromancer
order (originally slots 13–15). No existing skill entry is removed or reordered.

| Skill | UI position | Native UI donor |
| --- | --- | --- |
| Raise Skeletons | 246,459 | class08/skill22.dbr |
| Undead Legion | 406,459 | class08/skill23.dbr |
| Will of the Crypt | 566,459 | class08/skill24.dbr |

The seven original rows move from 39/109/179/249/319/389/459 to
39/99/159/219/279/339/399. This frees the original bottom row for skeletons.
All X coordinates stay unchanged. The three transmuter/branch buttons move with
their parent rows, keeping their native relative offsets. Native skeleton
connector strips are restored, with the same horizontal spacing as Necromancer.
No background artwork or other class UI is changed.

All positions, skill paths and allowed base overrides live in
`config/nightblade_skeletons.json` (schema 2). `scripts/mastery_attachment.py`
emits **39 DBRs**: three skill clones, three new buttons, Nightblade tree/panel,
and all 31 original button overrides. The generic existing generator composes
these with the rest of the mod and rejects duplicate paths. Reference inputs
are resolved GDX2 > GDX1 > base; no reference file is modified.

## Summon mechanics

Only the cloned base skill's `petBurstSpawn` and `petLimit` change: **3 → 4**.
Cooldown remains 18 seconds, with native cost, base ranks 16/26, pet variants,
weights, scaling and effects. Original Necromancer records remain untouched.

Undead Legion is `Skill_Modifier`; its `petLimit` curve adds capacity to the
base, rather than replacing it. Keep its native +1 to +7 curve:

| Undead Legion rank | Added capacity | New total cap |
| --- | --- | --- |
| Unlearned | 0 | 4 |
| 1 | 1 | 5 |
| 12 | 5 | 9 |
| 22 | 7 | 11 |

Its native cooldown and mana reductions are unchanged. Will of the Crypt
retains its `petSkillName` pointing to the native
`playerclass08/pets/petskill_skeleton_modifier.dbr`, which owns its name,
icons, rank curve and tier. It is not copied or retuned. Existing skeleton pets
are shared with the game. Native tier requirements remain 1/3/5 for the line.

## Shared pet health improvement (separate balance pass)

The Nightblade-attached Raise Skeletons skills reuse the original
`playerclass08` skeleton actors and their shared
`pets/petskill_skeleton_basescaling.dbr` passive. A separate config-driven
`config/player_skills.json` override now scales that passive's native
`characterLifeModifier` at all 26 ranks by `1.2 * vanilla + 20`. This
produces a **1.20x multiplier of the original intrinsic skeleton HP scale**
(0% -> 20% at rank 1; 175% -> 230% at rank 26) and affects all four
skeleton variants. It also increases the health of Necromancer's original
skeletons, since the shared base-scaling skill is used in both masteries.
All skeleton summon limits, damage, behavior and UI remain unchanged by this
HP pass. Disabling this record specifically restores native skeleton scaling
after regeneration, replacement-staging and rebuilding. See
[PLAYER_SKILLS.md](PLAYER_SKILLS.md).

## Dependency audit

The shared tree template declares 60 slots; actual base skill attachment was
subsequently confirmed in-game. Native consecutive modifier ordering and UI
donors are retained. Full modifier propagation still needs a gameplay check.

- Transitive DBR scan reached 178 records. Nine stock references were absent
  from the extraction: `records/controllers/pets/controller_skeleton_normal.dbr`,
  `controller_skeletoncaster_normal.dbr` in the same folder;
  `records/sounds/skillsounds/class08/spak_raiseskeleton_cast.dbr`; and six
  `records/items/loottables/enemyspecific/` records:
  `tdyn_summon_necroskeleton01_axe1h.dbr`,
  `tdyn_summon_necroskeleton01_blunt1h.dbr`,
  `tdyn_summon_necroskeleton01_sword1h.dbr`,
  `tdyn_summon_necroskeleton02_gun2hcrossbow.dbr`,
  `tdyn_summon_necroskeleton03_weapon.dbr`,
  `tdyn_summon_necroskeleton04_shield.dbr`.
  They are retained as stock game references, not fabricated or packaged.
  DLC localization, mesh, texture, animation, sound availability and class-bound
  runtime behavior cannot be verified without the user's installed game.


## Build and test

From your existing Asset Manager mod checkout:

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python -m unittest discover -s tests -p test_mastery_attachment.py -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

F7 in Asset Manager, install the rebuilt `.arz` and existing `Text_EN.arc`, and
restart the custom game. No new localization assets are needed for the line.

On a Nightblade + Occultist test character:

1. Find all three buttons on the bottom row. Inspect icons, names, connector
   strips, rank text and all existing skill rows for overlap or clipping.
2. Cast with the modifiers unlearned: observe four skeletons and base cap four,
   original mana cost and 18-second cooldown. Recasting replaces pets at cap.
3. At the required mastery tier, invest in Undead Legion: rank 1 allows five
   skeletons; recast to fill capacity. Check tooltip cooldown/mana reductions.
4. Invest in Will of the Crypt: inspect its pet bonuses and verify effects on
   the summoned skeletons. Verify prerequisites, point refunding and hotbar use.
5. Check existing Nightblade skills and Occultist pets; test the original
   Necromancer separately to confirm its original three-skeleton burst/cap.

## Rollback

Set `enabled` false and repeat generation, **replacement staging**, F7 and
archive installation. Disabled output restores exact effective originals for
the Nightblade tree, panel, all 31 existing buttons, and the base clone's stats.
The same 39 paths remain in the manifest, ensuring stale moved-button overrides
are overwritten. New-only cloned skills/buttons become unreachable. Refund points
from the added skills on a test save before disabling. Other balance changes,
including enemy XP, are unaffected.

## Validation

Config validation and eight focused tests pass: native field parity except the
two approved summon fields, all pet variant paths, modifier curve parity, tree
and panel membership, shifted UI field parity, preserved branch offsets, effective
reference selection, combined manifest/existing balance preservation, collision
rejection and exact disabled rollback. Combined generation and staging preflight
pass. No full historical suite was run; no Asset Manager or game runtime is
available here. User verification of the previous base-only build does not yet
verify this new full-line layout or modifier propagation.
