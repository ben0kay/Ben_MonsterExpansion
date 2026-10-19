> **October 19 update:** [Current config-driven families guide](DATA_DRIVEN_FAMILIES.md) supersedes old schema, record counts and config keys below. Generate/stage all families for 30 DBRs. Original boar visuals and proxy/pool selection were verified by the user; new zombies remain untested in-game.

> **Live-test update:** The user successfully spawned the glowing Veteran with 92/92 HP, confirmed it looked/moved well and approved the current appearance. The attachment and asset resolution work in that test; exact RGB tint, combat impact and full death/performance coverage are not independently measured. Aura settings now live in Veteran `prototype.cosmetic_aura` in `config/tiers.json`. For natural spawns use [ME3_NATURAL_SPAWNS.md](ME3_NATURAL_SPAWNS.md). The original research/test plan follows.

# Veteran Boar cosmetic aura — first test

Implemented October 18, 2026; Python validation passes, Asset Manager compilation
and appearance are **not yet tested**. This checkpoint supersedes older statements
that no aura tooling exists. The previous 92 vs 71 HP result remains the baseline.

## Evidence and implementation

All paths below are relative to `ReferenceFiles/`:

- `creatures/enemies/faction/necro_skeleton_b03_priest.dbr` assigns
  `skills/nonplayerskills/buff/skeleton_priestselfaura.dbr` through `skillName7`
  and `initialSkillName`.
- That skill uses `Skill_BuffSelfToggled`, `instantCast=1`, `notDispelable=1`
  and `charFxPakSelfNames`. It ALSO adds fire damage, so we do not clone it.
- `Resources/templates/skill_buffselftoggled.tpl` and its includes establish
  every field used by the new minimal self-only buff. No combat bonus fields
  are emitted; activation/upkeep costs are explicitly zero.
- `fx/skillsother/buff/aethercorruptionaura_selfloop_chfxpak01.dbr` and
  `fx/skillsother/buffoffensive/bonerat_poisonaura_self_chfxpak01.dbr` both
  demonstrate `particleEffectAttachPoints=FXCentered` and `particleEffectNames`.
- We clone `fx/creatures/glownature01_large.dbr` into a custom FX record.
  It references `fx/particlesystems/creature/pfx_glownature_01_lg.pfx`.
  The uploaded binary contains smoke/glow emitter labels and references
  `FX/textures/smokewisp01.tex` and `FX/textures/orbglowingcold_128.tex`;
  both textures are present. This is asset evidence, not a rendered preview.
- The PFX also references the base-game ParticleAdditive shader, absent from
  this upload. We reuse the original base-game resource path, not package or
  rewrite the binary. Runtime resolution is part of the acceptance test.

The generated monster gets skill slot 6 at level 1 and `initialSkillName`.
Occupied slots/initial skills cause generation to fail instead of overwriting.
The original stats, classification, textures, collision and existing skills
remain unchanged relative to the previous generator output.

`charfxpak.tpl` exposes `useTintColor` and RGB fields, but does not establish
whether tint affects particles, actor textures or both. Tint stays disabled.
**The precise #81AF71 color, faint opacity, size and particle intensity are not
implemented or guaranteed.** This first test establishes attachment and visual
suitability. If the large nature effect is excessive, stop here and tune it in
Particle Editor rather than guessing binary offsets or DBR opacity fields.

## Pull, regenerate, stage, build

Run in your repository at `Working/mods/Ben_MonsterExpansion`:

```powershell
git pull
python -m unittest discover -s tests -v
python scripts/validate_config.py
python scripts/generate_variants.py --write --replace-generated
python scripts/prepare_console_test.py
python scripts/prepare_console_test.py --stage --replace-staged
```

Expect **six DBRs**: original monster/bio/damage plus cosmetic skill,
character FX pack and effect. Replacement flags are necessary because you
already generated/staged the earlier monster. The staging helper still checks
an exact allowlist and refuses unrelated files.

Select Ben_MonsterExpansion in Asset Manager, build with F7, and copy the new
`Build/mods/Ben_MonsterExpansion/database/Ben_MonsterExpansion.arz` over the
installed custom mod's `.arz`, as in [BUILD_AND_TEST.md](BUILD_AND_TEST.md).
No new resource archive is produced: this test references a vanilla particle.
Do not copy the Resources reference tree into the mod build.
Restart/reload the Custom Game and spawn a **new** boar:

```text
game.Spawn "records/creatures/enemies/monsterexpansion/boar_veteran_01.dbr"
game.Spawn "records/creatures/enemies/boar_a01.dbr"
```

## Acceptance checks

1. Build succeeds with all six custom DBRs.
2. Veteran effect appears immediately, before combat, and follows movement.
3. Common Boar has no new effect; Veteran textures remain recognizable.
4. Check idle/movement/combat/death: no leftover persistent effect or repeated
   casting, and no unwanted particles on other creatures.
5. At the same monster level/difficulty as before, compare HP (previously
   92 vs 71); otherwise compare at matched levels rather than assuming 92.
6. Check for unwanted damage/buffs, mana drain, sound or camera shake.
7. Judge visual size, brightness and color. Send a screenshot and build log
   if invisible, oversized or unsuitable; do not mark subtle green as verified.

## Reversible switch

Set Veteran `prototype.cosmetic_aura.enabled` to `false` in
`config/tiers.json`, then repeat generation/staging with both replacement
flags, rebuild and reinstall. This restores the original three-record output
and removes the monster's references to the aura. The previous three extra
staged DBRs can remain inert; the helper does not automatically delete files.

## Validation

16 unit tests pass, including unchanged bio/damage output, monster-only aura
wiring, zero-cost/no-stat skill fields, actual template field support, rollback,
occupied-slot rejection and staging allowlist protection. Python checks cannot
prove engine activation, particle appearance or runtime performance.
