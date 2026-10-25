# Champion → Elite

Implemented October 25, 2026 using the shared Veteran pipeline. The enabled
snapshot has **124 exact Champion parents, 382 selections and 255 pools**.
The combined catalog has **148 Veterans + 124 Elites, 368 merged pools** and emits
**2,002 DBRs + 1 text source**. **57 Python tests pass**, including final merged-pool invariants and preserved
Veteran output; generation/staging preflight also passes. Representative in-game
verification is pending.

## Settings and sources

`config/tiers.json`, Elite prototype:

```json
{
  "parent_tier": "champion",
  "stats_vs_parent": { "health": 1.3, "damage": 1.18, "defense": 1.12 },
  "model_scale_vs_parent": 1.1,
  "natural_spawns": { "conversion_share": 0.33 },
  "cosmetic_aura": {
    "enabled": true,
    "effect_source_record": "records/fx/creatures/goldenglow01_large01.dbr"
  }
}
```

Stats are relative to each exact Champion. Damage scales its existing physical
base passive, not all final damage or every skill. Existing skills/timing,
classification, textures, collision and name tags remain unchanged. Golden vanilla
particles are a provisional amber cosmetic; no exact tint or overhead star is
implemented. English names are optional and currently unresolved for Elites.

These JSON settings are build inputs. Editing them requires generate → stage →
F7 → install `.arz` → restart Custom Game. Current share validation accepts only
values above zero and below 0.5, with a rational denominator at most 1,000.

`config/discovery_elites.json` selects Champion sources and the Elite target tier.
`config/families/discovered_elites.json` holds the enabled snapshot. There are no
enemy-specific Python branches. GDX2 overrides GDX1, which overrides base.

## Spawn behavior and safeguards

A Champion selection is drawn from the pool's `nameChampionN`/`weightChampionN`
group, which can also contain Heroes. Only records actually classified Champion
are eligible. An eligible entry retains **67% of its weight** and its Elite gets
**33%**. It does not increase Champion counts or change a spawned monster's tier.

All weights in that group scale by the share denominator, including unmapped
Hero entries, preserving each unrelated entry's relative probability. Regular
Common/Veteran weights are independent. Level variance and min/max player levels
are copied to the new slot. Global chance/count fields remain unchanged.

The shared generator merges mappings before writing a pool. Of 255 Elite pools,
212 already have Veteran mappings and 43 are new. Duplicate/overlapping source
or output mappings, occupied slots, unsupported source-slot fields, overflow,
forced/finite entries and wrong parent classifications fail validation. A full
15-slot Champion group is reported for review rather than overwritten.

Discovery excludes special/quest/faction/scripted paths and pools used by blocked
proxies, unsupported bios/damage setups and creatures without safe cosmetic slots.
It does not substitute Common sources or convert Heroes/Bosses/Nemeses.
Exceptions remain in the JSON scan report with reasons; they are not silently
included. No quota-aware policy or new combat abilities are implemented.

## Discovery and build

Optional read-only rescan:

```powershell
python scripts/discover_elites.py
python scripts/discover_elites.py --write-report --draft-config
```

Reports go to `generated/discovery/elite_coverage.json` and `.md`; the disabled
`discovered_elites.json` draft goes there too. Do not copy an empty rescan draft
over the active config. Existing mappings are reported as already mapped;
existing-source/new-pool mappings still require review. The generic entry point
also accepts `--policy config/discovery_elites.json`.

Build the complete mod:

```powershell
git pull
python scripts/validate_config.py
python -m unittest discover -s tests -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Build with F7 in Asset Manager; install the rebuilt mod `.arz` and retain the
mod's Text_EN.arc for existing zombie labels. Restart the Custom Game. All
Veterans, 1.5x packs and the 2-point/+6 attribute settings are included together.

Direct Elite boar test (exact parent: `records/creatures/enemies/boar_b01.dbr`):

```text
game.Spawn "records/creatures/enemies/monsterexpansion/discovered_elites_elite_75bbb288ac65b5d4.dbr"
```

Other generated paths are in the family JSON. Select a pool's `proxy_references` path to test
its actual group selection. Proxy activation and map placement still need game
verification. Check glow, larger size, movement/death, inherited abilities and
health against the exact parent at the same level. Repeat natural encounters;
33% applies only within each mapped Champion selection, not all monsters.

For rollback, set an Elite pool's `enabled` to false and rebuild/install the
combined catalog. Its Elite split disappears while any Veteran mapping remains.
With all mappings disabled, the pool emits exact vanilla. Removing a family or
using a restricted `--family` selection does not clean stale compiled records.
