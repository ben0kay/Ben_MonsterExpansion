# Custom-tier loot quality bonuses

**Branch:** `dev` · **Status:** configured and generator integrated, tests authored.
**Validation and F7/in-game item drops have NOT been run** in the GitHub-only
editing environment. These are relative **loot selection/rare-affix weight**
boosts, not exact guaranteed final item probabilities.

## Desired tier policy

`config/tiers.json` → `tiers[*].prototype.loot_rewards`:

| Custom tier | Original parent | Rare/green | Epic/blue | Legendary/purple |
| --- | --- | ---: | ---: | ---: |
| Veteran | Common | **+15%** | **+5%** | **×1** (no boost) |
| Elite | Champion | **+30%** | **+20%** | **+10%** |
| Ascended | Hero | **+50%** | **+30%** | **+15%** |

Only the three **generated custom variants** get these adjustments. Common,
Champion, Hero, Boss, Nemesis and other original monsters are unaffected.

The probability concepts use *relative* multipliers: if an eligible
equipment selection had a 10% Epic chance, a +20% multiplier targets
12%, **not 30%**. Final drops depend on the game's selection hierarchy,
equipped-item/drop eligibility, level, game difficulty, loot tables and
randomness.

## Native data and actual scope

Grim Dawn's native monster DBR contains weighted
`chanceToEquip[slot]Item[index]` entries referring to
`loot[slot]Item[index]` tables, *not* one
`rare/epic/legendaryChance` property. Master loot tables (MT) select
level tables (LT), which select weighted dynamic item/affix tables (TDYN).
Some monsters also have independent loot proxies/orbs.

The implementation (`scripts/tier_loot.py`) adds two **scoped**
mechanics to the existing `scripts/generate_variants.py` pipeline:

1. **Native rarity table weights:** For equipment master tables whose
   referenced gear category can be established and whose filename uses
   the game's `_bNN` (rare), `_cNN` (epic) or `_dNN`
   (legendary) convention, adjust **only the generated monster**
   `chanceToEquip…Item…` weights. Preserve normal and non-gear
   selection categories; use calibrated relative weight ratios and
   100× integer precision to limit rounding losses. When no matching
   rarity table exists, leave that rarity unchanged; do not inject a
   guaranteed drop.
2. **Green rarity via rare affixes:** Ordinary `_aNN` equipment
   master tables do not necessarily have a separately selectable green
   table. The game instead makes many green items via rare prefixes
   and/or suffixes on ordinary bases. For supported native
   `lootitemtable_dynweighted_dynaffix.tpl` records, generate private
   tier-specific MT → LT → TDYN clones and adjust existing rare-affix
   combination weights relative to nonrare outcomes. Redirect only
   the *custom enemy's* corresponding ordinary gear source to that
   private chain. This is a **rare-affix roll boost**, not a universal
   proven +15%/+30%/+50% final green-item probability.

**Important limitations** (intentional safety restrictions):

- Do not modify the shared original/expansion master, level or dynamic
  tables. That would give **all vanilla enemies** the boost.
- Do not change the monster's `monsterClassification` (which would affect
  unrelated loot and UI behaviour).
- Do not alter `treasureProxyName` or the separate Hero/boss **loot
  orb/chest drops**. Those remain vanilla and are **not boosted** by
  this pass. Thus final Ascended Epic/Legendary returns may be less than
  the target relative increases if the parent mainly rewards via orb.
- Do not reweight components, crafting materials, potion/constitution,
  quest-specific items, Monster Infrequent guaranteed drops or
  unrecognised source templates.
- If a native monster has no compatible equipment source (or the
  `_aNN` table lacks a supported rare-affix graph), the unsupported
  bonus is skipped rather than creating bogus records. A 0% chance
  remains zero. The generator reports these cases.

The working example is the original `boar_a01.dbr`:
`lootMisc2Item1` is the ordinary `mt_beast_small_a01` equipment
table, `lootMisc2Item2` is Epic `mt_beast_small_c01`,
`lootMisc2Item3` is Legendary `mt_beast_small_d01`. The component
tables in `lootMisc1` and potion table in `lootMisc2Item4` are
left in place. An ordinary equipment table is cloned down to its
supported rare-affix dynamic item tables and redirected only for
the **Veteran clone**.

## Generation and coverage

The generator writes private support DBRs under

`database/records/items/loottables/monsterexpansion/<tier>/<hash>.dbr`

and the cloned monster's original
`database/records/creatures/enemies/monsterexpansion/*.dbr`.
Identical support DBRs are deduplicated across custom variants only
if their content matches byte-for-byte; all other path collisions still
fail loudly.

`generated/MonsterExpansion/manifest.json` contains
`loot_coverage` for each tier:

- `variants`: all configured active variants generated for that tier.
- `rare_affix_graph`: how many generated variants redirect at least
  one ordinary equipment source to tier-specific private affix tables.
- `equipment_weights`: how many variants have at least one modified
  equipment rarity-choice set.
- `no_effective_path`: how many variants have **neither**, and
  therefore gain no effective bonus from this first-pass data model.

Do not imply every variant receives all three bonuses until coverage
and in-game item distributions have been measured; tiers with fewer
original loot sources cannot receive a guaranteed increase.

## Rollback

Set `loot_rewards.enabled=false` for a tier in
`config/tiers.json`, then regenerate and **replace staged** files,
and rebuild F7. The corresponding custom monster actor returns to its
exact native loot field values. Previously generated, unused private
support DBRs can remain in the staging area but are no longer linked
from any actor when disabled; they will not affect ordinary monsters.
If desired, manually clear those now-unreferenced generated custom
loot support paths during a safe cleanup after verifying rollback.

## Focused validation and build

From the repository root:

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python -m unittest discover -s tests -p "test_tier_loot.py" -v
python -m unittest discover -s tests -p "test_data_driven.py" -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Then F7 in Asset Manager, install the freshly built ARZ and test
multiple monsters per tier and difficulty over a meaningful sample.
Check the `loot_coverage` manifest; record whether the intended
higher-tier enemies visibly reward more high-quality drops. The
compiled ARZ and observed drop rates are **not yet verified**.
