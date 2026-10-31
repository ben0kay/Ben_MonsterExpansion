# Soldier mastery — offensive and defensive balance pass

**Branch:** `dev`. **Status:** Configured in GitHub, regression tests authored;
**Python tests and Grim Dawn Asset Manager F7 build have not been run in this
session**. All changes require regenerate, replacement stage and F7 build.
This is a moderate, rank-aware skills pass: no blanket damage increase, new
summons, tree rearrangement or native graphics changes.

## Scope

Fourteen independently reversible original Soldier records are now managed in
`config/player_skills.json`. The pre-existing two Soldier changes
(`stancedefensive.dbr` and `stanceoffensive.dbr`: `exclusiveSkill=0`) remain
unchanged. All source references are read from the uploaded effective
base/GDX1/GDX2 layers, and `ReferenceFiles` is never edited.

### Offensive and area/shape changes

| Skill | Native DBR and field(s) | New settings |
| --- | --- | --- |
| **Forcewave** | `shieldhammer1.dbr`: `waveDistance=10`, `waveStartWidth=3`, `waveEndWidth=4.5` | **11 m**, **3.3 m**, **4.95 m** respectively; **+8%** to native `offensivePhysicalMin` and `offensivePhysicalMax` at every one of 26 ranks |
| **Blade Arc** | `bladearc1.dbr`: `skillTargetAngle=180`, `skillTargetNumber=5` | **195°**, **6 targets**, **+8%** rank-scaled flat `offensivePhysicalMin` |
| **Blitz** | `blitz1.dbr`: cooldown **3.5 s**, max targets **3** | **3.25 s**, **4 targets**, **+5%** native rank-scaled flat Physical damage; original charge-speed modifier remains |
| **War Cry** | `warcry1.dbr`: `skillTargetRadius` **5→18 m** across 22 ranks | Every original radius multiplied **1.10**, **5.5→19.8 m**; cooldown, damage reduction and other debuffs unchanged |
| **Counter Strike** | `counterstrike1.dbr`: radius **5 m** | **5.5 m**; **+8%** native flat Physical damage at every rank; native proc/cooldown unchanged |
| **Zolhan's Technique** | `weaponpool2.dbr`: 22-rank `skillTargetNumber` **2→7** | Preserve ranks **1–11**; **+1 target from ranks 12–22**, reaching **8** at rank 22; attack angles, debuffs and weapon damage untouched |
| **Cadence** | `cadence1.dbr`: 26-rank `offensivePhysicalMin` **24→350** | **+8%** flat Physical damage per native rank; **original `weaponDamagePct` remains 130→550** |
| **Deadly Momentum** | `cadence3_buff.dbr`: `skillActiveDuration=5` | **6 s**; native damage and other effect values unchanged |

**FX boundary:** Forcewave geometry, Blade Arc targeting, War Cry/Counter Strike
targeting radius are supported in the original gameplay DBRs. Enlarging
geometry does **not** guarantee matching particle/animation scale. This pass
does *not* edit visual particle files; inspect in-game before proposing a
separate particle resize. Likewise target caps are field settings, not proof
that every additional enemy will be hit in all combat conditions.

### Defensive and survival changes

| Skill | Native DBR and field(s) | New settings |
| --- | --- | --- |
| **Overguard** | `overguard1.dbr`: **10 s** duration; 22-rank `characterLifeRegenModifier` **50→245** | **11 s** duration; **+8%** relative multiplier at all 22 ranks, **54→264.6**; cooldown stays 16 s |
| **Menhir's Will** | `willtolive1.dbr`: **10 s** duration; 26-rank `characterLifeRegen` **40→705** | **11.5 s** duration; **+8%** to native flat life regeneration values at all 26 ranks; native HP trigger and per-rank cooldown unchanged |
| **Fighting Spirit** | `fightingspirit1.dbr`: duration **5→10 s** over 22 ranks | **+15%** per-rank duration (**5.75→11.5 s**); activation, damage, OA, native cooldown unchanged |
| **Military Conditioning** | `passive1.dbr`: 20-rank Physique and Health percentage-bonus curves | **+5% relative** to each native `characterStrengthModifier` and `characterLifeModifier` number; not +5 percentage points |
| **Shield Training** | `passiveshield.dbr`: 20-rank `defensiveBlockModifier` **2→24** | **+8% relative** to the original shield block bonus curve |
| **Decorated Soldier** | `passive3.dbr`: 18-rank Elemental resistance, Physical damage, and Pierce damage bonus curves | **+5% relative** to `defensiveElementalResistance`, `offensivePhysicalModifier` and `offensivePierceModifier`; existing slow/other resistance values unchanged |

**What is not changed:** Field Command, Squad Tactics, Fighting Form,
Rending Force, Menhir's Bulwark, Oleron's Rage (other than their previously
configured exclusivity flags), all Soldier skill prerequisites,
mastery-bar stats, damage conversion, and all custom enemy, pet, loot and XP
systems. Avoid additional buffs to Cadence's weapon-damage multiplier or
large ability cooldown changes without separate balance review.

## Build, regression and rollback

Each of the 14 records is a separate `config/player_skills.json` entry
with only `set` literals and/or `curves` multipliers. No changes to
`scripts/player_skills.py` are required; the existing generator supports
rank-aware curves. To revert a specific Soldier record, set that entry's
`enabled` to `false`, regenerate, use replacement staging and rebuild.
Do not simply delete entries if a previously compiled override may remain.

`tests/test_player_skills.py` has two new test methods that verify **all
14** records against the native DBR, constrain exact changed fields, check
every rank and previous Cadence weapon percentages, verify Zolhan's rank
threshold, and exercise **individual** rollback without reverting unrelated
skills. The tests are committed but **have not been executed** in this
GitHub-only session.

From the repository root in a VS Code PowerShell terminal:

```powershell
git switch dev
git pull origin dev
python scripts/validate_config.py
python -m unittest discover -s tests -p test_player_skills.py -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Then rebuild **Ben_MonsterExpansion** with **F7** in Asset Manager and
install the resulting archives. Test Forcewave target/particle alignment,
Blitz cooldown/target reach, Zolhan's rank 11→12 transition, War Cry
radius at low/high ranks, and the defensive proc/duration behavior.
