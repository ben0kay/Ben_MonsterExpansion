# Inquisitor cross-mastery attachments — Vire's Might and Blade Spirit

**Target branch:** `dev`. **Status:** generator/config/UI integration committed;
focused Python tests authored, but **F7/in-game behavior not verified**.

## Branch and source-file provenance

The Inquisitor GDX1 UI records were uploaded to **`main`** in commit
`25c32486b9818e70cc3cc5b3eab224c8a4a71aba`, not `dev`. To avoid
merging potentially unrelated diverged history, the exact native
`ReferenceFiles/gdx1/database/records/ui/skills/class07/classtable.dbr`
was copied independently to `dev`. All 32 original class07 button positions
were audited from that upload. The user's November 2 in-game screenshot
showed a mismatch: native mastery-10 Vire's Might was visually placed in
the mastery-1 column. The new placement moves just one native circular
transmuter button in addition to the Vire's Might button; no original
skill record or UI art resources are changed.

## Requested skills

The user's requested "Ring of Steel (spawn whirring blades)" is implemented
as **Blade Spirit**, which summons persistent rotating blades. Ring of Steel
is a separate immediate circular Nightblade attack and is **not** cloned.

`config/inquisitor_extras.json` enables each skill independently:

| Feature | Native donor | Inquisitor cloned skill | New UI button | Position |
| --- | --- | --- | --- | --- |
| Vire's Might | `records/skills/playerclass09/viremight1.dbr` | `records/skills/playerclass07/ben_viremight1.dbr` | `records/ui/skills/class07/skill33.dbr` | **(486, 39)** |
| Blade Spirit | `records/skills/playerclass04/summon_bladespirit.dbr` | `records/skills/playerclass07/ben_summon_bladespirit.dbr` | `records/ui/skills/class07/skill34.dbr` | (886, 459) |

Existing Inquisitor tree slots 1–34 and original UI buttons remain intact.
New tree slots 35 and 36 register the clones, with no changed mastery
prerequisites. The native `skilltree.tpl` supports these indices.

### Vire's Might

This is the native Oathkeeper `Skill_AttackPathCharge` donor, with original
`Rush` animation, physical/trauma rank curves, FX, **mastery-10**
requirement and 3.6s cooldown. Only the orphaned connector strips to
Oathkeeper-specific modifiers are cleared, as already done for the
Demolitionist clone. **Other Oathkeeper modifier skills are not added.**

**November 2 correction:** the player verified in game that Vire's Might's
previous `(246,459)` button appeared in the mastery-1 column, although
the tooltip correctly required nine more Inquisitor mastery points. The
button is now `(486,39)`: top row, directly right of Bursting Round
(`class07/skill25`, `326,39`) and left of Chilling Rounds
(`class07/skill26`, `566,39`). This matches the 10-point mastery bar.

The nearby original circular **Word of Renewal transmuter**
(`class07/skill30.dbr`, referring to `hunteraura1b.dbr`) must move
from `(486,71)` to `(486,145)` to clear the overlap. Its associated
skill, requirements, art and all other fields are untouched. This is an
audited UI-only move and is restored exactly when Vire's Might is disabled.
The adjusted transmuter/connector appearance should still be checked
in-game. No other Inquisitor buttons are moved.

### Blade Spirit

`scripts/inquisitor_attachment.py` consumes the **already generated**
Nightblade skill from `config/player_skills.json` instead of re-reading
an unmodified donor or duplicating its stat tables. The Inquisitor clone
therefore inherits the Nightblade's current `petLimit` and
`petBurstSpawn` rank curves:

- Ranks 1–15: spawn/limit **2**.
- Ranks 16–23: spawn/limit **4**.
- Ranks 24–26 (overcap): spawn/limit **5**.

It also references the same native Blade Spirit pets, preserving their
existing lifetime/invulnerability, combat skills, damage scaling and
effects. A separately modified pet actor is **not** introduced.
Because two mastery skill records can summon the same actor type,
any shared game-engine pet accounting and maximum behavior still
requires actual in-game verification.

## Generator, rollback, conflicts

The existing `scripts/generate_variants.py` generates both the original
Inquisitor tree/UI overrides and two clone/button pairs; this works with
or without `--include-spawns`. It composes with existing Nightblade and
Demolitionist skeleton and Vire's Might attachments, without editing those.

The `enabled` flag of either entry in
`config/inquisitor_extras.json` removes just that skill from the
Inquisitor skill tree and button list. The other remains available and
occupies the first free added tree slot. With both disabled (or
top-level `enabled:false`), generator emits the exact native tree and
panel DBRs, reversing previous versions when rebuilt. New unused
clone/button DBRs may remain staged but are unreferenced.

The original class07 button positions were inspected for overlaps. The
top-row placement at `(486,39)` requires the one original circular
transmuter move described above; with that move, all original and
added buttons clear the 60-pixel proximity check. Blade Spirit still
fits at `(886,459)`. A new focused regression test checks exact native
rollback of `skill30.dbr` when Vire's Might is disabled. Verify
the visible spacing and transmuter/connector orientation in game
after rebuilding.

## Run the focused test and rebuild

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python -m unittest discover -s tests -p test_inquisitor_attachment.py -v
python -m unittest discover -s tests -p test_inquisitor_balance.py -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Then build with **F7** in Grim Dawn Asset Manager, install rebuilt `.arz`
and `Text_EN.arc` as needed, restart the Custom Game and verify both new
Inquisitor skill buttons. The Python tests and in-game behaviour have
**not** been run in this GitHub-only environment.

## Related Arcanist summon addition

The independent Arcanist configuration now attaches the Necromancer
three-skill skeleton line **and** native Guardian of Empyrion.
It has a separate generator, UI layout and toggle set; the Inquisitor
Vire's Might/Blade Spirit implementation is unchanged.
See [Arcanist summon attachment and rollback](ARCANIST_SUMMONS_BUILD.md).
