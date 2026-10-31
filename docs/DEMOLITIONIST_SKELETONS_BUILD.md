# Demolitionist skeleton skill-line attachment

**Branch:** `dev`. **Status:** configuration and generator wiring committed,
tests authored but not run; no Asset Manager build or in-game confirmation.
Requires Ashes of Malmouth for native Necromancer assets.

The original Nightblade skeleton attachment in
[docs/NIGHTBLADE_SKELETONS_BUILD.md](NIGHTBLADE_SKELETONS_BUILD.md) remains
enabled and unchanged. The shared `scripts/mastery_attachment.py` now accepts
a separate mastery selection, with the Nightblade default preserved.

## Demolitionist tree and UI

The original Demolitionist skill tree has **36** existing named skill slots.
Append the three *cloned* Necromancer skills at **37–39**. Original native
Demolitionist skill records are not removed, replaced or reordered.

| New Demolitionist skill | Skill donor | UI donor | New DBR/UI | Button position |
| --- | --- | --- | --- | --- |
| Raise Skeletons | `playerclass08/summon_skeleton1.dbr` | `class08/skill22.dbr` | `playerclass02/ben_raiseskeletons1.dbr` / `class02/skill34.dbr` | 246,459 |
| Undead Legion | `playerclass08/summon_skeleton2.dbr` | `class08/skill23.dbr` | `playerclass02/ben_raiseskeletons2.dbr` / `class02/skill35.dbr` | 406,459 |
| Will of the Crypt | `playerclass08/summon_skeleton3_petmodifier.dbr` | `class08/skill24.dbr` | `playerclass02/ben_raiseskeletons3_petmodifier.dbr` / `class02/skill36.dbr` | 566,459 |

The original seven Demolitionist rows at Y=39,109,179,249,319,389,459
are compacted to Y=39,99,159,219,279,339,399; native transmuter buttons
are adjusted relative to their associated skills. The new bottom row is
Y=459 with 160 px horizontal spacing to preserve the donor connector layout.
X positions, other panel art, existing skills and original button ordering
are preserved; 33 existing Demolitionist buttons are emitted as reversible
overrides, as in the Nightblade implementation.

`config/demolitionist_skeletons.json` is independent of
`config/nightblade_skeletons.json`, with its own `enabled` flag.
Generator output now includes **43 DBRs** while Vire's Might is configured:
33 moved existing buttons, 3 skeleton skills/buttons, 1 Vire's Might
skill/button, and the skill tree and panel. The skeleton-only count was
41 before adding the separate movement skill. It is included
automatically in the combined generator and staged manifest under
`demolitionist_skeletons`; the existing `nightblade_skeletons` manifest
entry remains unchanged.

## Spawn and modifier progression

Demolitionist's cloned base Raise Skeletons has **4 summoned per cast** and
**4 base concurrent skeletons**, instead of the native Necromancer's 3/3.
Cooldown **18 s**, level thresholds, mana cost and all pet variants remain
native. Its *separate* Undead Legion modifier adds summon capacity:

| Undead Legion rank | Added | Demolitionist total |
| --- | ---: | ---: |
| Not learned | 0 | **4** |
| 1 | +1 | **5** |
| 12 | +5 | **9** |
| 22 (overcap) | +7 | **11** |

Will of the Crypt keeps its native shared `petSkillName` and improves skeleton
combat statistics without adding summon slots. Shared skeleton actor/passive
scaling already adjusted in `config/player_skills.json` (**+20% relative
base HP scaling and +15% relative base total damage scaling**) applies to
all original Necromancer skeleton pets, and thus both new mastery attachments.
The original Necromancer base summon remains **3 per cast**.

Two independent classes having an identically sourced summon skill does not
prove that their *combined* simultaneous caps stack; test Nightblade +
Demolitionist on a throwaway character before relying on both summon lines.
The target playthrough here is Demolitionist + Occultist, where only the
Demolitionist skeleton line is present.

## Generator, validation and rollback

The common attachment generator now restricts the destination to class02 or
class04 using matching tree/panel/skill/button namespaces, validates tree
capacity and free UI placement, checks native skill donors and enforces no
duplicate output paths. Both classes use the *same* Necromancer donors, cloned
as separate skill DBRs. Existing Nightblade build/test entry points work with
the default `load_settings(repo)`; new code uses
`load_settings(repo, 'demolitionist')`.

To remove **only the skeletons**, set
`config/demolitionist_skeletons.json` -> `enabled:false` and regenerate,
replace stage and rebuild F7. The independent **Vire's Might** clone remains
available when `extra_skills[0].enabled:true`; the UI/layout stays compacted
and the Vire's Might entry moves to tree slot 37. If you want the **exact
native Demolitionist tree, panel and original button positions restored**,
also set `extra_skills[0].enabled:false`. The same 43 paths are generated in
all configurations to overwrite prior output. Nightblade stays enabled.
See [Vire's Might attachment](DEMOLITIONIST_VIRES_MIGHT.md).

Tests in `tests/test_mastery_attachment.py` check donor record parity,
three consecutive skeleton slots, independent Vire's Might tree slot and
UI, original button preservation, independent flags and rollback,
manifest integrity, and namespace/layout rejection.
These tests have not been executed in the GitHub-only session.

## Build and in-game checks

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python -m unittest discover -s tests -p test_mastery_attachment.py -v
python -m unittest discover -s tests -p test_player_skills.py -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Rebuild with F7 and copy your generated mod archives as usual. On a
Demolitionist + Occultist character, verify that the three bottom-row skills
have usable buttons, correct names/icons/connectors, and no collision with
the existing seven Demolitionist rows; check rank spending/refunds, a
4-skeleton first cast, 9 cap at Undead Legion 12 and 11 at 22 overcap.
Verify the original Demolitionist attacks and Nightblade UI still work.
