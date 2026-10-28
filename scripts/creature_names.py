"""Resolve English creature names from the extracted base, GDX1 and GDX2 resources.

These are read-only inputs. Only exact localization-tag matches are accepted;
an internal DBR FileDescription or a filename is never used as a guessed name.
"""
from functools import lru_cache
from pathlib import Path


@lru_cache(maxsize=8)
def _read_creature_tags(root):
    root = Path(root)
    paths = (
        root / "original/Resources/text_en/tags_creatures.txt",
        root / "gdx1/resources/text_en/tagsgdx1_creatures.txt",
        root / "gdx2/resources/text_en/tagsgdx2_creatures.txt",
    )
    # Older extracts placed base resources directly under ReferenceFiles.
    if not paths[0].is_file():
        paths = (root / "Resources/text_en/tags_creatures.txt", *paths[1:])
    translations = {}
    for path in paths:  # Base first; later expansion tags take precedence.
        if not path.is_file():
            continue
        for raw in path.read_text(encoding="utf-8-sig").splitlines():
            line = raw.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            tag, name = line.split("=", 1)
            tag, name = tag.strip(), name.strip()
            if tag.startswith("tag") and name:
                translations[tag] = name
    return translations


def creature_name(description_tag, reference_root):
    """Return a verified localized English name, or None without guessing."""
    if not isinstance(description_tag, str) or not description_tag.startswith("tag"):
        return None
    return _read_creature_tags(str(Path(reference_root).resolve())).get(description_tag)
