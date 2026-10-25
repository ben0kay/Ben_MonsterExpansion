# Devotion rewards and cap

Requested: **2 Devotion points per restored shrine, 85 total maximum**.
Implementation is prepared but **disabled**, because the uploaded references
contain no GDX1/GDX2 `interactive` folders. Current playable output retains vanilla
Devotion rewards and cap; attributes and all monster features remain active.

## Configuration

`config/player_stats.json`:

```json
"devotion": {
  "enabled": false,
  "points_per_shrine": 2,
  "max_points": 85,
  "required_reference_layers": ["base", "gdx1", "gdx2"]
}
```

Attribute and Devotion switches are independent. The existing attribute settings
remain 2 points per level and +6 per spent point. Devotion's `max_points` modifies
`maxDevotionPoints` in the effective DLC `records/creatures/pc/playerlevels.dbr`;
there is no invented per-level Devotion field or deprecated gameengine cap override.

## Missing inputs and activation

Upload the full extracted AoM and FG `interactive` folders to:

```text
ReferenceFiles/gdx1/database/records/interactive/
ReferenceFiles/gdx2/database/records/interactive/
```

Preserve their extracted subfolders and filenames. A few sample records cannot
establish full coverage. The generator requires rewarding shrine records in each
configured layer; that gate prevents a missing whole DLC batch from silently
falling back to base. It does not prove an uploaded batch is complete.

Once both full batches are available, verify coverage, change `enabled` to `true`,
and use the usual build commands:

```powershell
python scripts/validate_config.py
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Then F7, install the rebuilt mod `.arz`, keep the existing Text_EN.arc and restart
Custom Game. New output counts depend on the supplied shrine records; no active
Devotion build totals are claimed yet. All monster, pack-size and attribute
features generate together. JSON settings require rebuilding; they are not live.

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

Seven focused tests cover reward-only edits, DLC precedence, preserving blank/
zero-reward shrines, missing-reference and symlink rejection, independent attribute/
cap composition, rollback and inclusion in the generated manifest. Four existing
attribute tests cover the still-active progression settings.

After activation, verify a fresh shrine gives +2 and the UI shows an 85 cap.
Specifically check a character at 84 points: cap clamping at the odd boundary
requires game verification. Previously completed shrines are not explicitly
compensated; there is no save-edit or retroactive reward mechanism. The earlier
one-point-every-seven-levels proposal remains unimplemented.
