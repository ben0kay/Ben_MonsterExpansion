"""Deterministic player-skill overrides from effective DLC references."""
import json
import math
from pathlib import Path
from dbr import DBR
from references import resolve

def load_settings(repo):
    path = repo / "config/player_skills.json"
    return json.loads(path.read_text()) if path.exists() else None

def build_skills(settings, reference):
    if settings is None:
        return {}, []
    if settings.get("schema_version") != 1 or type(settings.get("enabled")) is not bool:
        raise ValueError("Invalid player skill configuration")
    if not isinstance(settings.get("records"), list):
        raise ValueError("Player skills require a records list")
    files, report = {}, []
    for entry in settings["records"]:
        name = entry["record"]
        if not name.startswith("records/skills/playerclass"):
            raise ValueError("Player skill override outside mastery namespace")
        if type(entry.get("enabled", True)) is not bool:
            raise ValueError("Invalid skill enabled flag")
        for rule in entry.get("curves", {}).values():
            if set(rule) - {"ranks", "multiplier", "multiplier_per_rank", "add", "add_per_rank", "cap"}:
                raise ValueError("Unknown skill curve option")
            if "ranks" in rule and (type(rule["ranks"]) is not int or not 1 <= rule["ranks"] <= 100):
                raise ValueError("Invalid skill curve rank count")
            if any(type(v) not in (int, float) or not math.isfinite(v) for v in rule.values()):
                raise ValueError("Invalid skill curve number")
        record = DBR.from_file(resolve(name, reference))
        before = record.render()
        if settings["enabled"] and entry.get("enabled", True):
            for key, value in entry.get("set", {}).items():
                if key == "characterManaLimitReserve" and not record._locations(key):
                    # Supported by Skill_Bonus include, also used by native toggled buffs.
                    donor = DBR.from_file(resolve("records/skills/playerclass05/elementalinfusion1_buff.dbr", reference))
                    donor.get(key)
                    record.lines.append(f"{key},{value},\n")
                else:
                    record.set(key, str(value))
            for key, rule in entry.get("curves", {}).items():
                source = [float(v) for v in record.get(key).split(";")]
                count = rule.get("ranks", len(source))
                values = []
                for i in range(count):
                    base = source[min(i, len(source)-1)]
                    value = base * (rule.get("multiplier", 1) + i * rule.get("multiplier_per_rank", 0))
                    value += rule.get("add", 0) + i * rule.get("add_per_rank", 0)
                    if "cap" in rule:
                        value = min(value, rule["cap"])
                    if not math.isfinite(value):
                        raise ValueError("Nonfinite skill curve")
                    values.append(format(value, ".6f"))
                record.set(key, ";".join(values))
        target = Path("database") / name
        if target in files:
            raise ValueError("Duplicate skill record: " + name)
        files[target] = record.render()
        report.append({"record": name, "changed": before != record.render()})
    return files, report
