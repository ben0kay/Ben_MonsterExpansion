# Hero → Ascended

The shared pipeline enables **137 exact Hero parents / 241 selections / 63 ordinary
pools** at **33% conditional replacement**. The combined catalog has **148 Veterans,
124 Elites and 137 Ascended**, with **377 merged pools**: **2,833 DBRs + 1 text source**.
This activation adds 9 pool paths and changes 54 existing pool overrides. Of the
241 mapped selections, 240 use the bounded finite-quota policy and one is unrestricted.
**63 Python tests pass**, including bounded quotas, combined-pool probabilities,
independent Elite/Ascended shares, slot reservations and rollback. Full generation
and staging preflight pass. Representative in-game and multiplayer behavior remains
unverified.

## Data-driven settings

The Ascended prototype in `config/tiers.json` controls:

```json
{
  "parent_tier": "hero",
  "stats_vs_parent": { "health": 1.4, "damage": 1.22, "defense": 1.15 },
  "model_scale_vs_parent": 1.15,
  "natural_spawns": {
    "conversion_share": 0.33,
    "finite_limit_policy": "bounded_champion_group"
  },
  "cosmetic_aura": {
    "enabled": true,
    "effect_source_record": "records/fx/creatures/glowpurple01_large.dbr"
  }
}
```

Damage scales the parent's existing physical base passive, not every skill or
final damage. Original Hero classification, name tags, skills/timing, loot setup,
textures and collision dimensions remain. Violet uses a vanilla purple particle;
its appearance and inherited Hero marker need game verification. No new combat
abilities or forced actor tint are introduced. English names remain optional.

Discovery policy is `config/discovery_ascended.json`; the enabled snapshot is
`config/families/discovered_ascended.json`. Sources resolve GDX2 > GDX1 > base.
No Common/Champion fallback, Boss or Nemesis conversion is enabled.

## Preserving finite quotas

Heroes use `nameChampionN` alongside Champion-classified monsters. Most Hero
entries have `limitChampionN=1`. Simply duplicating that quota in a pool that
can draw several enemies would allow both the Hero and Ascended to appear.

The implemented policy accepts a finite Hero only when:

- Its source is not forced and no Champion-group entry is forced.
- `0 <= championMin <= championMax <= source limit`, with a positive maximum.
- Both Champion count equations are exactly `poolValue * 1` (whitespace ignored).

For example, `championMax=1` and Hero limit 1 means the pool can select at most
one member of the entire Champion group. Splitting that Hero into a 67/33 pair
cannot produce two members. Each retains the original limit and level rules.

If `championMax=2` and Hero limit 1, the split is **excluded**. Supporting that
case needs a genuinely shared quota/selection mechanism; two independent limits
are insufficient. Unknown equations, forced entries and special encounters also
remain excluded. Unrestricted entries do not need this finite-quota bound.
The proof concerns the uploaded pool/equation data; engine placement/rounding and
multiplayer remain gameplay checks.

The scanner also excludes unsupported bios/damage setups, missing dependencies,
occupied initial/cosmetic slots and full Champion slot groups. Monster Totem,
faction/quest/scripted/special pools are outside this ordinary-encounter pass.
Reports retain reasons rather than forcing broad coverage.

## Combining tiers

Veteran weights stay in the independent regular group. Elite and Ascended entries
share the Champion group. Each eligible source keeps its original combined
selection probability and uses its own JSON conversion share. The merger scales
all weights using a common denominator (LCM), so Elite and Ascended shares can
be adjusted independently without changing unrelated selection probabilities.
Shares must remain above zero and below 0.5, and the combined denominator cannot
exceed 1,000. Slot reservations include both Elite and Ascended mappings.
Group counts, existing level/quest restrictions and unrelated DBR fields remain.
Previously generated Veteran/Elite monster/support records, player progression
and global pack equations are byte-identical.

Disable an Ascended pool with `enabled=false`, regenerate/stage the full catalog,
rebuild and install. Its Hero split is removed while other tier mappings remain.
Removing a family or selecting only one family does not remove stale compiled
records. No original game archives or reference records are edited.

## Discover, build and check

Optional rescan (read-only unless report/draft flags are supplied):

```powershell
python scripts/discover_ascended.py
python scripts/discover_ascended.py --write-report --draft-config
```

Reports: `generated/discovery/ascended_coverage.json` and `.md`. Optional draft:
`generated/discovery/discovered_ascended.json`, disabled. Do not replace the active
family with a rescan draft; existing mappings are already active. Naming tags can
be supplied through `--text-root` without making them an activation prerequisite.

Build the complete mod:

```powershell
git pull
python scripts/validate_config.py
python -m unittest discover -s tests -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

F7 in Asset Manager, install the rebuilt mod `.arz`, retain/install its Text_EN.arc
for existing custom zombie labels, and restart Custom Game. All prior features
remain included. No new text tags are required for this activation.

Direct Ascended test (exact parent: `hero/aetherialcolossus_h01.dbr`):

```text
game.Spawn "records/creatures/enemies/monsterexpansion/discovered_ascended_ascended_b93dca01452e6643.dbr"
```

Check purple glow, scale, movement/death, retained skills and same-level HP against
the exact parent. For natural selection, use an enabled pool's evidence proxy or
visit its area in a fresh game session. Confirm its combined Hero/Ascended quota;
33% refers to eligible Hero selections, not 33% of every pack or every monster.
