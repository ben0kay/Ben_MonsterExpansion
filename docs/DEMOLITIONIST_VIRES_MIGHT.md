# Vire's Might cloned into Demolitionist

**Working branch:** `dev`.
**Status:** configured in the normal generation/staging pipeline; tests
authored, but **not run locally**, not built with F7, and not confirmed
in-game. Requires **Forgotten Gods**, which supplies Oathkeeper, the original
Rush animation, icons, sound and other native assets.

## Objective

Add **one unmodified-in-combat copy of Vire's Might** to the Demolitionist
mastery so Demolitionist + Arcanist (Sorcerer) can rush into and out of close
range without selecting Nightblade or using a medal movement augment.

This is **not** a new movement engine, Fire-damage conversion, second retreat
ability, Oathkeeper mastery unlock, or an addition of Vire's Might modifiers.

## Donor / emitted records

| Role | Native Forgotten Gods donor | Generated Demolitionist target |
| --- | --- | --- |
| Skill | `records/skills/playerclass09/viremight1.dbr` | `records/skills/playerclass02/ben_viremight1.dbr` |
| Button | `records/ui/skills/class09/skill21.dbr` | `records/ui/skills/class02/skill37.dbr` |

The skill source uses `database/templates/skill_attackpathcharge.tpl`
(`Skill_AttackPathCharge`) with the original `Rush` animation,
`3.6 s` base cooldown, `2.2` target radius, physical/trauma damage
rank arrays, mana costs, impact audio and native icons.

The only clone changes are **cosmetic UI field values**:
`skillConnectionOff` and `skillConnectionOn` are cleared to avoid drawing
dangling Oathkeeper modifier branches. All native combat-related fields,
skill ranks (16 / 26), Vire's Might name/description tags, sound and animation
references remain copied from effective GDX2 data. The charge behavior is
not replicated via custom script.

We deliberately **do not** copy `viremight1b.dbr` (Tectonic Shift),
`viremight2.dbr` (Volcanic Stride), or `viremight3.dbr` (Haven't
verified the localized modifier name). This avoids extra cross-class
prerequisites, trail attacks and UI branches during the first test.

## UI and slots

Demolitionist's 36 native tree skills and all 33 original UI buttons remain.
The pre-existing skeleton attachment uses tree slots **37–39** and class02
buttons **34–36** in the bottom row. Vire's Might is added at **slot 40**,
new button **class02/skill37.dbr**, at pixel **(806, 459)** in that bottom
row. Its separate location avoids overlapping the three skeleton buttons at
(246,459), (406,459), (566,459) and the compressed native rows.

One optional `extra_skills` configuration in
`config/demolitionist_skeletons.json` adds the new skill; it is **enabled
independently** of the existing top-level skeleton `enabled` flag.
`scripts/mastery_attachment.py` now validates an explicit, native,
allowlisted Vire's Might donor/target/button and only the two cosmetic
connector-field overrides. It refuses unknown damage changes, collisions,
other-class target paths, unsupported donors and invalid enable flags.

The combined generator already incorporates the Demolitionist attachment
through its standard generator and manifest: no separate manual DBR copy is
needed. ReferenceFiles are never edited.

### Independent enable switches and rollback

| `demolitionist_skeletons.json` state | Result |
| --- | --- |
| `enabled:true`, `extra_skills[0].enabled:true` | Skeletons slots 37–39 plus Vire's Might slot 40 |
| `enabled:false`, `extra_skills[0].enabled:true` | Only Vire's Might, now slot 37; original buttons stay shifted for room |
| `enabled:true`, `extra_skills[0].enabled:false` | Only the skeleton row (three skills) |
| Both disabled | Native tree/panel/button positions restored |

All four configurations emit the same generated record paths, so **stage
with replacement**, then rebuild with F7 to overwrite previously emitted
tree/UI DBRs. When switching off the new skill, remove invested skill points
on a test character before rebuilding; test on a backup save.

## Local test sequence

From the repository root:

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python -m unittest discover -s tests -p test_mastery_attachment.py -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Build with **F7** in Grim Dawn Asset Manager, install the rebuilt `.arz`
and usual Text_EN archive and restart the Custom Game. On a Demolitionist
(or Demolitionist + Arcanist) test character, verify:

1. The Vire's Might icon, original name and tooltip appear in the bottom-right
   Demolitionist skill row; no overlapping buttons or dangling connectors.
2. The button accepts skill points, can be assigned to the hotbar, and its
   normal 3.6-second cooldown and 16/26 rank limits appear.
3. The original Rush movement animation, collision, targeting, physical/trauma
   damage and hit FX behave like Oathkeeper's Vire's Might.
4. Skeletons retain their own three buttons and summon/cap behavior.
5. Try each independent enable/disable combination on a throwaway test
   character; after replacement staging, no stale skills remain in the tree.

Potential engine-level constraints (skill classification, class animation,
trail behavior) can only be proven inside Grim Dawn. No in-game success
is claimed here.
