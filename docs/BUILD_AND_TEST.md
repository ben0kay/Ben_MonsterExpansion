> **Natural-spawn update:** See [ME3 instructions](ME3_NATURAL_SPAWNS.md) for the current seven-record build, `--include-spawns` flags, centralized tier settings and rollback. The console-only workflow below does not remove an existing pool override.

> **Aura update:** For the new six-record cosmetic test, use the replacement commands and acceptance checks in [VETERAN_AURA_TEST.md](VETERAN_AURA_TEST.md). Earlier three-record counts below describe the prior successful baseline.

# Build, Install and Test — Ben_MonsterExpansion (Windows)

Last updated: 2026-10-18.

This is the quick reference for rebuilding and installing the **custom Grim Dawn mod**. It records our first successful Asset Manager compilation (three Veteran Boar DBR records, `Ben_MonsterExpansion.arz`, approximately 57 KB). **Successful compilation does not yet confirm the Custom Game loads or the Veteran Boar spawns correctly.**

## 1. Local directories

- **Working directory:** `M:\BACKUPS\D_Drive\2025_11_01_D_Drive_Backup_Manual\My Media Content\Modding\Grim Dawn\Working\`
- **Build directory:** `M:\BACKUPS\D_Drive\2025_11_01_D_Drive_Backup_Manual\My Media Content\Modding\Grim Dawn\Build\`
- **GitHub checkout:** `Working\mods\Ben_MonsterExpansion\`
- **Tools directory:** the actual Grim Dawn game installation (check in Asset Manager > Tools > Options).

The **Working** setting points to the parent of `mods`, NOT directly to the repository. Asset Manager may need restarting if you create the mod directory while it is already open. Use **Mod > Select > Ben_MonsterExpansion**; do not create a new mod on top of the GitHub checkout.

## 2. Prepare the Veteran Boar records (VS Code terminal)

Run from the repository root:

```powershell
git pull
python scripts/validate_config.py
python -m unittest discover -s tests -v
python scripts/generate_variants.py --write
python scripts/prepare_console_test.py --stage
```

The final command puts **only three derived DBRs** into the working mod source `database/records/`: the Veteran Boar creature, bio and physical-damage skill. The generator's separate `generated/` area and vanilla `ReferenceFiles/` are not installed. If the staging script refuses to overwrite changed files, investigate before using any replacement flag.

For additional preflight and safeguards, see [debug/README.md](../debug/README.md).

## 3. Build with Grim Dawn Asset Manager

1. Open `AssetManager.exe` from the real Grim Dawn installation, choose **Work Offline** if prompted.
2. **Tools > Options:** verify Working, Build and Tools as above. Keep the **Build** directory separate from the live game install for the initial tests.
3. **Mod > Select > Ben_MonsterExpansion**. Make sure the mod is selected; do not build with `None` selected.
4. **Build > Build** (F7) and inspect the output log.
5. Successful observed output included updates to these three records and closure of the compiled archive:
   - `records/creatures/enemies/monsterexpansion/boar_veteran_01.dbr`
   - `records/creatures/enemies/monsterexpansion/bios/boar_veteran_01_bio.dbr`
   - `records/skills/nonplayerskills/monsterexpansion/boar_veteran_01_damage.dbr`

Expected compiled file:

```text
M:\BACKUPS\D_Drive\2025_11_01_D_Drive_Backup_Manual\My Media Content\Modding\Grim Dawn\Build\mods\Ben_MonsterExpansion\database\Ben_MonsterExpansion.arz
```

Windows path capitalization may differ. A `records` folder may also be visible beside the `.arz` in the Build tree; **do not copy that folder to install the compiled database**.

## 4. Install the compiled mod into Grim Dawn

Copy **only** `Ben_MonsterExpansion.arz` from the Build path above into:

```text
<actual Grim Dawn installation>\mods\Ben_MonsterExpansion\database\Ben_MonsterExpansion.arz
```

Create the `mods\Ben_MonsterExpansion\database` directories if necessary. Do **not** copy the GitHub source checkout, the extracted `ReferenceFiles`, or other base-game archives. If replacing an earlier `.arz`, back it up first.

## 5. Launch and smoke-test

1. Launch Grim Dawn and choose **Custom Game** (not Main Campaign).
2. Look for **Ben_MonsterExpansion**. If it is absent or refuses to load, **stop** and diagnose the Custom Game world/map setup; the compiled records alone may not make the mod playable.
3. If prompted, select an available world (often `world001` if supplied). Use a separate test character.
4. Try opening the developer console (key varies by keyboard/setup; often backtick/tilde, but availability is not yet verified on this installation).
5. Try a vanilla control spawn before testing the custom enemy:

```text
game.Spawn "records/creatures/enemies/boar_a01.dbr"
```

Then attempt:

```text
game.Spawn "records/creatures/enemies/monsterexpansion/boar_veteran_01.dbr"
```

**The console command is our provisional test method, not a custom in-game GUI.** Its behavior still needs on-device verification. Report the exact console error if it fails.

## 6. What to verify

- [x] Asset Manager recognizes and selects `Ben_MonsterExpansion`.
- [x] Initial build log shows the three boar-related DBRs compiled and an `.arz` created.
- [ ] Compiled archive copied into the game's installation.
- [ ] Custom Game appears and loads.
- [ ] Console opens and vanilla boar spawn succeeds.
- [ ] Veteran Boar spawns and renders.
- [ ] Veteran moves, attacks, receives damage, and demonstrates expected stats/scale.
- [ ] Collision, melee reach, effects and level behavior inspected.

The Veteran Boar's intended changes are approximately **+30% life, +8% defensive ability, +10% physical passive base damage, +10% visual scale**. These are generated-record changes, **not yet confirmed gameplay measurements**. It has **no green glow**, and natural spawn pools remain untouched.

## Troubleshooting

- **Mod not listed in Asset Manager:** restart Asset Manager after creating `Working\mods\Ben_MonsterExpansion`, then check **Tools > Options > Working**.
- **Build failed:** capture the full Asset Manager log; confirm the correct mod is selected.
- **Mod absent from Custom Game:** verify the installed `.arz` path and investigate whether a Custom Game world/map is required.
- **Console or spawn fails:** capture the exact message and compare with the vanilla command. Do not modify the original installation's `database\database.arz`.
- **Changes not visible:** rerun generation and staging, rebuild, and recopy the latest `.arz` to the game folder.

## Next after the smoke test

Once direct spawning is verified, implement an isolated Veteran Boar spawn-pool/proxy integration (ME3). The eventual debug hotkey GUI, directional spawning and new tier colors/FX are **future work**, not part of this initial build.
