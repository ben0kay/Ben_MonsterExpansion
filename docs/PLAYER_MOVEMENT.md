# Player movement speed: +15% base (configured)

## Active setting

`config/player_movement.json` enables a base running speed multiplier of
`1.15` for **both** the male and female player character DBRs:

- `records/creatures/pc/malepc01.dbr`
- `records/creatures/pc/femalepc01.dbr`

Their effective DLC records (GDX2 > GDX1 > base) both specify
`characterRunSpeed,0.930000,`. Generated overrides change **only**
that field to `characterRunSpeed,1.069500,` (exactly 15% above 0.93).
By itself, the movement generator changes only run speed. The combined build
composes the separately configured starting health/energy (250 to 300) into
the same player records without altering class, scale or animations. Only source DBRs are read; generated files
are staged inside the custom mod rather than changing original game archives.

This is **base run-speed**, not a +15 percentage-point skill/equipment bonus.
The independently configurable `config/player_basics.json` raises
`playerRunSpeedCapMax` from 135 to 145 in the game-engine record, without
altering the base run-speed multiplier. Actual displayed
character-sheet values, stacking with gear, animation smoothness and
engine movement behaviour still require a game test.

## Tuning

Change `base_run_speed_multiplier` in `config/player_movement.json`:

| Multiplier | Result from effective DLC 0.93 | Compared to vanilla |
| ---: | ---: | ---: |
| 1.0 | 0.930000 | Unmodified |
| 1.10 | 1.023000 | +10% |
| 1.15 | 1.069500 | +15% (active) |
| 1.20 | 1.116000 | +20% |
| 1.30 | 1.209000 | +30% |

Allowed values: finite numeric 0.5–2.0, no strings or booleans.
Set `enabled: false` to generate the exact vanilla DLC records for **both**
sexes (rollback). Do not simply remove this config to roll back because a
previously compiled mod might still retain the old player overrides.

Camera default distance is also configured to 39 while preserving zoom 20–48.
See [player basics](PLAYER_BASICS.md) and [tunable parameters](TUNABLE_PARAMETERS.md).

## Build and verify

From the repository, run:

```powershell
git pull
python scripts/validate_config.py
python -m unittest discover -s tests -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Build with F7 in Asset Manager, install the newly built `.arz` (and
`Text_EN.arc` for Veteran labels), restart the Custom Game and compare
movement on a new/test character without gear or movement buffs.
Check both character sexes and with/without movement-speed gear.
The changes in GitHub are generation-source changes; they do not
compile/install the mod automatically. No in-game verification is claimed.
