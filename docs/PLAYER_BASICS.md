# Player starting stats, movement cap and default camera distance

## Enabled overrides
`config/player_basics.json` exposes independently enabled settings for:
- Starting base health and energy: **250 → 300** each, in male and female player DBRs.
- Maximum player movement-speed bonus: **135% → 145%**, in `gameengine.dbr`.
- Default camera distance: **36 → 39**, in `gameengine.dbr`.

The earlier **+15% base run speed** setting is preserved. Both player modifications
are composed into the same two character records, avoiding conflicting DBR outputs.
These are base life/energy fields; displayed totals may include progression and other stats.

## Camera behaviour
The camera can still be zoomed manually in-game using the mouse wheel, with
the usual Num 1 (maximum in), Num 3 (maximum out) and Num 2 (default view)
key bindings. This mod changes only the default camera distance to 39:
the original zoom limits `CameraDistanceMin=20` and
`CameraDistanceMax=48` remain unchanged. A saved camera position could
override the default until the view is reset, so confirm it in-game.

Each section has an `enabled` flag. Disabling a section emits original DBR
field values on the next full build; the independent base movement setting
remains applied. Do not remove a config entry to roll back old compiled DBRs.

## Build and playtest
```powershell
git pull
python scripts/validate_config.py
python -m unittest discover -s tests -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```
Then build with F7 in Grim Dawn Asset Manager, install the new mod `.arz`,
and restart the Custom Game. Keep the `Text_EN.arc` for existing custom labels.
Test a fresh character of each sex, camera zoom/reset, and movement-speed
bonuses above the old 135% cap. Changes to GitHub source do not build or
install a playable archive automatically.
