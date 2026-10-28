# Automatic enemy tier names (Veteran / Elite / Ascended)

**Status:** generator implementation on `dev`; Asset Manager build and live gameplay verification are still required.

## What is generated

All **enabled** variants in `config/families/*.json` are processed. The generator reads each
variant's exact original monster `description` tag, resolves it against the extracted
English creature tags, then writes a **custom-only** tag to the cloned monster:

- `ReferenceFiles/original/Resources/text_en/tags_creatures.txt`
- `ReferenceFiles/gdx1/resources/text_en/tagsgdx1_creatures.txt`
- `ReferenceFiles/gdx2/resources/text_en/tagsgdx2_creatures.txt`

Example: `tagEnemyBoarA01=Stonetusk` generates `Stonetusk (Veteran)`.
A custom Hero name such as `Pavros Undylon, Flamespeaker` becomes
`Pavros Undylon, Flamespeaker (Ascended)` for an enabled variant of that original.

Explicit `display_name` values in family variant configs still take priority
(e.g. the existing Walking Dead overrides). Exact native English punctuation
and proper names are preserved. No monster name is invented from a file stem or
`FileDescription`. If a tag is absent, the cloned DBR retains the native
`description`; the generator reports it as unresolved.

Generated custom strings go into
`source/Text_EN/tags_benmonsterexpansion.txt` inside the generated and staged
plans. Original game DBRs and localization files are never edited.
Only custom variant actor `description` values change; vanilla enemies,
faction subtitles, spawn ratios, stats and skills do not.

The deterministic `manifest.json` includes `name_coverage.named` and a list
`name_coverage.unresolved` (original record + missing tag). The unit tests
require all configured variants to resolve, so newly added families with
untranslated names will be flagged before release.

## Regenerate and build

From the mod repository on `dev`:

```powershell
git pull
python -m unittest discover -s tests -p "test_display_names.py"
python scripts/generate_variants.py --include-spawns --write --replace-generated
python scripts/prepare_console_test.py --include-spawns --stage --replace-staged
```

If name coverage tests fail, inspect `name_coverage.unresolved` in the
generated manifest. The generator can preserve original names for missing tags,
but an unresolved name will **not** receive a tier suffix.

In Grim Dawn Asset Manager, verify `source/Text_EN/tags_benmonsterexpansion.txt`
has had **Auto-Create Asset** applied (one-time setup if not already present).
Build with **F7** and install **both** the newly compiled mod database `.arz`
and the mod's `resources/Text_EN.arc`. Do not replace the base game's text
archive. Restart the Custom Game and check a Veteran, Elite and Ascended name.

Note: a GitHub push updates source code/config only. It does not automatically
regenerate local staged files or rebuild the installed Grim Dawn mod.
