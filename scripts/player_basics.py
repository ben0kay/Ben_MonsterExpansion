"""Config-driven starting stats, speed bonus cap and default camera tuning.

Compose player health/energy onto existing base-movement outputs.
Original reference DBRs are never edited.
"""
import json
from pathlib import Path

from dbr import DBR
from references import resolve
from player_movement import PLAYER_RECORDS

ENGINE_RECORD = "records/game/gameengine.dbr"
ENGINE_OUTPUT = Path("database") / ENGINE_RECORD


def validate_settings(settings):
    if not isinstance(settings, dict) or set(settings) != {
        "schema_version", "starting_stats", "movement_speed_cap", "camera"
    } or type(settings["schema_version"]) is not int or settings["schema_version"] != 1:
        raise ValueError("Invalid player basics schema")
    fields = {
        "starting_stats": {"enabled", "health", "energy"},
        "movement_speed_cap": {"enabled", "max_percent"},
        "camera": {"enabled", "default_distance"},
    }
    for name, required in fields.items():
        section = settings[name]
        if not isinstance(section, dict) or set(section) != required or type(section["enabled"]) is not bool:
            raise ValueError("Invalid player basics section: " + name)
    for name in ("health", "energy"):
        value = settings["starting_stats"][name]
        if type(value) is not int or not 1 <= value <= 100000:
            raise ValueError("Invalid starting " + name)
    cap = settings["movement_speed_cap"]["max_percent"]
    if type(cap) is not int or not 100 <= cap <= 350:
        raise ValueError("Invalid player speed cap")
    distance = settings["camera"]["default_distance"]
    if type(distance) is not int or not 1 <= distance <= 200:
        raise ValueError("Invalid camera default distance")
    return settings


def load_settings(repo):
    path = Path(repo) / "config/player_basics.json"
    if not path.exists():
        return None
    settings = json.loads(path.read_text(encoding="utf-8"))
    return validate_settings(settings)


def build_player_basics(settings, reference, prior_player_files=None):
    validate_settings(settings)
    prior_player_files = prior_player_files or {}
    player_paths = {Path("database") / name for name in PLAYER_RECORDS}
    if set(prior_player_files) - player_paths:
        raise ValueError("Unexpected prior player override")
    files, player_report = {}, []
    stats = settings["starting_stats"]
    for name in PLAYER_RECORDS:
        dest = Path("database") / name
        path = resolve(name, reference)
        if not path.is_file():
            raise ValueError("Missing player reference: " + name)
        base = DBR.from_file(path)
        current = DBR(prior_player_files[dest]) if dest in prior_player_files else DBR.from_file(path)
        if base.get("templateName") != "database/templates/player.tpl" or base.get("Class") != "Player":
            raise ValueError("Unexpected player template/class")
        if current.get("templateName") != base.get("templateName") or current.get("Class") != "Player":
            raise ValueError("Incompatible player override")
        for field, requested in (("characterLife", stats["health"]), ("characterMana", stats["energy"])):
            # Disabled sections explicitly restore original field values.
            current.set(field, f"{requested:.6f}" if stats["enabled"] else base.get(field))
        files[dest] = current.render()
        player_report.append({"record": name, "run_speed": current.get("characterRunSpeed"),
                              "health": current.get("characterLife"),
                              "energy": current.get("characterMana")})

    engine_path = resolve(ENGINE_RECORD, reference)
    if not engine_path.is_file():
        raise ValueError("Missing game-engine reference")
    engine = DBR.from_file(engine_path)
    if engine.get("templateName") != "database/templates/gameengine.tpl":
        raise ValueError("Unexpected game-engine template")
    distance = settings["camera"]["default_distance"]
    if not float(engine.get("CameraDistanceMin")) <= distance <= float(engine.get("CameraDistanceMax")):
        raise ValueError("Camera default outside original zoom range")
    cap = settings["movement_speed_cap"]["max_percent"]
    if cap > float(engine.get("absoluteRunSpeedCapMax")):
        raise ValueError("Player cap exceeds absolute movement cap")
    if settings["camera"]["enabled"]:
        engine.set("CameraDistanceDefault", f"{distance:.6f}")
    if settings["movement_speed_cap"]["enabled"]:
        engine.set("playerRunSpeedCapMax", f"{cap:.6f}")
    files[ENGINE_OUTPUT] = engine.render()
    report = {"players": player_report,
              "engine": {"movement_cap": engine.get("playerRunSpeedCapMax"),
                         "camera_default": engine.get("CameraDistanceDefault"),
                         "camera_min": engine.get("CameraDistanceMin"),
                         "camera_max": engine.get("CameraDistanceMax")}}
    return files, report
