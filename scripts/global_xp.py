"""Global monster-kill XP multiplier, separate from tier-specific variant rewards.

Apply to the four original monster XP equations, not quest XP, level XP costs,
death penalty, or the existing per-variant experiencePoints field.
"""
import json
import math
from pathlib import Path

from dbr import DBR
from references import resolve


RECORD = "records/game/experienceformulas.dbr"
OUTPUT_RECORD = Path("database") / RECORD
EQUATIONS = (
    "experienceEquation",
    "challengeExperienceEquation",
    "eliteExperienceEquation",
    "ultimateExperienceEquation",
)


def validate_settings(settings):
    if (not isinstance(settings, dict)
            or set(settings) != {"enabled", "multiplier"}
            or type(settings["enabled"]) is not bool):
        raise ValueError("Global XP requires enabled bool and multiplier")
    factor = settings["multiplier"]
    if (type(factor) not in (int, float) or not math.isfinite(factor)
            or not 0 < factor <= 10):
        raise ValueError("Global XP multiplier must be finite, >0 and <=10")
    return settings


def load_settings(repo):
    path = Path(repo) / "config/master.json"
    if not path.exists():
        return None
    data = json.loads(path.read_text(encoding="utf-8"))
    if data.get("schema_version") != 1:
        raise ValueError("Unsupported master config schema")
    section = data.get("global_xp")
    return validate_settings(section) if section is not None else None


def build_global_xp(settings, reference):
    validate_settings(settings)
    path = resolve(RECORD, reference)
    if not path.is_file() or path.is_symlink():
        raise ValueError("Missing or unsafe native experience formulas")
    record = DBR.from_file(path)
    if record.get("templateName") != "database/templates/experienceformulas.tpl":
        raise ValueError("Unexpected experience-formulas template")
    # Validate every equation before patching; never silently rewrite an
    # unexpected DLC formula or a death/quest XP formula.
    originals = {}
    for field in EQUATIONS:
        expression = record.get(field)
        if not all(token in expression for token in (
                "monsterLevel", "averagePartyLevel", "monsterExperience")):
            raise ValueError("Unexpected native monster XP equation: " + field)
        originals[field] = expression
    factor = settings["multiplier"]
    if settings["enabled"] and factor != 1:
        suffix = format(factor, ".12g")
        for field, expression in originals.items():
            record.set(field, f"({expression}) * {suffix}")
    # The record is always generated: at disabled/x1, the exact original
    # record overwrites any previously staged multiplier.
    return record.render()
