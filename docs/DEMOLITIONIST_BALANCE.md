# Demolitionist — first-pass projectile and area balance

**Status:** implemented in `config/player_skills.json` on `dev`; not yet
generated, Asset Manager F7-built, or tested in game.

## Goal

Slightly improve Demolitionist's explosive feel and crowd control for a
Demolitionist + Occultist (Pyromancer) playthrough. Preserve native damage,
skill-point progression, core mechanics, cooldowns, energy costs, cast rates,
weapon restrictions, pets, and effects unless explicitly listed below.

All adjustments use native Demolitionist DBR records from
`records/skills/playerclass02/`. The current repository has original
reference DBRs for these records; no corresponding GDX1/GDX2 overrides were
present in the uploaded reference folders during this pass. The generator
uses effective reference resolution (GDX2 > GDX1 > original) and does not
change the reference files themselves.

## Eight changed records

| Skill (native record) | Changed field(s) | Native -> modded / rationale |
| --- | --- | --- |
| Stun Jacks (`stunjacks1.dbr`) | `projectileExplosionRadius` | 2.5 -> **2.75 m** (+10%); base 3 projectile launch count unchanged |
| Full Spread (`stunjacks2.dbr`) | `projectileLaunchNumber` | Retain native extra-projectile curve through rank 13; **+1 extra projectile from ranks 14–22**, reaching **6** at rank 22 (native 5) |
| Explosive Strike (`flamestrike2.dbr`) | `skillTargetRadius` | Each of 22 native splash-radius values **x1.10** (1.8 -> 1.98 m at rank 1; 4.3 -> 4.73 m at rank 22) |
| Grenado (`grenado1.dbr`) | `projectileExplosionRadius` | 4.5 -> **4.95 m** (+10%); still throws one grenade |
| Canister Bomb (`canisterbomb1.dbr`) | `projectileExplosionRadius`, `projectileFragmentsLaunchNumberMin`, `projectileFragmentsLaunchNumberMax` | Main radius 3.2 -> **3.52 m**; keep original fragment counts at ranks 1–7, add +1 min/max at ranks 8–17, add +2 min/max at ranks 18–22 |
| Improved Casing (`canisterbomb2.dbr`) | `explosionRadius` | Multiply all 20 original radius values by **1.10** (0.5 -> 0.55 at rank 1; 3.5 -> 3.85 at rank 20) |
| Blackwater Cocktail (`blackwater1.dbr`) | `projectileExplosionRadius`, `skillActiveDuration` | Each of 22 ranks has **+12% radius** (2.5 -> 2.8 m; 6.4 -> 7.168 m) and **+10% duration** (2.5 -> 2.75 s; 6.5 -> 7.15 s) |
| Flashbang (`flashbang1.dbr`) | `projectileExplosionRadius` | Each of 22 radius ranks **x1.10** (5 -> 5.5 m; 12 -> 13.2 m) |

### Native scaling preserved

- **Canister Bomb:** native fragment range rank 1 **4–6** -> modded **4–6**; rank 8 native **6–8** -> modded **7–9**; rank 22 native **9–11** -> modded **11–13**. These are secondary fragments, **not** full-strength additional bombs.
- **Full Spread:** native rank 1 **1** -> still **1**; rank 14 native **3** -> modded **4**; rank 22 native **5** -> modded **6**. Base Stun Jacks remains at 3 projectiles. All modifier spread-angle values are unchanged.
- **All areas:** use a multiplier on *each rank's own original value*, not a flat number based on rank 1.
- The projectile-count fields are supplied as literal semicolon-separated **integers**; the generic numeric-curve generator serializes decimal values and is therefore deliberately *not* used for integer projectile counts.
- No skills have additional damage multipliers or altered cooldowns. Increases in coverage or fragment quantity may still increase actual damage against clustered enemies.

## Subsequent deployables pass

A second committed Demolitionist pass now adjusts **Mortar Trap and Thermite
Mine counts, lifetimes and attack areas** in five additional DBRs. Therefore
their summon counts/caps are **no longer unchanged**. See
[Demolitionist deployables](DEMOLITIONIST_DEPLOYABLES.md) for the exact
1/2/3/4 mortar caps, 3/4 mines-per-cast progression, 6/8/9 mine caps and
per-rank or fixed radius improvements.

## Explicitly unchanged by these Demolitionist passes

Fire Strike's weapon damage, Explosive Strike's damage, other Fire Strike
modifiers, the base Stun Jacks launch count, Blast Shield, Vindictive Flame,
Flame Touched and all Demolitionist exclusive-skill flags remain unchanged.
The separate **Demolitionist skeleton attachment** is configured in
`config/demolitionist_skeletons.json` and documented in
[Demolitionist skeletons](DEMOLITIONIST_SKELETONS_BUILD.md). It does not
change the original Nightblade or Necromancer skills.

## Implementation and rollback

The **13 Demolitionist balance entries** are independent records in
`config/player_skills.json`.
To disable just one skill, set its entry's `enabled` to `false`, then
regenerate, replace-staging and rebuild. Disabling the global player skill
pass restores *all* player skill records, not only Demolitionist.

Focused tests in `tests/test_player_skills.py` verify the exact touched
fields, preservation of per-rank radii and durations, integer projectile
milestones, minimum <= maximum fragment counts, and individual rollback for
three representative records. Tests were added to the repo but could **not
be run** in this GitHub-connected session.

### Build and validation

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python -m unittest discover -s tests -p test_player_skills.py -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Press **F7** in Asset Manager and test a new Demolitionist character. Check
Canister Bomb at ranks 1/8/18/22, Full Spread at 13/14/22, and the selected
radius upgrades at low and high ranks; verify effects visually and watch
performance around large monster packs. Inspect tooltip numbers, but verify
the number of visible fragments/projectiles in combat.
