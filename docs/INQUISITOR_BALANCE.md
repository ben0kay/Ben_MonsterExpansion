# Inquisitor first-pass enhancement — Mage Hunter support

**Branch:** `dev`. **Status:** configured in existing player skill generator,
focused tests authored; Asset Manager F7 and in-game behavior are **not verified**.
This pass does **not** add new mastery-tree abilities, summon lines, class UI or
cross-mastery skills. Changes are deliberately moderate and reversible.

## Scope

The user wants an Elemental/Aether **Arcanist + Inquisitor (Mage Hunter)** with
ranged weapon support, wider spell areas, more projectiles and practical
defensive/deployable abilities. Original Inquisitor `playerclass07` skill DBRs
come from **Ashes of Malmouth (GDX1)**, resolved through the existing
GDX2 > GDX1 > base reference priority.

All patches live in `config/player_skills.json` and use the existing
`scripts/player_skills.py` builder. No generator or reference edits are
required. 13 new override entries plus a radius curve on the already-managed
`auracensure1_buff.dbr` record = **14 enhanced Inquisitor records**.

## Exact changes

| Skill | Native logical DBR | Change |
| --- | --- | --- |
| Bursting Round | `playerclass07/wpattack01.dbr` | +10% of each rank's **projectileExplosionRadius** |
| Chilling Rounds | `playerclass07/wpattack02.dbr` | +8% to each rank's **weaponDamagePct** |
| Storm Spread | `playerclass07/wpattack03.dbr` | **3 → 4 projectiles** at ranks 1–6, **4 → 5** at ranks 7–20; original spread rotation and per-projectile weapon damage retained |
| Ranged Expertise | `playerclass07/passive01.dbr` | +5% to each native **characterAttackSpeedModifier** value; +8% to its **offensiveElementalModifier** curve |
| Deadly Aim | `playerclass07/passive02.dbr` | +8% of native Offensive Ability and critical damage bonus curves; duration, proc and cooldown unchanged |
| Word of Pain base debuff | `playerclass07/wordofpain1_buff.dbr` | Radius **3 → 3.3 m**, duration **8 → 9.2 s**, +8% existing flat Fire and Cold damage at each rank |
| Word of Agony | `playerclass07/wordofpain2.dbr` | +10% of native per-rank radius values (e.g. 1.5 → 1.65 at first rank) |
| Death Sentence | `playerclass07/wordofpain3.dbr` | +8% native **offensiveElementalMin** curve; existing Aether resist reduction untouched |
| Lightning Tether | `playerclass07/lightningnet2.dbr` | Max range **18 → 19.8 m**, +8% native flat Lightning damage at each rank |
| Rune of Hagarrad | `playerclass07/icerune.dbr` | Placement limit **5 → 6**; cooldown **4 → 3.6 s** |
| Rune of Kalastor | `playerclass07/concussiverune1.dbr` | Placement limit **5 → 6**; cooldown **4 → 3.6 s** |
| Inquisitor Seal | `playerclass07/arcaneseal1.dbr` | Placement lifetime **24 → 28 s**; cooldown **5 → 4.5 s**, same native limit of 3 |
| Flames of Ignaffar | `playerclass07/purifyingflame1.dbr` | Max range **9.1 → 10.01**, +8% of native Fire damage curve |
| Aura of Censure | `playerclass07/auracensure1_buff.dbr` | +10% of native per-rank radius; **preserves previous `exclusiveSkill=0` setting** |

This increases Storm Spread's total projectile count and potential damage
opportunities; it does **not** redivide per-projectile damage, and may slightly
increase projectile FX overhead. Weapon-pool skills activate with qualifying
default-weapon attacks, not ordinary Arcanist spell casts. Runes are native
targeted-spawn-pet abilities; the limit raises the number concurrently
placeable, **not the number summoned per cast**.

**Not changed:** Normal Inquisitor skill tree, enemy configs, global XP or
spawns, all other masteries, skill rank caps, native resistance-reduction
values, damage type conversion, game-wide attack speed caps or Inquisitor
Seal placement limit. Aura of Conviction's earlier exclusivity adjustment
remains intact.

## Independent rollback

Every newly added skill override has `enabled:true`; switching its flag
to `false` emits the **exact effective native skill DBR** at the same path,
when regenerated/replaced and rebuilt. For Aura of Censure, setting
`curves.skillTargetRadius.multiplier:1` reverts only the new radius
enhancement **while preserving the pre-existing `exclusiveSkill:0`**.
Setting that entire record `enabled:false` reverts its original
exclusivity change as well.

The top-level `config/player_skills.json` `enabled:false` restores all
managed skills, not just Inquisitor; avoid that when rolling back one ability.

## Validation and build

Suggested focused test (authored but not executed via the GitHub connector):

```powershell
python scripts/validate_config.py
python -m unittest discover -s tests -p test_inquisitor_balance.py -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Next **F7** in Asset Manager, install the rebuilt `.arz` and
`Text_EN.arc` as appropriate, then restart the Custom Game.
Check Storm Spread projectiles at skill ranks 1/6/7/10/20, rune
limits and placement, Seal duration, Word of Pain area and Inquisitor
passive bonuses. Compare to an unmodified test character when possible.

## Missing reference files for future mastery skill attachments

**Not required for the balance pass above.** For future addition of
Vire's Might, a Nightblade ability and other tree skills, the repository
still needs the **GDX1 Inquisitor class07 UI records** such as:

```text
ReferenceFiles/gdx1/database/records/ui/skills/class07/classtable.dbr
ReferenceFiles/gdx1/database/records/ui/skills/class07/skill01.dbr
ReferenceFiles/gdx1/database/records/ui/skills/class07/skill02.dbr
... remaining skillXX.dbr records (prefer the entire class07 folder)
```

Extract/copy the game's actual `records/ui/skills/class07/` folder from
the appropriate expansion database reference through Grim Dawn's modding
tools. Keep files in `ReferenceFiles` read-only. Do **not** infer exact
skill-tree button positions or offer cross-mastery attachment until
the original class07 skill panel and buttons are available.
