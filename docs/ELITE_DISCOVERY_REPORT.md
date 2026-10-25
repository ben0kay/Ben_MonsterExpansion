# Elite discovery report

Activation snapshot: all 124 candidate sources / 382 selections / 255 pools below are enabled in config/families/discovered_elites.json. This is data validation, not runtime proof.

The legacy metric name `regular_entries_examined` here counts Champion-group selections (7,534); classification filtering excludes Heroes and other non-Champions. Multiple exclusion reasons can apply to one selection.

| Metric | Count |
| --- | ---: |
| regular_entries_examined | 7534 |
| unique_sources_examined | 1148 |
| candidate_sources | 124 |
| candidate_entries | 382 |
| candidate_pools | 255 |
| already_mapped_entries | 0 |
| review_required_entries | 7152 |
| read_errors | 0 |

## Review reasons (one entry can have several)

| Reason | Entries |
| --- | ---: |
| invalid_or_overflow_pool_weights | 2 |
| limited_or_forced_entry | 6603 |
| missing_or_invalid_dependency | 4 |
| no_free_pool_slot | 120 |
| no_ordinary_proxy_reference | 3579 |
| no_unique_physical_base_passive | 201 |
| not_champion | 4603 |
| pool_also_used_by_special_proxy | 1413 |
| special_or_nonordinary_source | 1357 |
| special_pool_review | 1931 |
| zero_or_missing_selection_weight | 151 |

English files read: 0. Unknown names are not invented.

## Candidate sample (first 30 entries)

| Source | Pool / selection slot |
| --- | --- |
| records/creatures/enemies/boar_b01.dbr | records/proxies/pools/p_beasts_boar_halftrollsonly_n.dbr / 1 |
| records/creatures/enemies/boar_b01.dbr | records/proxies/pools/p_beasts_boar_halftrollsonly_t.dbr / 1 |
| records/creatures/enemies/boar_b01.dbr | records/proxies/pools/p_beasts_boar_n.dbr / 1 |
| records/creatures/enemies/boar_b01.dbr | records/proxies/pools/p_beasts_boar_t.dbr / 1 |
| records/creatures/enemies/prawn_b01.dbr | records/proxies/pools/p_beasts_prawn_e.dbr / 1 |
| records/creatures/enemies/prawn_b02.dbr | records/proxies/pools/p_beasts_prawn_e.dbr / 2 |
| records/creatures/enemies/prawn_c01.dbr | records/proxies/pools/p_beasts_prawn_e.dbr / 3 |
| records/creatures/enemies/prawn_b02.dbr | records/proxies/pools/p_beasts_prawn_n.dbr / 2 |
| records/creatures/enemies/prawn_c01.dbr | records/proxies/pools/p_beasts_prawn_n.dbr / 3 |
| records/creatures/enemies/prawn_b01.dbr | records/proxies/pools/p_beasts_prawn_n.dbr / 9 |
| records/creatures/enemies/prawn_b02.dbr | records/proxies/pools/p_beasts_prawn_t.dbr / 2 |
| records/creatures/enemies/prawn_c01.dbr | records/proxies/pools/p_beasts_prawn_t.dbr / 3 |
| records/creatures/enemies/prawn_b01.dbr | records/proxies/pools/p_beasts_prawn_t.dbr / 9 |
| records/creatures/enemies/slitha_melee_b01.dbr | records/proxies/pools/p_beasts_slitha_amb_s1_n.dbr / 1 |
| records/creatures/enemies/slitha_shaman_b01.dbr | records/proxies/pools/p_beasts_slitha_amb_s1_n.dbr / 2 |
| records/creatures/enemies/slitha_shaman_c01.dbr | records/proxies/pools/p_beasts_slitha_amb_s1_n.dbr / 3 |
| records/creatures/enemies/waspgiant_c01.dbr | records/proxies/pools/p_beasts_wasp_n.dbr / 1 |
| records/creatures/enemies/waspgiant_c01.dbr | records/proxies/pools/p_beasts_wasp_t.dbr / 1 |
| records/creatures/enemies/mosquitogiantb_c01.dbr | records/proxies/pools/p_beastsswamp_highlvl_mosquito_n.dbr / 1 |
| records/creatures/enemies/mosquitogiantb_c01.dbr | records/proxies/pools/p_beastsswamp_highlvl_mosquito_t.dbr / 1 |
| records/creatures/enemies/troll_swamp_a01.dbr | records/proxies/pools/p_beastsswamp_highlvl_troll_n.dbr / 1 |
| records/creatures/enemies/troll_swamp_b01.dbr | records/proxies/pools/p_beastsswamp_highlvl_troll_n.dbr / 2 |
| records/creatures/enemies/troll_swamp_a01.dbr | records/proxies/pools/p_beastsswamp_highlvl_troll_t.dbr / 1 |
| records/creatures/enemies/trollhalfswamp_b02.dbr | records/proxies/pools/p_beastsswamp_highlvl_troll_t.dbr / 2 |
| records/creatures/enemies/troll_swamp_c01.dbr | records/proxies/pools/p_beastsswamp_highlvl_troll_t.dbr / 3 |
| records/creatures/enemies/mosquitogiant_c01.dbr | records/proxies/pools/p_beastsswamp_mosquito_n.dbr / 1 |
| records/creatures/enemies/mosquitogiant_c01.dbr | records/proxies/pools/p_beastsswamp_mosquito_t.dbr / 1 |
| records/creatures/enemies/spidergiantb_cave_c01.dbr | records/proxies/pools/p_cave_spidergiant_n.dbr / 4 |
| records/creatures/enemies/spidergiantb_cave_c01.dbr | records/proxies/pools/p_cave_spidergiant_t.dbr / 4 |
| records/creatures/enemies/trollhalf_cave_b02.dbr | records/proxies/pools/p_cave_trollhalf+worms_n.dbr / 5 |
