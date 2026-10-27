# Player starting stats, movement cap and default camera distance

## Enabled overrides
`config/player_basics.json` exposes independently enabled settings for:
- Starting base health and energy: **250 → 300** each, in male and female player DBRs.
- Maximum player movement-speed bonus: **135% → 145%**, in `gameengine.dbr`.
- Default camera distance **36**, with maximum zoom-out **48** (both original values).

The earlier **+15% base run speed** setting is preserved. Player movement
and starting stats are composed into the same two character records. The
independent **maximum level 150** setting from `config/player_stats.json`
is applied to those already-composed actor DBRs **last**, changing only
`maxLevel` and avoiding duplicate DBR outputs. See
[Player level cap](PLAYER_LEVEL_CAP.md).
These are base life/energy fields; displayed totals may include progression and other stats.

## Camera behaviour
The camera can still be zoomed manually in-game using the mouse wheel, with
the usual Num 1 (maximum in), Num 3 (maximum out) and Num 2 (default view)
key bindings. The default camera distance is now **36** (restored after a
brief 39 setting). The zoom limits `CameraDistanceMin=20` and
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
