# Devotion rewards and cap

**Enabled: 2 Devotion points per restored shrine, 85 total maximum.**
The uploaded base/AoM/FG references resolve to **60 rewarding shrine records**.
The combined mod emits **2,973 DBRs + 1 text source**, plus its manifest.
All existing monster tiers, pack-size and attribute changes remain included.
Runtime behavior remains unverified.

## Configuration

`config/player_stats.json`:

```json
"devotion": {
  "enabled": true,
  "points_per_shrine": 2,
  "max_points": 85,
  "required_reference_layers": ["base", "gdx1", "gdx2"]
}
```

Attribute and Devotion switches are independent. The existing attribute settings
remain 2 points per level and +6 per spent point. Devotion's `max_points` modifies
`maxDevotionPoints` in the effective DLC `records/creatures/pc/playerlevels.dbr`;
there is no invented per-level Devotion field or deprecated gameengine cap override.

## Reference coverage and build

The required base, AoM and FG `interactive` references are now present. Physical
layer counts are 30 / 6 / 56 rewarding records; overlapping logical paths resolve
to 60 effective shrines using GDX2 > GDX1 > base priority. The coverage guard
remains enabled so a missing DLC batch cannot silently fall back to base.
Counts describe the uploaded extraction, not proof of every possible shrine or map.

Build with:

```powershell
git pull
python scripts/validate_config.py
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Then F7, install the rebuilt mod `.arz`, keep the existing Text_EN.arc and restart
Custom Game. Expect **2,973 DBRs + 1 text source**. JSON edits require rebuilding;
they are not live settings. All features generate together.

## Supported changes and preservation

The generic shrine generator scans logical `records/interactive/...` paths with
GDX2 > GDX1 > base priority and selects only `staticshrine.tpl` records with a
positive `devotionPoints` value. Only that reward field changes. Shrine costs,
loot, XP, animations, quests and difficulty gates are retained from each effective
source. Blank, decorative and zero-reward quest shrines are left unchanged;
Mogdrogen's uploaded zero-reward shrine is not turned into a point source.

The player generator composes the cap with the existing attribute changes in one
DBR; it does not overwrite the other settings. Level cap, skill points and XP
progression remain unchanged. References and saved characters are never edited.

On complete references, setting `enabled=false` emits exact vanilla shrine
records and restores the effective vanilla Devotion cap while retaining attribute
changes. Regenerate/stage/build/install the full catalog for rollback. If the
reference batches are missing, a disabled feature emits no shrine overrides;
that pending state cannot remove previously compiled shrine overrides. Keep the
references for rollback. Removing a config does not clean stale compiled DBRs.

## Verification

**77 combined Python tests pass**. Generation and staging preflight pass. Devotion changes only the 60 shrine reward
fields and the player-level cap. Existing monster, pool, pack and 80 player-skill
overrides are preserved.

Eight Devotion tests cover real uploaded shrine preservation and reward-only edits, DLC precedence, preserving blank/
zero-reward shrines, missing-reference and symlink rejection, independent attribute/
cap composition, rollback and inclusion in the generated manifest. Four existing
attribute tests cover the still-active progression settings.

After activation, verify a fresh shrine gives +2 and the UI shows an 85 cap.
Specifically check a character at 84 points: cap clamping at the odd boundary
requires game verification. Previously completed shrines are not explicitly
compensated; there is no save-edit or retroactive reward mechanism. The earlier
one-point-every-seven-levels proposal remains unimplemented.
