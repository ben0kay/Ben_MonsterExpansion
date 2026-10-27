# Variant XP rewards

Enabled for all 148 Veterans, 124 Elites and 137 Ascended. Each generated monster
changes only its own `experiencePoints` input for this feature. Original enemy
DBRs, `giveXP`, classifications, global difficulty XP equations, player progression,
loot and spawn selections are untouched.

Each tier's `prototype.experience_reward.enabled` in `config/tiers.json` enables
this feature. It reuses `prototype.stats_vs_parent.health`: 1.30 Veteran, 1.30 Elite,
1.40 Ascended, relative to each exact Common/Champion/Hero parent respectively.
No separate per-enemy settings or enemy-specific generator branches are needed.

## Existing XP formula

`experiencePoints` is an integer input to XP calculation, not a flat XP payout.
The reference formula includes `(1 + monsterExperience / 100)`. To scale this
term by the HP multiplier, the generator writes:

`new experiencePoints = round_half_up((parent experiencePoints + 100) * health multiplier - 100)`

Examples: parent input 30 becomes 69 at 1.30; parent input 750 becomes 1090 at 1.40.
This is intentionally **approximate final XP**, since difficulty equations include
constants/exponents and the engine applies its own rules/rounding. It avoids the
much smaller increase that simply multiplying the raw input would produce.
Zero input is not necessarily zero XP under that formula; `giveXP` is the separate
eligibility flag and is always preserved. Invalid/overflowing DBR integer inputs
are rejected rather than silently truncated.

## Generate, build, rollback

Use the normal full README generate/stage/F7/install flow, with `--include-spawns`
to retain the combined mod. No new DBR paths or text assets are introduced.
Set a tier's `experience_reward.enabled` to false, regenerate/stage and rebuild
to restore that tier's exact original XP input while retaining its other bonuses.
An absent policy also preserves the parent XP input.

## Validation

Config validation passed. Three focused tests passed, including all 409 enabled
variants: generated output with/without the feature differs only at the monster's
experiencePoints field, and giveXP stays unchanged. The approved original boar
six-record hash fixture still passes with the XP policy disabled. Combined
full generation passed: 3,011 DBRs plus one text source, with unchanged file
counts. No in-game XP award is claimed as verified. Compare an original and variant at matching monster/player levels
in the same difficulty after rebuilding. The full historical test suite was not
rerun for this isolated change.
