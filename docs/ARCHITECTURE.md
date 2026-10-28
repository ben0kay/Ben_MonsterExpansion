# MonsterExpansion architecture

The current specification and runnable examples are in
[DATA_DRIVEN_FAMILIES.md](DATA_DRIVEN_FAMILIES.md).

The build-time pipeline is:

1. Validate tier defaults and schema-2 explicit family configs.
2. Read original monster/bio/physical-passive DBRs, keeping originals unchanged.
3. Emit namespaced per-variant records, safely attach a stat-free cosmetic self-buff, then independent low-health rage and curated on-hit elemental retaliation where compatible.
4. Optionally merge mappings per pool, splitting regular and Champion weights independently while inheriting source eligibility.
5. Reject duplicate outputs, unsafe paths, occupied destinations and limited sources.
6. Produce one deterministic manifest for the selected family set.
7. Stage only content matching the recomputed validated plan.
8. Compile/install manually with Asset Manager and record in-game results.

Tier JSON is tooling input; Grim Dawn reads generated DBRs, not JSON at runtime.
Ascended TM2 covers 135 of 137 exact reviewed native Hero record stems (not species-wide
substring guesses) in `config/tiers.json`, cloning a native
`Skill_OnHitAttackRadius` with 10% on-hit activation and eleven themed damage/FX profiles.
The two Cave Prawns with native Poison Nova are intentionally excluded.
Each actor gets at most one new retaliation skill; existing native on-hit
radius skills and full ordinary skill slots are skipped. The deterministic
manifest includes `retaliation_coverage.ascended`; see
[Ascended elemental retaliation](ASCENDED_ELEMENTAL_RETALIATION.md).
Generation and static tests do not establish native FX compatibility or
gameplay behaviour.

Shared settings are applied on regeneration, not live. Each source variant keeps
its own equations/skills, so a stronger vanilla parent can yield a stronger
Veteran without being flattened to another family's baseline.

Generated monster/support records are namespaced. Reviewed pool records deliberately
override original logical paths inside the custom mod so existing proxies can
resolve them. This does not edit original game files or require a new map. Proxy
map placement coverage remains separate from proving console proxy activation.

Staging does not trust manifest paths and never copies the extracted Resources
or reference tree. It recomputes the expected plan, compares every file including
the manifest, and refuses unsafe output paths or unapproved contents. Previously
compiled records are not automatically deleted: pool rollback emits exact vanilla
contents and requires another build/install.

Implemented discovery: JSON-selected Common/Veteran and Champion/Elite and Hero/Ascended scans with read-only reports and disabled drafts.

Future work: additional reviewed configs;
quota-aware limited spawn policies; proven particle scale/intensity controls;
further compatible higher-tier abilities, rewards and curated Apex encounters. No blanket
conversion of quests, summons, loot droppers or special enemies.

Finite Hero quotas are supported only when identity Champion count equations bound the entire group within the source limit. Larger-draw quotas remain excluded; see [Ascended policy](ASCENDED.md).
