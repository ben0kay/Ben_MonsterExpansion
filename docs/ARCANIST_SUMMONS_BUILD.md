> **November 4 follow-up:** Guardian is still independently enabled in slot 32
> and skeletons remain disabled. The new Sigil/Destruction pair occupies slots
> 33–34 by default. This generator now composes those changes before emitting
> its final outputs. With Sigil enabled, native main rows compact to 60px spacing
> and Guardian is at (726,159); with Sigil disabled, the prior layout below is
> restored exactly. The old optional skeleton row and Sigil row cannot be active
> together. See [Spellbinder additions](SPELLBINDER_OCCULTIST.md) for current
> layout, switches, generated paths and F7/in-game verification.

# Arcanist: Guardian of Empyrion (skeleton line disabled)

**Active status (November 3, 2026):** Skeleton attachment is **disabled**
in `config/arcanist_summons.json` (`skeletons.enabled=false`).
**Guardian of Empyrion stays enabled** and takes the first free
Arcanist skill-tree slot **32** (rather than slot 35). Native Arcanist
buttons and positions are restored. This is committed on `dev`,
not yet rebuilt by F7 or verified in-game.

The three skeleton donor skills and custom UI DBR templates remain
available for an optional later re-enable, but **none are registered
in the active Arcanist skill tree or panel**. Nightblade and
Demolitionist skeleton lines are unaffected.

Python tests were updated but not run in the GitHub-only environment.
F7, game loading, buttons and summon behavior still need testing.

## Requested features and native donors

Both are cloned from **original game/DLC skills**, not made-up actor skills.
`ReferenceFiles` remains read-only. The custom skills use
`records/skills/playerclass05/ben_*.dbr` and native game pet actors.

### Inactive option only: Necromancer skeleton line (not in current Arcanist UI)

| Skill | Original (GDX1) | Cloned Arcanist skill | UI button |
| --- | --- | --- | --- |
| Raise Skeletons | `playerclass08/summon_skeleton1.dbr` | `playerclass05/ben_raiseskeletons1.dbr` | `class05/skill32.dbr` |
| Undead Legion | `playerclass08/summon_skeleton2.dbr` | `playerclass05/ben_raiseskeletons2.dbr` | `class05/skill33.dbr` |
| Will of the Crypt | `playerclass08/summon_skeleton3_petmodifier.dbr` | `playerclass05/ben_raiseskeletons3_petmodifier.dbr` | `class05/skill34.dbr` |

- The initial cast/baseline capacity is **4 skeletons** (native 3).
- Undead Legion retains **native additive limits**. At rank 12 it adds
  +5 for a combined limit of **9**. Its high overcap ranks can bring the
  combined limit to **11** (before equipment bonuses).
- The Necromancer skeleton actors and shared
  `playerclass08/pets/petskill_skeleton_basescaling.dbr` are reused.
  The mod already gives this shared scaling +20% relative HP and
  +15% relative total damage, so Arcanist inherits those improvements.
- The original Necromancer/Nightblade/Demolitionist summon lines remain
  unchanged. This new line is a separate class-tree attachment; concurrent
  skills summoning identical pet actor types may be subject to engine pet
  accounting and must be tested in-game.

### Guardian of Empyrion (one Arcanist button)

- Native donor from Forgotten Gods (GDX2):
  `records/skills/playerclass09/summon_celestialguardian1.dbr`.
- Custom skill: `records/skills/playerclass05/ben_summon_celestialguardian1.dbr`.
- UI button: `records/ui/skills/class05/skill35.dbr`.
- The native guardian summons **2 guardians through ranks 1–23**
  and **3 guardians at ranks 24–26**. It keeps its native 20-second
  cooldown, visual effects, original pets and Fire/Physical attacks.
- **This is only the base summon skill.** Oathkeeper's Guardian
  transmuter and Celestial Presence upgrade are *not* added.
  To avoid misleading orphan skill-tree connector graphics, only
  `skillConnectionOn`/`skillConnectionOff` are cleared on the clone.
- No Aether conversion, artificial permanent lifetime or new pet actors
  are introduced. Guardian was chosen because it is an existing
  invulnerable, player-scaled summon, complementary to the skeletons.

## Skill panel layout

The original Arcanist panel has 30 native skill buttons (numbers
01–26, 28–31; number 27 is not included in the native panel).
**Currently the three skeleton buttons are disabled and not present
in the Arcanist panel.** The following skeleton layout is the
optional configuration if re-enabled:

- Skeletons: **(246,459), (406,459), (566,459)**.
- Guardian: **(726,179)**, on the same mastery-tier X-column as
  its native Oathkeeper button.
- Existing five standalone Arcanist buttons (which would overlap the
  skeleton row) are relocated while the skeleton line is enabled:

| Native button | Skill | Old position | New position |
| --- | --- | --- | --- |
| skill10 | Nullification | (566,459) | (566,109) |
| skill11 | Inner Focus | (246,459) | (246,109) |
| skill12 | Arcane Will | (486,459) | (486,39) |
| skill13 | Mental Alacrity | (726,459) | (726,39) |
| skill14 | Fabric of Reality | (806,459) | (806,179) |

These moves preserve each ability's **X-column** (mastery-bar tier), do
not move its underlying skill tree slot or change balance, and avoid
button-box overlaps with all 30 original class05 buttons. No other
native button changes. **The user should visually inspect label,
connector and hover positions in-game**; rectangle spacing alone is not
a guarantee of correct on-screen appearance.

**Current active Arcanist skill-tree slot: 32 = Guardian of Empyrion.**
Native slots 1–31 remain intact. Skeleton slots 32–34 and the old
Guardian slot 35 apply only when the skeleton line is explicitly
re-enabled. Original panel and button DBRs are emitted as targeted
overrides for clean restoration, without edits to original references.

## Independent toggles / rollback

Configuration: `config/arcanist_summons.json`.

- **Current default — `skeletons.enabled:false`:** removes all three
  skeleton buttons/tree slots and restores all five original
  Arcanist buttons to native coordinates, while leaving Guardian enabled.
- `guardian.enabled:false`: removes only Guardian; skeletons remain.
- Top-level `enabled:false`: emits exact native Arcanist tree, panel,
  and the five native button records. The dormant `ben_*` skill and
  custom button DBRs may remain in staging but are unreferenced.
- Re-enable separately as desired, **regenerate + replace staged
  DBRs + F7 rebuild** every time. Changing JSON alone does not
  change game assets.

## Flash Freeze radius enhancement

In `config/player_skills.json`,
`records/skills/playerclass05/chillingsurge_buff.dbr` now uses a
radius multiplier **1.10 + 0.0025 × (rank − 1)** relative to the
original radius at each rank, keeping all 22 native radii:

| Rank | Native radius | New radius |
| --- | ---: | ---: |
| 1 | 5 m | **5.5 m** |
| 12 | 16 m | **18.04 m** |
| 22 | 18 m | **20.745 m** |

This replaces the previous flat 1.08× radius enhancement.
**Follow-up cooldown change:** the native `skillCooldownTime` is a fixed
scalar 6.000000 seconds, not a per-rank curve. The Arcanist skill
override now sets it to **3.000000 seconds** at every rank, a 50%
reduction; this does not compound with overcap levels. Existing +10%
Cold damage, +10% freeze-duration enhancement, radius progression and
freeze/resistance behavior remain unchanged. Disable the
`chillingsurge_buff.dbr` entry to restore the native record after
regenerating/rebuilding.

## Build and focused checks

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python -m unittest discover -s tests -p test_arcanist_attachment.py -v
python -m unittest discover -s tests -p test_player_skills.py -k test_arcanist_offensive_coverage_and_cooldown_are_bounded -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

F7 in Asset Manager; install rebuilt `.arz` and, where applicable,
`Text_EN.arc`; restart Custom Game. With the current defaults, test Guardian
limits, Flash Freeze at low/high ranks, native Arcanist buttons and the new
Sigil/Destruction pair using the linked Spellbinder checklist. Skeleton buttons
should remain absent. The optional skeleton summon/cap checks apply only after
disabling Sigil and explicitly re-enabling skeletons. Evaluate crowded-battle
performance when testing multiple active summons.

## Not in this pass

No changes to Inquisitor Vire's Might/Blade Spirit, no new Guardian
modifier line, no additional Aether conversion, no global spawn/XP
changes, and no modifications to the existing Nightblade or
Demolitionist skeleton configurations.
