# Global monster XP multiplier

**Branch:** `dev`. **Status:** configured and integrated in generator,
focused regression tests authored; Python tests and Asset Manager F7/in-game
effects have not been run or verified in this GitHub-only session.

## Configuration

In `config/master.json`:

```json
{
  "schema_version": 1,
  "monster_spawning": {
    "enabled": true,
    "pack_size_multiplier": 2
  },
  "global_xp": {
    "enabled": true,
    "multiplier": 1
  }
}
```

Change `global_xp.multiplier` independently of the pack-size multiplier:

| Multiplier | Result |
| --- | --- |
| `0.5` | Half of the native monster-kill XP formula output |
| `1` | Vanilla monster-kill XP formula output (current default) |
| `1.5` | 50% higher monster-kill XP formula output |
| `2` | Double monster-kill XP formula output |
| `3` | Triple monster-kill XP formula output |

Validation accepts finite numbers **greater than 0, up to 10**. Set
`enabled:false` or `multiplier:1` to restore the **exact original DBR**.

## Implementation and scope

The game engine points to
`records/game/experienceformulas.dbr` using its `experienceRecord`
field. The original `database/templates/experienceformulas.tpl` has four
monster XP equations:

- `experienceEquation` (normal)
- `challengeExperienceEquation` (challenge)
- `eliteExperienceEquation` (elite difficulty)
- `ultimateExperienceEquation` (ultimate difficulty)

`scripts/global_xp.py` resolves the effective original record
(GDX2 > GDX1 > base), verifies the template and native formula variables,
and changes **only** those four equation fields when the multiplier is
enabled and is not 1. Each native equation `E` becomes `(E) * multiplier`.
The outer multiplication preserves the native level scaling, difficulty
modifiers, additive constants and exponent calculations before applying
the global factor.

The feature does **not** change:

- XP earned from quests or other non-monster rewards.
- `deathPenaltyEquation`, death penalty bounds or redemption multiplier.
- Player XP requirements / level-up thresholds.
- `giveXP` eligibility or individual monster level.
- Tier-specific Veteran, Elite and Ascended `experiencePoints` overrides.
- Monster spawn density, tier chances, loot or skill/attribute rewards.

**Interaction with variant XP:** The existing tier policy modifies the
individual variant's `monsterExperience` input based on tier health.
The **global** multiplier then applies to the final output of the same
difficulty equation for all eligible monster kills, including original
enemies and variants. With `multiplier:1`, nothing new is added to the
tier-specific rewards. Because the variant policy targets a multiplicative
term *inside* an equation with additive/difficulty terms, exact observed
XP ratios can differ from the tier health ratios.

## Build, validation and exact rollback

The normal generator includes this XP DBR independently of
`--include-spawns`. It always writes the formula record, including the
exact native contents at `enabled:false` or `multiplier:1`, to undo a
previously compiled global bonus. The normal manifest includes
`global_xp` and the formula DBR path.

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python -m unittest discover -s tests -p test_global_xp.py -v
python -m unittest discover -s tests -p test_global_spawns.py -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Build the custom mod with **F7** in Grim Dawn Asset Manager, install
the rebuilt archive, restart the Custom Game, then compare XP gained
from the same monster/player levels on the same difficulty with XP x1 vs x2.
Do not treat formula checks as proof of the in-game reward.

To turn the multiplier off later, set `global_xp.enabled` to `false`,
regenerate with `--replace-generated`, stage with `--replace-staged`,
and rebuild F7. Simply editing JSON without rebuilding has no effect.
