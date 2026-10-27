# Planned: Raise Skeletons skill line for Nightblade (SK0–SK5)

**Status:** proposal / NOT IMPLEMENTED. **Target branch:** `dev` only (do not push to `main`).
**Player build:** Nightblade + Occultist. **Scope:** add the complete native Necromancer Raise Skeletons line **to Nightblade**, not Arcanist. No existing Nightblade, Occultist, or Arcanist skills are to be replaced, removed, or retuned by this work.

## Design contract

- Preserve the original Necromancer Raise Skeletons gameplay: initial summon burst/limit, pet variants, their original rank- and level-scaling, modifiers, cost, cooldown, animations, UI icons, sounds, visual effects, requirements and vanilla text. Use game-provided DLC resources whenever possible; do not fork the skeleton pets unless a proven class-binding dependency makes it necessary.
- Add **three separately investable Nightblade skills**: Raise Skeletons (base skill), Undead Legion (the `summon_skeleton2` modifier), and Will of the Crypt (the `summon_skeleton3_petmodifier` pet modifier). Confirm game-visible names using the original DLC text tags; do not invent tag names. They should behave as the unmodified Necromancer originals.
- Keep all existing Nightblade entries and coordinates. Make new additions deterministic, opt-in/rollback capable, DLC-aware and staged with the normal combined monster + skill generator. Do not directly edit `ReferenceFiles/`.
- Protect previously customized Nightblade balance, Occultist, Arcanist, monster-tier, pack, Devotion and player-stat changes. No extra buff to skeletons in this task. Future Nightblade balance pass is separate.

## Confirmed reference inputs

| Purpose | Reference path |
| --- | --- |
| Nightblade skill tree | `ReferenceFiles/skills/playerclass04/_classtree_class04.dbr` |
| Nightblade skill GUI | `ReferenceFiles/ui/skills/class04/classtable.dbr` and `skill01.dbr` through `skill31.dbr` |
| Necromancer base summon | `ReferenceFiles/gdx1/database/records/skills/playerclass08/summon_skeleton1.dbr` |
| Necromancer Undead Legion | `ReferenceFiles/gdx1/database/records/skills/playerclass08/summon_skeleton2.dbr` |
| Necromancer Will of the Crypt | `ReferenceFiles/gdx1/database/records/skills/playerclass08/summon_skeleton3_petmodifier.dbr` |
| Existing skeleton pets and abilities | `ReferenceFiles/gdx1/database/records/skills/playerclass08/pets/` and effective GDX2 overrides |
| Existing Raise Skeletons FX | `ReferenceFiles/gdx1/database/records/fx/skillclass08/` |
| Templates | `ReferenceFiles/Resources/templates/skilltree.tpl`, `ReferenceFiles/Resources/templates/ingameui/skillpanectrl.tpl` |
| Generation/staging | `scripts/player_skills.py`, `scripts/generate_variants.py`, `scripts/prepare_console_test.py`, `scripts/validate_config.py` |

Current Nightblade `_classtree_class04.dbr` has **35** named entries (1 mastery bar + 34 indexed skills/links); the shared template provides fields through `skillName60` / `skillLevel60`. The Nightblade `classtable.dbr` has **32 UI references** (1 mastery bar + 31 skill buttons). These counts do **not** prove that three additional UI buttons fit or render. The tree also repeats `wpattack4.dbr` at several existing indexes; preserve these entries and do not renumber to 'clean up' the vanilla layout. Nightblade now has a **separate implemented balance pass** in `config/player_skills.json` (see [Nightblade balance](NIGHTBLADE_BALANCE.md)). SK0–SK5 must preserve and compose with those existing `playerclass04` records rather than overwriting them.

## SK0 — read-only discovery, compatibility gate

1. Resolve each effective Necromancer skill record (GDX2 > GDX1 > base) and enumerate all `spawnObjects*`, `petSkillName`, icon, animation, FX and transitive pet-skill dependencies; validate that a local Ashes of Malmouth + Forgotten Gods installation supplies the referenced DLC resources.
2. Read original Necromancer skill tree and skill modifier relationships. Confirm that copying skills into playerclass04 while continuing to reference the original playerclass08 pet records gives the intended modifier propagation, correct rank scaling and independent Necromancer functionality. Identify any hard-coded class linkage.
3. Inspect Nightblade `skilltree.tpl`, `skillpanectrl.tpl`, `classtable.dbr` and all 31 Nightblade button records; map actual button coordinates. Verify room, template fields, button array capacity, and candidate placements. **The schema's 60 slots are not runtime proof.** Do not silently overlap existing buttons.
4. Stop with a documented blocker if the game/Asset Manager requires unavailable assets or if the new line cannot appear without replacing existing skills.

**Gate:** produce a short dependency and UI placement report before SK1. The remaining phases are conditional on this check; if uncertain, favor a one-skill in-game proof-of-concept over extensive speculative changes.

## SK1 — data-driven skill cloning

- Extend the existing pipeline (or add a compact dedicated module) to clone the *effective* vanilla Necromancer skill records into uniquely named custom Nightblade records, e.g. `records/skills/playerclass04/ben_raiseskeletons1.dbr`, `ben_raiseskeletons2.dbr`, `ben_raiseskeletons3_petmodifier.dbr`. Use a separate `config/nightblade_skeletons.json` opt-in flag so the feature can be independently disabled.
- Only adjust fields necessary for the Nightblade attachment and tested internal references. **Do not change** native skill `petBurstSpawn=3`, `petLimit=3`, `skillCooldownTime=18` on the base ability, 16/26 rank progression, the 12/22 modifier rank progression, original energy costs or skeleton class/abilities.
- Preserve original skeleton `spawnObjects*` references and FX paths where these work. For the third skill, check the original `petSkillName` and its rank-link behavior; add the smallest possible extra override only if proven necessary.
- Validate no unintended damage/timer/pet-stat/AI or other record differences. Avoid duplicating or packaging the entire reference tree.

## SK2 — Nightblade mastery tree integration

- Build an output override for `database/records/skills/playerclass04/_classtree_class04.dbr` from its effective original.
- Tentatively append the three new records to **`skillName36`, `skillName37`, `skillName38`** with their matching `skillLevel36–38`, once SK0 verifies these work; keep all original 1–35 mappings and metadata intact.
- Retain original Necromancer prerequisite/mastery tier behavior as closely as the Nightblade layout permits; verify that modifier ranks attach to the intended base summon, rather than altering existing Nightblade skills.
- Treat unsupported game hard limits as a stop-and-report blocker, **not** permission to replace a vanilla skill.

## SK3 — visible Nightblade skill UI

- Emit Nightblade-specific `records/ui/skills/class04/skill32.dbr`, `skill33.dbr`, `skill34.dbr` (or next confirmed unused filenames), using existing Nightblade UI records as donors.
- Add the new button paths to a generated `database/records/ui/skills/class04/classtable.dbr` while leaving all existing button paths in their original order.
- Choose non-overlapping in-bounds coordinates based on the actual current layout. Use vanilla Raise Skeletons icons and game-provided English localization tags; do not ship speculative art or duplicate resource textures.
- Check that base skill and both modifiers visibly connect, display the correct prerequisites, accept skill point allocation, and can be placed on a hotbar. UI placement may require layout review/in-game correction.

## SK4 — integration and rollback

- Wire skill copies, Nightblade tree override, UI buttons and manifest counts into the normal effective-DLC validation, generation, preflight and staging pipeline, **including** combined `--include-spawns` runs.
- Make disabled mode emit/restore the **exact effective vanilla Nightblade tree/UI records** (or remove new-only outputs from the staging manifest) so stale staged DBRs cannot linger; document required replacement-stage and rebuild steps.
- Ensure no collision with existing `config/player_skills.json`, other class files or generated output paths. Keep paths relative and Windows-safe.
- Do not stage extracted DLC content or overwrite reference inputs.

## SK5 — lightweight test and gameplay handoff

- Add focused tests for all three outputs, original vs cloned field parity, valid dependency paths, slot/button membership, preserved original Nightblade records, preservation of existing Occultist/Arcanist changes, duplicate-path protection, manifest and rollback. Run only relevant tests plus config validation unless a failure warrants more.
- Document a manual Asset Manager F7 build and in-game check: select Nightblade + Occultist; find and invest in Raise Skeletons; cast, observe three skeletons; check native summon cap and energy/cooldown; invest in Undead Legion and Will of the Crypt; verify rank/limit/cooldown and effects; check vanilla Nightblade skills, Occultist pets, no broken icons or overlaps; verify disabled rollback. Verify Necromancer remains unaffected in a separate character.
- Build guidance from repo root:
  ```powershell
  git switch dev
  git pull
  python scripts/validate_config.py
  python -m unittest tests.test_player_skills -v
  python scripts/generate_variants.py --include-spawns --write --replace-generated
  python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
  ```
  Then F7 in Grim Dawn Asset Manager, install the rebuilt `.arz` (and `Text_EN.arc` where applicable), and test a custom game.
- Update README and documentation with truthful validation status, a short changes list, and the commit SHA. **Push to `dev` only**, with minimal testing as preferred.

## Additional reference files

No **mandatory** missing `.dbr` reference files were identified in the current audit: the base Necromancer skills, skeleton pets, skill FX, Nightblade skill tree/UI records and both templates are present. Optional: the **GDX1 Necromancer class08 UI skill-panel/button records** (e.g. `records/ui/skills/class08/`) if available from your local extraction; they help reproduce the original skeleton-line placement. If SK0 uncovers missing DLC text, texture/animation assets or hard-coded bindings, report the exact filenames instead of guessing.

## Future balance pass (not part of SK0–SK5)

Nightblade has an **implemented, separate** rank-preserving balance pass in `config/player_skills.json` (see [Nightblade balance](NIGHTBLADE_BALANCE.md)). Keep those existing improvements intact during SK0–SK5. Further tweaks to Amarasta's Blade Burst, modifiers, or other skills should be proposed and approved separately.
