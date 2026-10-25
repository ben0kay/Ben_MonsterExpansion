> **Current catalog (October 25):** 148 Veterans + 124 Elites + 137 Ascended, 377 merged pools;
> **2,973 DBRs + 1 text source**. See [Elite pipeline](ELITES.md) for Champion rules,
> [Ascended quota policy](ASCENDED.md) and the current README for status. The original boar/zombie examples below remain valid.

> **Name-label update:** Zombie names now generate as `Walking Dead (Veteran)` via one additional text source. Build its asset and install the mod's Text_EN.arc as well as the .arz: [name-label instructions](VETERAN_NAMES.md). A Veteran zombie has now been observed naturally in an early Lower Crossing house. Other coverage and frequency remain unmeasured.

# Config-driven families — boars and starting zombies

October 19, 2026. Python checks pass; new variants and updated pools need a new
Asset Manager build and in-game test. The original Veteran Boar's six generated
DBRs match the approved version byte-for-byte (regression fixture in tests).

## Build and install

In your local `Working/mods/Ben_MonsterExpansion` repository:

```powershell
git pull
python scripts/validate_config.py
python -m unittest discover -s tests -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Default selection is **all enabled families**. Expect **2,973 DBRs + 1 text source**
plus the generated manifest: 409 variants with six DBRs each, 377 merged pool
overrides, 60 Devotion shrine records, 80 player-skill overrides, the global pack equation and player progression override. F7 in Asset
Manager with the custom mod selected; install the rebuilt `.arz`, retain/install
its Text_EN.arc for custom zombie labels, and restart the Custom Game.

Use the same options for generation and staging. `--family boar` or
`--family zombie` restricts either command to one family. Restricted selection
and omitting `--include-spawns` do NOT delete previously staged/compiled output.
The manifest is checked against freshly regenerated config output; it is not
trusted to authorize arbitrary paths.

## Direct tests

```text
game.Spawn "records/creatures/enemies/monsterexpansion/zombie_veteran_starter_01.dbr"
game.Spawn "records/creatures/enemies/monsterexpansion/zombie_veteran_01.dbr"
game.Spawn "records/creatures/enemies/monsterexpansion/boar_veteran_02.dbr"
```

The existing `boar_veteran_01.dbr` command still works. Zombie variants retain their vanilla classifications but display `Walking Dead (Veteran)`
when the new text archive is installed; identify Veterans by the green glow,
size and matching-level HP comparison. The starter zombie uses its own weaker
vanilla bio; it is not replaced by the stronger normal zombie's stat baseline.
Stats remain +30% health, +8% defensive ability, +10% physical base-damage passive
and +10% model scale. This is not a guaranteed +10% final outgoing damage.

## Pool tests without searching the map

```text
game.Spawn "records/proxies/area001/zombie_e.dbr"
game.Spawn "records/proxies/area001/zombie_el_20m_health.dbr"
game.Spawn "records/proxies/area001/zombie_n.dbr"
game.Spawn "records/proxies/area001/beasts_boar_n.dbr"
```

The boar proxy method was tested by the user and selected the glowing custom
Veteran. These zombie proxy commands use real uploaded proxy records, but their
console activation remains untested. Proxy chanceToRun may result in no pack;
repeat several times. A pack without a Veteran is normal. A console-spawned
monster alone is not a pool test.

Try a fresh level-1 character/session near the game's starting zombie encounters.
These are reviewed early zombie DBRs, not a claim that every map placement uses
them: the repository does not supply inspected opening-world placement data.
Report the area and build log if direct spawns work but no natural Veterans appear.
Do not force tiers into quest bosses/summons to make a test easier.

## Config structure

- `config/tiers.json`: shared health/damage/defense/size defaults, approved glow
  preset and `natural_spawns.common_conversion_share=0.2` for Veteran.
- `config/families/*.json` schema 2: family enabled flag, `variants` and `pools`.
- Each variant: unique id, tier id, actual source monster, expected classification,
  namespaced output path and the assigned physical-damage skill to clone.
- Each pool: exact vanilla pool path, enabled flag, evidence proxies and promotions.
- Each promotion: `source_slot`, variant id and unused `output_slot`. Slot level
  variance and min/max player levels are inherited. Mismatching records, occupied
  destinations, unsupported limited/forced sources and duplicate mappings fail.

To add a family, create another JSON with reviewed sources/proxies and unused pool
slots. Generation, cosmetic assignment and staging contain no family-name/path
branches. The shared discovery scanner produces disabled drafts; the reviewed Veteran, Elite and
Ascended snapshots are explicitly enabled in family JSON. Discovery does not auto-activate new findings.

The cosmetic helper finds an unused skill slot among the template's 60 slots and
uses a free `initialSkillName` or `initial2SkillName`. Existing skills/initial
abilities are preserved. If neither initial slot is free, generation fails rather
than overriding behavior; disable the tier aura or review the family before use.

Intensity, opacity and particle-scale sliders remain unimplemented; no invented
DBR fields or speculative binary patches are introduced. The original nature
particle and disabled actor tint stay unchanged.

## Weight split, not a new spawn layer

For each mapped Common entry, 20% of its existing weight becomes its corresponding
Veteran variant. The exact fraction is represented with integer weights:

| Original weight | New Common weight | New Veteran weight |
| ---: | ---: | ---: |
| 40 | 160 | 40 |
| 30 | 120 | 30 |

All other regular weights are multiplied by the same denominator (5), so each
original choice plus its Veteran counterpart retains exactly its original share
of the regular bucket. Counts, Champion chance/min/max/weights, Heroes and
unmapped special monsters are unchanged. This is distribution-equivalent to the
old boar 100 Common +25 Veteran mixture overall, but now preserves each source's
appearance/role/level rules. A new Veteran based on `boar_a02` keeps that variant's
own stronger bio and physical passive; the old single-boar prototype covered
only `boar_a01` and is unchanged.

The 2.5 Veterans-per-Champion setting is a reporting target ONLY, not a guaranteed
ratio or automatic tuning formula. The conversion rate applies to mapped regular
entries. Mixed pools containing unmapped enemies can have less than 20% Veterans
among all their regular selections. Exact frequency needs a larger sample.

## Reviewed zombie coverage and deliberate exclusions

| Pool | Mapped regular slots | Result |
| --- | --- | --- |
| `p_zombie_e` | 1, 3 | Starter Veterans; slot 1's max level 3 is inherited |
| `p_zombie_el_health` | 1 | Starter Veteran; potion dropper and limited slots preserved |
| `p_zombie_n` | 1, 7 | Normal and starter Veterans; starter max level 5 inherited |
| `p_zombie_amb_s1_n` | 1 | Normal Veteran |
| `p_zombie_amb_s2_n` | 1 | Normal Veteran |

Mapped entries have no finite individual limit or forced-spawn flag. Such entries
cannot safely be split into two independent slots while preserving a combined
quota, so this implementation refuses them. Loot/potion droppers, corpses, summons,
quest-specific enemies, gazers and other zombie roles are not promoted. Higher
buckets may contain records also used in regular buckets; they remain untouched.

## Rollback and stale build handling

To restore a pool: set its family config pool entry `enabled=false`, regenerate
ALL families WITH `--include-spawns`, stage with replacement, rebuild and reinstall.
This emits the exact vanilla pool contents, reliably replacing an incremental
build's old override. Disabling a whole family, removing config or skipping pools
is NOT equivalent: those actions leave already staged/compiled files behind.

Disabling a tier's aura removes its assignments from regenerated monsters; old
cosmetic records can remain inert. Do not delete unmodified reference assets.

## Validation and remaining work

28 tests pass: old-boar byte hashes, second-family generation via config,
starter bio preservation, no cosmetic combat stats, safe skill/initial allocation,
exact fraction/weight conservation, higher-tier/count rules unchanged, source
level gates inherited, collision rejection, config/path validation, staging
content/manifest checks, symlink safety and exact vanilla-pool rollback.

The user confirmed the boar proxy pool spawned a glowing Veteran after several
groups. That proves proxy/pool selection, not rarity calibration or every natural
map placement. New zombies, boar02, refactored pools, combat reach/collision and
broad map coverage still require in-game checks.
