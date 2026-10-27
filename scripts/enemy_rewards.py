"""Per-variant XP input scaling; global XP equations and reward eligibility stay unchanged."""
from decimal import Decimal, InvalidOperation, ROUND_HALF_UP
import re


def validate_settings(settings):
    if settings is None:
        return
    if not isinstance(settings, dict) or set(settings) != {"enabled"} or type(settings["enabled"]) is not bool:
        raise ValueError("Invalid tier experience_reward settings")


def scaled_experience_points(raw, health_multiplier):
    """Scale the formula's (1 + monsterExperience/100) term, rounded to a DBR integer."""
    if not isinstance(raw, str) or not re.fullmatch(r"[0-9]+", raw):
        raise ValueError("Enemy experiencePoints must be a nonnegative integer")
    try:
        factor = Decimal(str(health_multiplier))
        if not factor.is_finite() or factor < 1:
            raise ValueError("Invalid enemy XP health multiplier")
        value = ((Decimal(raw) + 100) * factor - 100).quantize(Decimal(1), rounding=ROUND_HALF_UP)
    except InvalidOperation as exc:
        raise ValueError("Invalid enemy XP scaling value") from exc
    if not 0 <= value <= 2147483647:
        raise ValueError("Enemy experiencePoints exceeds the DBR integer range")
    return str(int(value))


def apply_experience_reward(monster, prototype):
    settings = prototype.get("experience_reward")
    validate_settings(settings)
    if settings and settings["enabled"]:
        monster.set("experiencePoints", scaled_experience_points(
            monster.get("experiencePoints"), prototype["stats_vs_parent"]["health"]))
