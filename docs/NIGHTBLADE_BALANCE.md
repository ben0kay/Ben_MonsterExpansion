# Nightblade balance pass — Witch Hunter playthrough

**Status:** implemented in `config/player_skills.json` on `dev`; **not yet compiled or verified in-game**.
**Scope:** improve selected **existing** Nightblade skills in addition to the separate [Raise Skeletons proposal](NIGHTBLADE_RAISE_SKELETONS_PLAN.md). None of the skeleton-plan phases are implemented by this balance pass.

## Playthrough changes (native rank curves retained)

| Skill record / actual skill | Changed field(s) | Change |
| --- | --- | --- |
| `eviscerate1` — Amarasta's Blade Burst | `offensiveColdMin`, `offensiveColdMax`, `offensiveSlowColdMin`, `skillTargetRadius` | +15% Cold and Frostburn damage across all 26 native ranks; +20% radius at each rank (3.0 -> 3.6 at rank 1, 5.5 -> 6.6 at rank 26) |
| `eviscerate1` — Amarasta's Blade Burst | `skillCooldownTime` | 1.8 -> 1.5 sec; weapon damage, freeze chance, energy costs and existing modifiers unchanged |
| `phantomblade` — Phantasmal Blades | `offensivePierceMin`, `offensivePierceMax`, `offensiveSlowBleedingMin` | +15% at every original rank |
| `shadowstrike` — Shadow Strike | `offensiveColdMin`, `offensivePierceMin` | +15% at every rank |
| `shadowstrike` | `skillCooldownTime` | -15%: 3.5 -> 2.975 sec (original follow-up modifiers still work) |
| `ringofsteel` — Ring of Steel | `offensivePierceMin` | +15% at every rank |
| `ringofsteel` | `skillTargetRadius` | +20%: 4.5 -> 5.4 |
| `nightbladeenchant1` — Pneumatic Burst | `skillActiveDuration` | +20%: 60 -> 72 sec |
| `nightbladeenchant1` | `skillLifePercent`, `characterLifeRegen` | +15% at every existing rank |
| `veilofshadows1_buff` — Veil of Shadow aura | `skillTargetRadius` | +20%: 3.0 -> 3.6 at rank 1; 7.5 -> 9.0 at rank 20 |
| `bladetrap1_buff` — Blade Trap effect | `projectileExplosionRadius` | +20% at every rank: 4.0 -> 4.8 at rank 1; 6.0 -> 7.2 at rank 22 |
| `bladetrap1_buff` | `skillActiveDuration` | +15% at every rank: 2.8 -> 3.22 sec at rank 1; 4.5 -> 5.175 at rank 22 |
| `summon_bladespirit` — Blade Spirit | `petLimit` and `petBurstSpawn` | Ranks 1–15: 2 (unchanged); 16–23: 4 instead of 3; 24–26: 5 instead of 4 |
| `pets/petskill_bladeswarm_bladeaura1` — Blade Spirit aura attack | Cold/Pierce flat damage and Bleeding DoT fields | +15% to the original rank curves |
| `pets/petskill_showerofblades1` — Blade Spirit projectiles | Cold/Pierce flat damage and Bleeding DoT fields | +15% to the original rank curves |
| `passive1` — Phantasmal Armor | `defensiveProtection` | +15% to native armor bonus curve |
| `passive2` — Anatomy of Murder | `characterDexterityModifier`, `offensiveSlowBleedingModifier`, `offensiveLifeModifier` | +15% to native modifiers |
| `passive3` — Merciless Repertoire | `offensiveColdModifier`, `offensivePoisonModifier` | +15% to native modifiers |
| `wpattack0` — Dual Blades | `offensivePierceMin`, `offensivePierceModifier` | +15% to native curves |
| `wpattack1` — Belgothian's Shears | `offensivePhysicalMin/Max`, `offensivePierceMin` | +15% to native curves |
| `wpattack2` — Amarasta's Quick Cut | `offensivePierceMin` | +15% to native curve |
| `wpattack3` — Whirling Death | `offensivePierceMin`, `offensiveSlowBleedingMin` | +15% to native curves |
| `wpattack5` — Execution | `offensiveColdMin` | +15% to native curve |

Notes:
- `wpattack4` / Nidalla's Hidden Hand is untouched. Proc chance, attack animation, mana costs, crowd control, resists, movement/attack speed caps and damage-conversion mechanics are unchanged.
- **Blade Spirit is described by the native record as an invincible summoned pet.** Rather than applying meaningless pet HP buffs, this pass improves its damage-skill curves and raises summon counts at the two existing progression milestones. Existing pets and their movement AI are unchanged.
- All adjusted rank curves use the shared multiplier path in `scripts/player_skills.py` and retain their exact native number of ranks. Existing Occultist, Arcanist, devotion and enemy changes are untouched.
- **Exclusive ability audit:** among the inspected Nightblade records, no `exclusiveSkill=1` flags were found (existing relevant flags are already `0`). Therefore no new flag flips were necessary. Previously configured global exclusive-skill handling for other masteries remains active; Nightblade's Veil of Shadow and other sustained skills are not made mutually exclusive by this pass.
- `config/player_skills.json` enables/disables the overall skill customization. Individual records can set `"enabled": false` to restore that record to its original effective DLC/vanilla data without affecting the others.

## Lightweight verification and rebuild

Focused tests were added to `tests/test_player_skills.py` for exact field differences, rank preservation, chosen values, Blade Spirit limit milestones, Amarasta's Blade Burst damage/radius/cooldown, and per-record rollback. They are **committed but not executed** in this GitHub-only edit session; no Asset Manager or in-game testing was performed.

From an updated local `dev` checkout:

```powershell
git switch dev
git pull
python scripts/validate_config.py
python -m unittest discover -s tests -p test_player_skills.py -v
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

Then compile with Asset Manager (F7) and test Nightblade + Occultist in a rebuilt custom game. At minimum verify Shadow Strike and Blade Burst cooldowns, Ring/Trap/Veil/Blade Burst radii, Pneumatic Burst duration and heal, Blade Spirit damage/limit, and that existing skills are still present. Continue with the [separate skeleton addition plan](NIGHTBLADE_RAISE_SKELETONS_PLAN.md) when ready.
