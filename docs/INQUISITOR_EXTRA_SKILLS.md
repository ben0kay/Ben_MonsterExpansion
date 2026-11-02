# Inquisitor cross-mastery attachments — Vire's Might and Blade Spirit

**Target branch:** `dev`. **Status:** generator/config/UI integration committed;
focused Python tests authored, but **F7/in-game behavior not verified**.

## Branch and source-file provenance

The Inquisitor GDX1 UI records were uploaded to **`main`** in commit
`25c32486b9818e70cc3cc5b3eab224c8a4a71aba`, not `dev`. To avoid
merging potentially unrelated diverged history, the exact native
`ReferenceFiles/gdx1/database/records/ui/skills/class07/classtable.dbr`
was copied independently to `dev`. All 32 original class07 button positions
were audited from that upload. Other native class07 buttons remain game-owned
DLC assets, referenced unchanged by the modified panel. **No original button
is moved or rewritten**, and no new UI art resources are required.

## Requested skills

The user's requested "Ring of Steel (spawn whirring blades)" is implemented
as **Blade Spirit**, which summons persistent rotating blades. Ring of Steel
is a separate immediate circular Nightblade attack and is **not** cloned.

`config/inquisitor_extras.json` enables each skill independently:

| Feature | Native donor | Inquisitor cloned skill | New UI button | Position |
| --- | --- | --- | --- | --- |
| Vire's Might | `records/skills/playerclass09/viremight1.dbr` | `records/skills/playerclass07/ben_viremight1.dbr` | `records/ui/skills/class07/skill33.dbr` | (246, 459) |
| Blade Spirit | `records/skills/playerclass04/summon_bladespirit.dbr` | `records/skills/playerclass07/ben_summon_bladespirit.dbr` | `records/ui/skills/class07/skill34.dbr` | (886, 459) |

Existing Inquisitor tree slots 1–34 and original UI buttons remain intact.
New tree slots 35 and 36 register the clones, with no changed mastery
prerequisites. The native `skilltree.tpl` supports these indices.

### Vire's Might

This is the native Oathkeeper `Skill_AttackPathCharge` donor, with original
`Rush` animation, physical/trauma rank curves, FX and 3.6s cooldown. Only
the orphaned connector strips to Oathkeeper-specific modifiers are cleared,
as already done for the Demolitionist clone. **Other Oathkeeper modifier
skills are not added.**

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

The original class07 button positions were inspected for overlaps, including
the bottom-row native buttons at x406/x486/x646/x806 and the nearby
x246/y389 native button. New buttons fit at x246 and x886, y459;
visual alignment remains subject to in-game testing. If either edge
clips in-game, review the UI before repositioning native buttons.

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

## Future plans

The user has separately proposed attaching the entire Necromancer skeleton
line to **Arcanist**. This is **not part of this implementation** and
remains a future step requiring its own config and UI space review.
