# ME1 — MonsterExpansion Architecture

**Status: ME1 scaffolding established.** Actual DBR generation, spawning changes, new UI colors, textures, and combat scaling are NOT implemented.

## Source of truth

- `config/tiers.json` contains all nine approved tier names, order, color targets, and explicitly **provisional** multipliers for four new tiers.
- `config/families/boar.json` points to actual canonical `records/...` paths from Grim Dawn. It specifies the **first planned** Veteran Boar, not an active mod.
- `ReferenceFiles/` is the extracted vanilla reference library; read it, but **never edit or publish new generated assets into it**.
- Future generated mod DBRs belong under `mods/MonsterExpansion/database/records/` (logical layout; map to the exact configured Asset Manager working path before integration). `mods/` outputs are not produced by ME1.
- `scripts/validate_config.py` checks mappings and schema, without writing. `scripts/preview_variants.py` prints the prototype plan and writes nothing.

## Fixed progression

Common → Veteran → Champion → Elite → Hero → Ascended → Boss → Nemesis → Apex.

Only Veteran, Elite, Ascended, and Apex are new *mod* tiers. `monsterClassification` remains a built-in engine enum; we cannot create four new enums by editing DBR values. Nemesis enemies may have `monsterClassification,Boss` while some super bosses use `SuperBoss`. Do not equate our tier labels with engine enum values.

Each tier has its own target color for monster appearance AND, where possible, name/HP bar. UI recoloring is **unverified**. Treat interface colors as targets, not implemented features; document tested fallback FX/tints if game UI cannot be recolored normally.

## Variant pipeline (to build in ME2)

1. Resolve a family and chosen parent tier to a canonical original `records/...` monster DBR and its referenced bio/skills.
2. Clone only the required records into a dedicated `monsterexpansion/` namespace under the mod source tree, never back into `ReferenceFiles/`.
3. Apply validated tier-specific stat rules (often via the referenced bio equations), preserve damage categories and difficulty behavior.
4. Apply **model scale relative to parent**. Inspect actor radius/height, actual hitboxes, melee range, AoE radii, FX offsets, navigation, and animation compatibility separately. Scaling `scale` does NOT prove that attacks/collision scale automatically.
5. Adjust compatible special-attack chance/delay/timeout and optionally attach validated skills; do not assume arbitrary skill reuse works with all animations.
6. Add optional distinct aura/texture FX where source assets permit. Investigate, do not promise, name/health-bar coloring.
7. Update a copied, scoped spawn pool to reference the new record, preserving ordinary enemies and restrictions. Initially test just one pool and variant.
8. Compile locally with Asset Manager and verify game behavior; do not treat a passing script validator as an in-game test.

## Initial boar reference chain

- Monster: `records/creatures/enemies/boar_a01.dbr` (`Common`, model `scale=1.0`, `actorRadius=0.75`)
- Champion: `records/creatures/enemies/boar_b01.dbr` (`Champion`, `scale=1.6`, `actorRadius=0.75`)
- Hero: `records/creatures/enemies/hero/boar_h01.dbr` (`Hero`, `scale=2.0`, `actorRadius=0.70`)
- Spawn pool: `records/proxies/pools/p_beasts_boar_n.dbr` uses `name1`, `nameChampion1`, `nameChampion2` to reference these.
- Example radius attack: `records/skills/nonplayerskills/attackradius/boar_groundslam.dbr` has `skillTargetRadius=3.8`.
- Common bio: `records/creatures/enemies/bios/bio_boar_01.dbr`; champion bio: `bio_boar_03.dbr`; hero bio: `bio_hero_bruiser_01.dbr`.

All game paths above have corresponding extracted reference files at `ReferenceFiles/` + path with initial `records/` removed.

## ME1 acceptance checks

Run from repository root:

    python scripts/validate_config.py
    python scripts/preview_variants.py

To validate JSON without local extracted records: `python scripts/validate_config.py --skip-references`.

Passing means the configuration references currently present monster/pool files and does not try to overwrite a vanilla record. It does **not** mean Asset Manager compilation or in-game behavior is proven.

## Planned next milestone

**ME2:** Implement actual DBR parser/clone/generator with safe output paths, matching stat equations, validation and tests. **ME3:** build and playtest a Veteran Boar and its spawn pool. No mass generation until ME3 passes.
