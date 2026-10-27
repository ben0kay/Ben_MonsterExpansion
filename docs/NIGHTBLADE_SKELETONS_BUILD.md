# Nightblade skeleton compatibility build

This implements the plan's one-skill proof of concept, on `dev` only. It is not
the full three-button skill line. Requires Ashes of Malmouth and Forgotten Gods.

## SK0 findings

- Effective Nightblade tree has **34** populated `skillName` fields; its unused
  `skillLevel35` does not represent a 35th skill. Base summon is appended as
  `skillName35`. Original duplicates and original 1–34 mappings are preserved.
- The skill-tree template declares 60 slots, and the UI panel declares an array
  of buttons. Neither is proof of runtime support for the new entry.
- Imported Necromancer UI donors are `class08/skill22.dbr` (base), `skill23.dbr`
  (Undead Legion), `skill24.dbr` (Will of the Crypt). The original tree has this
  line consecutively at slots 13–15. The third skill is a thin wrapper around
  `playerclass08/pets/petskill_skeleton_modifier.dbr`; its name, icon, rank curve
  and tier live in that native pet modifier. Keep that reference unchanged.
- Existing buttons occupy rows 39, 109, 179, 249, 319, 389 and 459. A base button
  at **(246,249)** has 160 pixels to Shadow Strike on its right, and 70 pixels
  to the nearest buttons above/below. It stays inside existing layout bounds.
  There is no demonstrated free horizontal row for the full native tier 1/3/5
  line. Its two modifiers must not be silently placed over existing skills.
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

## Implemented scope

`config/nightblade_skeletons.json` feeds `scripts/mastery_attachment.py`, which
uses the existing GDX2 > GDX1 > base resolver. It emits eight DBRs: three skill
clones, three button clones, the Nightblade tree and panel. Only the base skill
is listed in the active tree and panel. The two modifier clones are unreachable.
No original class08 skill or pet record is emitted or edited.

All native skill fields are preserved except the base's two connector texture
arrays, which are cleared while its modifiers are hidden. Native stats are
unchanged: initial burst/cap 3, 18-second cooldown, base ranks 16/26, original
energy cost curve. This build has no Undead Legion cap/cooldown increases and
no Will of the Crypt bonuses. Existing balance outputs remain byte-identical.

The module rejects overlapping visible buttons, duplicate outputs, unsafe paths,
wrong UI donors, unsupported tree slots and early exposure of modifier buttons.
The combined generator rejects collisions with other generated records. Coordinates
and paths live in config; changing the visible modifier flags intentionally fails
the compatibility gate until a full layout is implemented.

## Build and test on Windows

From the existing Asset Manager mod checkout:

```powershell
git switch dev
git pull
python scripts/validate_config.py
python -m unittest discover -s tests -p test_mastery_attachment.py -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

F7 in Asset Manager, install the rebuilt `.arz` and existing `Text_EN.arc`, and
restart the custom game. No new text assets are needed for this skill.

Use a test Nightblade + Occultist character. Look left of Shadow Strike for
Raise Skeletons; confirm its icon/name/tooltip, spend a point, put it on the
hotbar and cast. Confirm three skeletons, mana use, 18-second base cooldown,
replacement at cap, survival, attacks and rank investment. Check all old skills
and Occultist pets. Also verify the original Necromancer summon still works.
Report a screenshot of the skill panel and any build errors. This clears the
runtime gate; the full modifier layout remains the next implementation step.

To roll back, set `enabled` false in the config and repeat generation,
**replacement staging**, F7 and archive installation. The tree/panel become
exact effective originals, removing all entry points. The output manifest has
the same eight paths in both modes, so replacement staging overwrites both
active overrides; unreachable cloned skills/buttons can safely remain. Spent
points on a removed skill should be refunded on a test save before disabling.

## Validation

Config validation and six focused attachment tests pass, including native-field
parity, pet paths, effective reference selection, original tree/UI preservation,
bounds/overlap checks, combined manifest membership, existing balance preservation,
output collision rejection and disabled rollback. Combined generation/preflight
also pass. No Asset Manager or Grim Dawn runtime is available here. Full SK0–SK5
completion remains conditional on the runtime gate and a verified modifier layout.
