"""Configurable base player run-speed adjustment for both character records.

Only characterRunSpeed is changed, using the effective GDX2 > GDX1 > base DBR.
This affects underlying movement, not the item/skill movement-speed bonus cap.
"""
import json
from decimal import Decimal, InvalidOperation
from pathlib import Path

from dbr import DBR
from references import resolve

PLAYER_RECORDS = (
    "records/creatures/pc/malepc01.dbr",
    "records/creatures/pc/femalepc01.dbr",
)


def validate_settings(settings):
    if not isinstance(settings, dict) or set(settings) != {
        "schema_version", "enabled", "base_run_speed_multiplier"
    }:
        raise ValueError("Invalid player movement configuration keys")
    if type(settings["schema_version"]) is not int or settings["schema_version"] != 1:
        raise ValueError("Unsupported player movement schema")
    if type(settings["enabled"]) is not bool:
        raise ValueError("Player movement enabled must be boolean")
    value = settings["base_run_speed_multiplier"]
    if type(value) not in (int, float):
        raise ValueError("Player run-speed multiplier must be numeric, not boolean")
    try:
        multiplier = Decimal(str(value))
    except InvalidOperation as exc:
        raise ValueError("Invalid player run-speed multiplier") from exc
    if not multiplier.is_finite() or not Decimal("0.5") <= multiplier <= Decimal("2.0"):
        raise ValueError("Player run-speed multiplier must be finite and between 0.5 and 2.0")
    return multiplier


def load_settings(repo):
    path = Path(repo) / "config/player_movement.json"
    if not path.exists():
        return None
    settings = json.loads(path.read_text(encoding="utf-8"))
    validate_settings(settings)
    return settings


def build_player_movement(settings, reference):
    """Emit reversible player overrides; preserve every field except run speed."""
    multiplier = validate_settings(settings)
    files, report = {}, []
    for record_path in PLAYER_RECORDS:
        path = resolve(record_path, reference)
        if not path.is_file():
            raise ValueError("Missing player movement reference: " + record_path)
        record = DBR.from_file(path)
        if record.get("templateName") != "database/templates/player.tpl" or record.get("Class") != "Player":
            raise ValueError("Player movement source has unexpected template/class")
        source = record.get("characterRunSpeed")
        try:
            base = Decimal(source)
        except InvalidOperation as exc:
            raise ValueError("Player source run speed is not numeric") from exc
        if not base.is_finite() or base <= 0:
            raise ValueError("Player source run speed must be finite and positive")
        target = source
        if settings["enabled"]:
            target = f"{base * multiplier:.6f}"
            record.set("characterRunSpeed", target)
        files[Path("database") / record_path] = record.render()
        report.append({"record": record_path, "source_run_speed": source,
                       "generated_run_speed": target,
                       "changed": source != target})
    return files, report
