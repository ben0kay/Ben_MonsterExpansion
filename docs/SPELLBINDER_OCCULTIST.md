# Spellbinder: three cloned Occultist skill lines

Implemented on `dev`, November 4, 2026. Static generation and focused tests
are separate from Asset Manager F7 compilation and in-game verification.

## Configuration and ownership

`config/spellbinder_occultist.json` has a master `enabled` switch and three
independent booleans under `lines`: `bonds`, `blood`, `sigil`. Each switch
controls a complete base/modifier pair, never a dangling modifier.
Original Occultist skills and balance configuration are untouched.

`scripts/spellbinder_attachment.py` composes native Necromancer outputs.
Arcanist's existing `scripts/arcanist_attachment.py` remains the sole owner of
its final tree/panel: it calls the composer after generating its current
Guardian/skeleton state. Generation and validation pass the same effective
`player_skills.build_skills` outputs to both classes. No second competing
Arcanist tree/panel is merged into the plan. All other duplicate outputs are
rejected by the existing pipeline.

Managed donors must be present in the effective balance outputs, including
native rollback records when a balance entry is disabled. Missing effective
records fail rather than silently falling back to unmodified vanilla.
Other donors use effective GDX2 > GDX1 > base reference resolution. Nothing
writes to `ReferenceFiles`.

## Active skills and slots

The native skilltree template supports all requested fields. Current trees
have 32 Necromancer and 31 Arcanist entries, including the mastery bars.
Guardian occupies Arcanist slot 32 with skeletons still disabled.

| Mastery | Slot, default config | Skill | Button position |
| --- | --- | --- | --- |
| Necromancer | 33 | Bonds of Bysmiel | (726,279) |
| Necromancer | 34 | Manipulation | (886,279) |
| Necromancer | 35 | Blood of Dreeg | (486,459) |
| Necromancer | 36 | Aspect of the Guardian | (726,459) |
| Arcanist | 33 | Sigil of Consumption | (406,459) |
| Arcanist | 34 | Destruction | (646,459) |

Enabled pairs append to the actual first free slot, base immediately followed
by its `Skill_Modifier`, preserving the native modifier ordering convention.
Disabling Bonds makes Blood use slots 33–34. Disabling Guardian makes Sigil
use slots 32–33. Original native tree entries/ranks remain unchanged.

All six buttons clone the exact corresponding Occultist UI donors
(class03 skill25/26, skill19/20, skill12/13), with original icons, offsets,
rank controls and mastery-tier X coordinates. Native connector strips remain
on their base skills (Blood's strips live on its buff). Bonds uses native
160px spacing; Blood and Sigil use native 240px spacing. No other button
crosses these new connector corridors.

Blood or Sigil needs a free bottom row. In that mastery only, the existing
seven main rows at y=39,109,...459 become y=39,99,...399. Transmuters retain
their +32px row offset and every button retains its X coordinate. This moves
whole native horizontal chains together, rather than detaching individual
modifiers. Guardian moves from (726,179) to (726,159) with the rest of that
row. Bonds joins the unused right end of the skeleton row (y=279 with Blood,
y=319 without Blood); no standalone Necromancer button is rehomed.

The minimum button separation is checked, along with panel bounds, duplicate
panel entries and new connector corridors. Label/hover rendering and native
connector artwork still require visual inspection in game at the chosen UI
scale. The optional old Arcanist skeleton row cannot coexist with the Sigil
row: explicitly enabling both fails with an actionable error. Skeletons stay
disabled; Guardian remains independently configurable.

## Generated skill graph and inherited balance

All paths below are under `records/skills/`:

| Target | Source under playerclass03 | Linked cloned support |
| --- | --- | --- |
| `playerclass08/ben_bondsofbysmiel1.dbr` | `bondsofbysmiel1.dbr` | `playerclass08/ben_bondsofbysmiel1_petbonus.dbr` |
| `playerclass08/ben_bondsofbysmiel2.dbr` | `bondsofbysmiel2.dbr` | `playerclass08/ben_bondsofbysmiel2_petbonus.dbr` |
| `playerclass08/ben_bloodofdreeg1.dbr` | `bloodofdreeg1.dbr` | `playerclass08/ben_bloodofdreeg1_buff.dbr` |
| `playerclass08/ben_bloodofdreeg2.dbr` | `bloodofdreeg2.dbr` | Native modifier immediately after the cloned base |
| `playerclass05/ben_sigilofdestruction1.dbr` | `sigilofdestruction1.dbr` | Native damage/life-steal/FX retained |
| `playerclass05/ben_sigilofdestruction2.dbr` | `sigilofdestruction2.dbr` | Native modifier immediately after the cloned base |

Nine cloned skill/support DBRs in total; support records clone the same-named
Occultist records with only internal links repointed. Six new UI DBRs use
`records/ui/skills/class05/ben_sigilofdestruction{1,2}.dbr` and
`records/ui/skills/class08/ben_{bondsofbysmiel1,bondsofbysmiel2,bloodofdreeg1,bloodofdreeg2}.dbr`.
Final class05/class08 trees and panels, plus native button position/rollback
overrides, are part of the same manifest and replacement-staging plan.

The composer rewrites internal DBR references across the complete cloned
local graph. External FX, sounds, descriptions, original ranks, mastery
prerequisites and unrelated native assets remain identical to effective donors.

- Bonds pet-health bonus uses the existing **1.08× native bonus curve**.
  Manipulation pet total-damage and total-speed bonus curves each use **1.05×**.
- Blood clones the **Skill_BuffRadiusToggled** wrapper and its private buff:
  **100 energy reserved**, zero temporary duration/cooldown/cast cost and
  **zero instant percentage heal**. Regeneration retains the existing
  `1.20 + 0.01 × rankIndex` transform. Aspect retains native Poison
  resistance and the existing **1.05× Physical resistance curve**.
- Sigil clones **1.15× radius at every rank**, **7.2s duration** and
  **2.7s cooldown**, with damage/life-steal/costs unchanged from the effective
  main spell. Destruction inherits the existing **1.08× Fire/Chaos damage**
  overrides; it is not reset to vanilla.

No new balance numbers are introduced by this attachment. Subsequent edits
or rollbacks in `player_skills.json` flow into the clones on regeneration.
Native skill descriptions are retained, including Blood's inherited text
that can still describe temporary healing; dynamic stats and these notes
explain the mod's toggle behavior.

## Rollback

Disable a pair or the master switch, regenerate and replacement-stage, then
F7 rebuild/install. Disabled pairs disappear from the tree and panel; support
DBRs can remain staged but unreferenced. With Blood off, native Necromancer
button positions are restored; Bonds can remain active on the original row.
With Sigil off, Arcanist's prior summon-generator layout is restored exactly,
including Guardian's independent state. With all additions off, Necromancer's
original tree/panel/buttons and the prior Arcanist state are restored.
Deleting JSON entries is not the rollback mechanism; retain the switches.

## Focused validation, generation and staging

```powershell
python scripts/validate_config.py
python -m unittest discover -s tests -p test_spellbinder_attachment.py -v
python -m unittest discover -s tests -p test_arcanist_attachment.py -v
python -m unittest discover -s tests -p test_player_skills.py -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Run inside Asset Manager's `Working/mods/Ben_MonsterExpansion` checkout on
`dev`. Generated and staged DBRs are ignored build outputs, not committed
source. Generation covers the existing mod plan; no unrelated config changes
are needed. Staging recomputes and checks every output before copying it.

Tests cover exact full-record effective-donor equality after link rewriting,
private support graphs, toggle/no-heal/reservation, all Sigil radius ranks,
resistances, native-tree preservation, base/modifier adjacency, native connector
spacing, all three feature switches combined with Guardian on/off, rollback,
layout, missing effective records, capacity and output collision failures,
skeleton incompatibility and deterministic output. This is a focused skill
suite, not the entire monster/progression test suite.

## Required F7 and in-game checks

1. Pull `dev`, run the commands above, select the mod in Asset Manager and
   build with **F7**. Resolve any native-template/compiler warnings before
   installing the rebuilt `.arz`; preserve/install `resources/Text_EN.arc`.
   Restart the Custom Game. This environment cannot run Windows Asset Manager.
2. Open Arcanist/Necromancer trees at your usual UI scale. Check all native
   buttons, labels/hover regions, mastery unlock columns and connector strips.
   Confirm Guardian works and Arcanist skeleton buttons remain absent.
3. Allocate Bonds then Manipulation at low/high effective ranks. Confirm the
   modifier requires and improves the cloned base; compare pet health, damage
   and speed with the same effective Occultist ranks and equipment. Guardians
   are player-scaled summons; pet bonuses should be checked on skeletons or
   other conventional pets, not assumed to boost Guardians.
4. With missing health, toggle cloned Blood on/off: no instant heal, sustained
   regeneration past 60 seconds, one reservation released when off, allies/pets
   in radius affected. Allocate Aspect and verify Physical/Poison resistance
   changes through this cloned toggle, including after reload/resummoning.
5. Cast cloned Sigil at low/high ranks: compare radius, 7.2s duration, 2.7s
   cooldown, damage and life-steal. Allocate Destruction and confirm Fire/Chaos
   damage applies to the cloned Sigil, with the modifier prerequisite intact.
6. Compare original Occultist gameplay; confirm it is unchanged. Exercise each
   rollback switch with replacement staging and a fresh F7 build. If testing
   multiple copies of the same buff across masteries, observe engine stacking
   behavior rather than assuming duplicate bonuses stack.

No F7 compilation or in-game success is claimed by the static checks.

## Validation record — November 4, 2026

- Config/reference validation passed.
- Spellbinder attachment: **14 tests passed**; existing Arcanist attachment:
  **7 tests passed**.
- Player skill balance suite: 33 tests initially passed, one stale Flash
  Freeze expectation failed. The expectation now includes the already-configured
  rank multiplier; that test passed on rerun. No skill balance was changed.
- Full generation initially exposed an existing loot build blocker:
  `_scale_category_weights` summed a dictionary's keys. The one-line correction
  sums its numeric values, allowing the existing configured loot calculation
  to run; all **6 focused tier-loot tests passed**. No enemy/tier/spawn settings
  were changed.
- Full `--include-spawns --write --replace-generated` regeneration passed:
  **3,981 DBRs + one English text source**, including the existing mod content.
- Replacement staging passed: **3,981 DBRs + one text source**; all 3,982
  staged content files match the generated plan. No archives were built.
- F7 compilation and in-game checks remain manual and unverified.
