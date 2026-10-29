# Demolitionist deployables — conservative balance pass

**Branch:** `dev`. **Configured and tests authored; not yet generated, compiled with Asset Manager F7, or verified in-game.**

This extends the earlier [Demolitionist area/projectile balance](DEMOLITIONIST_BALANCE.md)
through five additional DBRs under `records/skills/playerclass02/`, configured
independently in `config/player_skills.json`.

## Mortar Trap

| Modification | Native | Modded |
| --- | --- | --- |
| Mortar lifetime (`mortartrap1.dbr:spawnObjectsTimeToLive`) | 24 s | **27.6 s** (+15%) |
| Base mortar shell radius (`pets/mortartrap_firemortar1.dbr:projectileExplosionRadius`) | 3 m | **3.3 m** (+10%) |
| Heavy Ordnance additional explosion-radius curve (`mortartrap2.dbr:explosionRadius`) | 0.3–2.0 across 22 ranks | **0.33–2.2**, multiplied by 1.10 at each native rank |
| Maximum active mortars (`mortartrap1.dbr:petLimit`) | 1 (ranks 1–16), 2 (17–23), 3 (24–26) | **1** (1–11), **2** (12–17), **3** (18–23), **4** (24–26) |

Mortars remain one per cast (`petBurstSpawn=1`), with the original **4.5 s
cooldown**, damage, scaling, base attack behavior and FX unchanged. The native
26-rank limit curve is replaced with another 26-rank integer curve.

## Thermite Mine

| Modification | Native | Modded |
| --- | --- | --- |
| Mine lifetime (`thermitemines1.dbr:spawnObjectsTimeToLive`) | 18 s | **20.7 s** (+15%) |
| Flame-area attack radius (`pets/thermitemine_skill_radius.dbr:skillTargetRadius`) | 2 m | **2.2 m** (+10%) |
| Mines per cast (`thermitemines1.dbr:petBurstSpawn`) | 3 | **3 at ranks 1–15; 4 at ranks 16–26** |
| Active mine limit (`thermitemines1.dbr:petLimit`) | 6 | **6 at ranks 1–15; 8 at ranks 16–22; 9 at ranks 23–26** |

Both spawn fields are *template-supported arrays of integers* in the actual
`skill_targetedspawnpet.tpl`; the rank-dependent values use explicit
semicolon-separated integer curves. At the top rank a third cast can fill
the cap of nine, assuming earlier mines have not expired.

These increases expand battlefield coverage and can noticeably improve damage
against clustered monsters, even though no skill's raw damage curve is changed.
Monitor performance with double-sized packs. Existing equipment modifiers may
alter actual runtime limits and ranges.

## Independent rollback and verification

Each of the five DBRs is an individual entry in `config/player_skills.json`
with `enabled` defaulting to true. Set an entry's `enabled:false` to restore
the effective native DBR after regeneration and **replacement staging**. Disable
the entire Demolitionist pass by disabling its 13 related entries, not the
global player skills flag (which disables Nightblade, Occultist and Arcanist too).

Regression cases in `tests/test_player_skills.py` validate all 26-rank count
bands, 22-rank Heavy Ordnance radius, untouched fields, and rollback.
Tests have been committed but **not run** from this session.

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python -m unittest discover -s tests -p test_player_skills.py -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Then rebuild with **F7** in Grim Dawn Asset Manager. Test the extra mortar at
ranks **12, 18, 24**, the 4-mine cast at rank **16**, the 9-mine cap at rank
**23**, and compare artillery and flame coverage against the stock version.
