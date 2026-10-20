> DLC update: scanner, validation and generation now resolve GDX2, then GDX1,
> then base records. Expansion-specific pool namespaces are included. A fresh
> scan examined 6,285 regular entries / 1,170 sources: 442 existing mappings,
> 48 new source candidates / 186 selections / 119 pools; zero read errors.
> Review counts overlap. New candidates remain disabled. See the current snapshot.
> The older counts below describe the earlier base-only scan.

> Update: the audited 96-source snapshot is now enabled in
> `config/families/discovered_veterans.json` at the shared 20% conversion share.
> It adds 200 pools and 431 substitutions. All generated pool fields were compared
> with vanilla: inherited level rules, unchanged Champion/count fields, exact
> probability mass and no changes to existing boar/zombie output. Runtime testing
> remains pending. The historical scan counts below precede activation; a fresh
> scan will classify these mappings as already configured. Scanner drafts still
> default to disabled and do not change active content.

# Veteran discovery scanner

October 19, 2026. This pass discovers mechanically compatible sources and prepares
a **disabled** draft; it does not activate new families or change the playable mod.

## Run

```powershell
python scripts/discover_veterans.py
```

Default is read-only: prints a summary, writes no files. Optional outputs:

```powershell
python scripts/discover_veterans.py --write-report --draft-config
```

This writes ONLY `generated/discovery/` (Git-ignored):

- `coverage.json`: every examined regular selection, reasons and proxy evidence.
- `coverage.md`: summary and first 30 candidate entries.
- `discovered_veterans.json`: schema-2 family config with `enabled=false`.

It never writes to `config/families`, database/, source/, the extracted references
or game installation, and does not build/stage DBRs. The active output remains
30 DBRs + one English text source. No F7/reinstall is needed for the scanner.

## Current scan

[Snapshot report](VETERAN_DISCOVERY_REPORT.md) from the current checked-in references:

| Result | Count |
| --- | ---: |
| Regular entries examined | 1,309 |
| Distinct source records examined (includes non-Common records) | 294 |
| Mechanically compatible new Common source candidates | 96 |
| Candidate regular selections | 431 |
| Distinct candidate pools | 200 |
| Already mapped selections | 11 |
| Entries requiring review / excluded | 867 |
| Reference read errors | 0 |

Reason counts can overlap: one entry can be non-Common AND limited, for example.
This is not 867 distinct unsupported Common enemies. Sources are classified from
the record's actual `monsterClassification`, not filename suffix or pool bucket.
A Common record occurring in a Champion selection is not promoted by this scanner.

The candidate draft passes a dry run through the actual generator for every variant
and pool, and validates alongside the existing boar/zombie configs in an isolated
catalog. This proves build-tool compatibility, not Asset Manager compilation,
map safety, quest behavior, visual placement or runtime balance. No new candidate
has been installed or enabled. Start with a reviewed small batch, not all at once.

## What it checks

- Starts from regular `nameN` selections in `ReferenceFiles/proxies/pools/`.
- Builds reverse pool references from ordinary proxy/proxyambush records.
- Requires Common classification, monster template, supported bio/equations,
  model scale, one unambiguous physical-damage passive and available cosmetic
  skill/initial slots. It uses the shared Veteran scale/conversion settings.
- Flags quest/scripted records, special/faction/quest proxy use, summons, traps,
  special sources, missing dependencies, finite quotas, forced spawns, malformed
  weights, pool capacity and existing configured coverage/ownership.
- A pool also referenced by special/faction/quest proxies is review-only, even
  when an ordinary proxy also references it. Path heuristics cannot prove that all
  quest interactions or friendliness were discovered; all drafts remain disabled.
- Existing weights/counts are not edited during discovery. Proposed output slots
  reserve every existing slot field, including stale rule fields without a name.

`config/discovery.json` holds conservative path filters and scanner scope. It is
strictly Common -> Veteran; Elite/Ascended/Apex policies remain future work, with
no parent fallback. Engine template capacity is 15 regular pool slots.

## Shared pools and existing content

The generated draft is one aggregate candidate family, not a claim that all sources
are the same biological family. Each source has a stable hashed variant id, appears
once, and can be referenced by many pools. Every new shared pool is emitted once,
with all proposed mappings combined and unique destination slots. Re-running the
scan is deterministic for the same references/configs/text tags.

Existing boar/zombie sources and owned pools are **not** duplicated/overwritten.
Already mapped entries are reported as covered. New uses of an already generated
source and new entries in an already owned pool are flagged for merge review.
Automatically extending those live family configs is NOT implemented in this pass.
This avoids the current generator's intentional duplicate-pool-output rejection.

## English names

No extracted English tag files are present in the current upload. The scanner
supports an optional extracted text directory:

```powershell
python scripts/discover_veterans.py --write-report --draft-config --text-root "M:\path\to\extracted\Text_EN"
```

It also auto-detects `ReferenceFiles/Resources/Text_EN` case-insensitively. Plain
UTF-8/UTF-8-BOM and UTF-16-BOM text files are supported. Conflicting definitions of
a tag are flagged; a name is never guessed. Resolved text becomes `display_name`
in the draft, producing Original Name (Veteran) through the existing generator.
Unresolved tags preserve the vanilla description tag and have a name warning, so
those draft variants would not yet gain the suffix. The existing Walking Dead
(Veteran) config/name is unaffected and was verified in-game by the user.

Do not put a compiled Text_EN.arc in --text-root: this option reads extracted .txt
files. Copying extracted English tag files into ReferenceFiles/Resources/Text_EN
would enable automatic name resolution for the next scan.

## Next implementation stage

1. Supply extracted English tags for broad custom-name coverage.
2. Review candidate pool/source evidence and choose a small batch.
3. Copy only that reviewed subset into active configs, respecting unique pool
   ownership. Never just enable every mechanically compatible record by default.
4. Generate/build/install, sample visuals/combat/pool selection, then expand.
5. Handle flagged quotas, special encounters and existing-pool extensions through
   explicit policies rather than weakening discovery checks.

40 tests pass, including deterministic disabled drafts, shared-pool/source dedup,
existing-content preservation, strict Common scope, faction/quest filters, missing
weights/dependencies, limited/forced entries, pool/initial capacity, tag ambiguity
and guarded output paths. The previous 28 gameplay-generation tests still pass.
