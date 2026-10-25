# Ascended discovery report

Activation snapshot: **137 Hero sources / 241 selections / 63 ordinary pools** are enabled in config/families/discovered_ascended.json. Runtime behavior remains unverified.

`regular_entries_examined` is a legacy metric label counting Champion-group selections here. Reasons overlap. Monster Totem and other unsupported namespaces are excluded.

| Metric | Count |
| --- | ---: |
| regular_entries_examined | 7534 |
| unique_sources_examined | 1148 |
| candidate_sources | 137 |
| candidate_entries | 241 |
| candidate_pools | 63 |
| already_mapped_entries | 0 |
| review_required_entries | 7293 |
| read_errors | 0 |

## Review reasons (one entry can have several)

| Reason | Entries |
| --- | ---: |
| finite_quota_exceeds_supported_group_bound | 4799 |
| invalid_or_overflow_pool_weights | 2 |
| limited_or_forced_entry | 6 |
| missing_or_invalid_dependency | 4 |
| no_free_initial_slot | 305 |
| no_free_pool_slot | 63 |
| no_ordinary_proxy_reference | 3579 |
| no_unique_physical_base_passive | 626 |
| not_hero | 1717 |
| pool_also_used_by_special_proxy | 1413 |
| special_or_nonordinary_source | 1357 |
| special_pool_review | 1931 |
| unsupported_champion_count_equation | 140 |
| unsupported_pool_namespace | 3698 |
| zero_or_missing_selection_weight | 151 |

English files read: 0. Unknown names are not invented.

## Candidate sample (first 30 entries)

| Source | Pool / selection slot |
| --- | --- |
| records/creatures/enemies/hero/boar_h01.dbr | records/proxies/pools/p_beasts_boar_halftrollsonly_n.dbr / 2 |
| records/creatures/enemies/hero/boar_h02.dbr | records/proxies/pools/p_beasts_boar_halftrollsonly_n.dbr / 3 |
| records/creatures/enemies/hero/boar_h03.dbr | records/proxies/pools/p_beasts_boar_halftrollsonly_n.dbr / 4 |
| records/creatures/enemies/hero/boar_h04.dbr | records/proxies/pools/p_beasts_boar_halftrollsonly_n.dbr / 5 |
| records/creatures/enemies/hero/boar_h05.dbr | records/proxies/pools/p_beasts_boar_halftrollsonly_n.dbr / 6 |
| records/creatures/enemies/hero/boar_h06.dbr | records/proxies/pools/p_beasts_boar_halftrollsonly_n.dbr / 7 |
| records/creatures/enemies/hero/boar_h01.dbr | records/proxies/pools/p_beasts_boarice_n.dbr / 2 |
| records/creatures/enemies/hero/boar_h02.dbr | records/proxies/pools/p_beasts_boarice_n.dbr / 3 |
| records/creatures/enemies/hero/boar_h03.dbr | records/proxies/pools/p_beasts_boarice_n.dbr / 4 |
| records/creatures/enemies/hero/boar_h04.dbr | records/proxies/pools/p_beasts_boarice_n.dbr / 5 |
| records/creatures/enemies/hero/boar_h05.dbr | records/proxies/pools/p_beasts_boarice_n.dbr / 6 |
| records/creatures/enemies/hero/boar_h06.dbr | records/proxies/pools/p_beasts_boarice_n.dbr / 7 |
| records/creatures/enemies/hero/vulture_h01.dbr | records/proxies/pools/p_beasts_vultures_n.dbr / 2 |
| records/creatures/enemies/hero/vulture_h02.dbr | records/proxies/pools/p_beasts_vultures_n.dbr / 3 |
| records/creatures/enemies/hero/vulture_h03.dbr | records/proxies/pools/p_beasts_vultures_n.dbr / 4 |
| records/creatures/enemies/hero/vulture_h04.dbr | records/proxies/pools/p_beasts_vultures_n.dbr / 5 |
| records/creatures/enemies/hero/vulture_h05.dbr | records/proxies/pools/p_beasts_vultures_n.dbr / 6 |
| records/creatures/enemies/hero/waspgiant_h02.dbr | records/proxies/pools/p_beasts_wasp_n.dbr / 3 |
| records/creatures/enemies/hero/waspgiant_h03.dbr | records/proxies/pools/p_beasts_wasp_n.dbr / 4 |
| records/creatures/enemies/hero/waspgiant_h04.dbr | records/proxies/pools/p_beasts_wasp_n.dbr / 5 |
| records/creatures/enemies/hero/waspgiant_h05.dbr | records/proxies/pools/p_beasts_wasp_n.dbr / 6 |
| records/creatures/enemies/hero/waspgiant_h06.dbr | records/proxies/pools/p_beasts_wasp_n.dbr / 7 |
| records/creatures/enemies/hero/waspgiant_h07.dbr | records/proxies/pools/p_beasts_wasp_n.dbr / 8 |
| records/creatures/enemies/hero/mosquitogiant_h01.dbr | records/proxies/pools/p_beastsswamp_highlvl_mosquito_n.dbr / 2 |
| records/creatures/enemies/hero/mosquitogiant_h02.dbr | records/proxies/pools/p_beastsswamp_highlvl_mosquito_n.dbr / 3 |
| records/creatures/enemies/hero/mosquitogiant_h03.dbr | records/proxies/pools/p_beastsswamp_highlvl_mosquito_n.dbr / 4 |
| records/creatures/enemies/hero/mosquitogiant_h04.dbr | records/proxies/pools/p_beastsswamp_highlvl_mosquito_n.dbr / 5 |
| records/creatures/enemies/hero/mosquitogiant_h05.dbr | records/proxies/pools/p_beastsswamp_highlvl_mosquito_n.dbr / 6 |
| records/creatures/enemies/hero/mosquitogiant_h01.dbr | records/proxies/pools/p_beastsswamp_mosquito_n.dbr / 2 |
| records/creatures/enemies/hero/mosquitogiant_h02.dbr | records/proxies/pools/p_beastsswamp_mosquito_n.dbr / 3 |
