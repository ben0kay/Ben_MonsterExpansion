"""Attach Inquisitor Vire's Might and the Nightblade-buffed Blade Spirit.

Uses audited native skill/UI donors. Vire's Might sits at mastery-10 between
Bursting Round and Chilling Rounds; the original circular Word of Renewal
transmuter is moved slightly lower to avoid overlapping the new button.
"""
import json
import re
from pathlib import Path

from dbr import DBR
from references import resolve

TREE = "records/skills/playerclass07/_classtree_class07.dbr"
PANEL = "records/ui/skills/class07/classtable.dbr"
BLADE_SOURCE = "records/skills/playerclass04/summon_bladespirit.dbr"

DONORS = {
    "vires_might": {
        "source": "records/skills/playerclass09/viremight1.dbr",
        "target": "records/skills/playerclass07/ben_viremight1.dbr",
        "button_source": "records/ui/skills/class09/skill21.dbr",
        "button_target": "records/ui/skills/class07/skill33.dbr",
        "position": [486, 39],
        "skill_class": "Skill_AttackPathCharge",
        "template": "database/templates/skill_attackpathcharge.tpl",
    },
    "blade_spirit": {
        "source": BLADE_SOURCE,
        "target": "records/skills/playerclass07/ben_summon_bladespirit.dbr",
        "button_source": "records/ui/skills/class04/skill19.dbr",
        "button_target": "records/ui/skills/class07/skill34.dbr",
        "position": [886, 459],
        "skill_class": "Skill_TargetedSpawnPet",
        "template": "database/templates/skill_targetedspawnpet.tpl",
    },
}

# Audited against all 32 original GDX1 class07 button DBRs uploaded in
# commit 25c32486. Only the circular skill30 transmuter needs to move
# so the native mastery-10 column can accommodate Vire's Might.
NATIVE_BUTTON_COORDS = (
    (646, 389), (806, 389), (886, 319), (886, 109),
    (486, 459), (406, 109), (566, 109), (726, 109),
    (326, 319), (486, 319), (726, 319), (246, 389),
    (486, 389), (246, 39), (406, 459), (806, 459),
    (406, 249), (566, 249), (726, 249), (886, 249),
    (806, 179), (246, 179), (406, 179), (646, 179),
    (326, 39), (566, 39), (806, 39), (326, 421),
    (486, 211), (486, 71), (646, 459), (726, 421),
)
RELOCATED_BUTTON = "records/ui/skills/class07/skill30.dbr"
NATIVE_RELOCATED_POSITION = (486, 71)
RELOCATED_POSITION = (486, 145)
RELOCATED_BUTTON_SKILL = "records/skills/playerclass07/hunteraura1b.dbr"


def load_settings(repo):
    path = Path(repo) / "config/inquisitor_extras.json"
    if not path.exists():
        return None
    data = json.loads(path.read_text(encoding="utf-8"))
    validate_settings(data)
    return data


def validate_settings(settings):
    if (not isinstance(settings, dict)
            or set(settings) != {"schema_version", "enabled", "tree", "panel", "skills", "relocated_buttons"}
            or type(settings["schema_version"]) is not int
            or settings["schema_version"] != 1
            or type(settings["enabled"]) is not bool
            or settings["tree"] != TREE or settings["panel"] != PANEL
            or not isinstance(settings["skills"], list)
            or len(settings["skills"]) != 2):
        raise ValueError("Invalid Inquisitor attachment schema")
    if settings["relocated_buttons"] != {
            RELOCATED_BUTTON: list(RELOCATED_POSITION)}:
        raise ValueError("Unreviewed Inquisitor transmuter relocation")
    active_vire = settings["enabled"] and any(
        entry["id"] == "vires_might" and entry["enabled"]
        for entry in settings["skills"])
    occupied_positions = list(NATIVE_BUTTON_COORDS)
    if active_vire:
        occupied_positions[29] = RELOCATED_POSITION  # Original skill30
    seen = set()
    for entry in settings["skills"]:
        if not isinstance(entry, dict) or set(entry) != {
            "id", "enabled", "source", "target", "button_source",
            "button_target", "position"
        } or type(entry["enabled"]) is not bool:
            raise ValueError("Invalid Inquisitor skill entry")
        name = entry["id"]
        if name not in DONORS or name in seen:
            raise ValueError("Unexpected or duplicate Inquisitor skill")
        seen.add(name)
        donor = DONORS[name]
        if any(entry[key] != donor[key] for key in (
            "source", "target", "button_source", "button_target", "position"
        )):
            raise ValueError("Inquisitor skill differs from approved native donor")
        x, y = entry["position"]
        if not (246 <= x <= 886 and 39 <= y <= 459):
            raise ValueError("Inquisitor extra button outside native panel")
        if settings["enabled"] and entry["enabled"] and any(
                abs(x-a) < 60 and abs(y-b) < 60
                for a, b in occupied_positions):
            raise ValueError("Inquisitor extra button overlaps native button")
    if seen != set(DONORS):
        raise ValueError("Both approved Inquisitor skills must be configured")
    pts = [tuple(entry["position"]) for entry in settings["skills"]]
    if abs(pts[0][0] - pts[1][0]) < 60 and abs(pts[0][1] - pts[1][1]) < 60:
        raise ValueError("Inquisitor extra buttons overlap")
    return settings


def build_attachment(settings, reference, existing_skill_files):
    if settings is None:
        return {}, None
    validate_settings(settings)
    reference = Path(reference)
    tree = DBR.from_file(resolve(TREE, reference))
    panel = DBR.from_file(resolve(PANEL, reference))
    if (tree.get("templateName") != "database/templates/skilltree.tpl"
            or panel.get("templateName") !=
            "database/templates/ingameui/skillpanectrl.tpl"):
        raise ValueError("Inquisitor UI donor template mismatch")
    buttons = panel.get("tabSkillButtons").split(";")
    ordinary = [p for p in buttons if re.fullmatch(
        r"records/ui/skills/class07/skill\d{2}\.dbr", p)]
    if len(ordinary) != len(NATIVE_BUTTON_COORDS) or len(set(buttons)) != len(buttons):
        raise ValueError("Inquisitor UI panel changed; re-audit button coordinates")
    if {int(re.search(r"skill(\d{2})\.dbr$", p).group(1)) for p in ordinary} != set(range(1,33)):
        raise ValueError("Unexpected original Inquisitor button numbering")
    tree_names = {
        int(match.group(1)) for line in tree.lines
        if (match := re.match(r"skillName(\d+),", line))
    }
    if tree_names != set(range(1,35)):
        raise ValueError("Inquisitor tree no longer has its expected 34 native skills")
    template = reference / "original/database/templates/skilltree.tpl"
    if not template.is_file():
        raise ValueError("Missing native skilltree template")
    template_text = template.read_text(encoding="utf-8-sig")

    files = {}
    active = []
    def emit(logical, record):
        resolve(logical, reference)  # Only valid, safely rooted logical paths.
        path = Path("database") / logical
        if path in files:
            raise ValueError("Duplicate Inquisitor attachment record")
        files[path] = record.render()

    # Emit an exact native rollback record when Vire's Might is disabled.
    # While enabled, move only the original circular transmuter button
    # down into the available gap; leave its skill and links unchanged.
    transmuter = DBR.from_file(resolve(RELOCATED_BUTTON, reference))
    if (transmuter.get("skillName") != RELOCATED_BUTTON_SKILL
            or (int(transmuter.get("bitmapPositionX")),
                int(transmuter.get("bitmapPositionY"))) != NATIVE_RELOCATED_POSITION):
        raise ValueError("Inquisitor skill30 native donor changed")
    if settings["enabled"] and next(
            entry for entry in settings["skills"] if entry["id"] == "vires_might")["enabled"]:
        transmuter.set("bitmapPositionX", str(RELOCATED_POSITION[0]))
        transmuter.set("bitmapPositionY", str(RELOCATED_POSITION[1]))
    emit(RELOCATED_BUTTON, transmuter)

    for entry in settings["skills"]:
        donor = DONORS[entry["id"]]
        source = entry["source"]
        if entry["id"] == "blade_spirit":
            # Use the already-generated Nightblade balance record; never fork
            # a second Blade Spirit pet progression or hardcode its old caps.
            skill_path = Path("database") / BLADE_SOURCE
            if skill_path not in existing_skill_files:
                raise ValueError("Enhanced Nightblade Blade Spirit record missing")
            skill = DBR(existing_skill_files[skill_path])
            parent = DBR.from_file(resolve(source, reference))
            if (skill.get("petBurstSpawn") !=
                    skill.get("petLimit") or
                    skill.get("petLimit") == parent.get("petLimit")):
                raise ValueError("Nightblade Blade Spirit summon buffs not applied")
        else:
            skill = DBR.from_file(resolve(source, reference))
        if (skill.get("templateName") != donor["template"]
                or skill.get("Class") != donor["skill_class"]):
            raise ValueError("Unexpected native Inquisitor skill donor")

        button = DBR.from_file(resolve(entry["button_source"], reference))
        if button.get("skillName") != source or button.get("templateName") != (
                "database/templates/ingameui/skillbutton.tpl"):
            raise ValueError("Inquisitor donor skill button mismatch")
        button.set("skillName", entry["target"])
        button.set("bitmapPositionX", str(entry["position"][0]))
        button.set("bitmapPositionY", str(entry["position"][1]))
        if entry["id"] == "vires_might" and settings["enabled"] and entry["enabled"]:
            # No Oathkeeper modifiers are cloned. Remove only the orphaned
            # connector strips; preserve the original rush and FX otherwise.
            skill.set("skillConnectionOff", "")
            skill.set("skillConnectionOn", "")
        emit(entry["target"], skill)
        emit(entry["button_target"], button)

        if settings["enabled"] and entry["enabled"]:
            slot = 35 + len(active)
            for field in (f"skillName{slot}", f"skillLevel{slot}"):
                if f'name = "{field}"' not in template_text:
                    raise ValueError("Inquisitor tree exceeds native template")
            if tree._locations(f"skillName{slot}"):
                raise ValueError("Inquisitor extra skill-tree slot occupied")
            if tree._locations(f"skillLevel{slot}"):
                if tree.get(f"skillLevel{slot}") != "0":
                    raise ValueError("Inquisitor extra skill level slot occupied")
            else:
                tree.lines.append(f"skillLevel{slot},0,\n")
            tree.lines.append(f"skillName{slot},{entry['target']},\n")
            buttons.append(entry["button_target"])
            active.append(entry["id"])

    if active:
        panel.set("tabSkillButtons", ";".join(buttons))
    emit(TREE, tree)
    emit(PANEL, panel)
    return files, {
        "enabled": settings["enabled"],
        "active_skills": active,
        "blade_spirit_uses_enhanced_nightblade_skill": True,
        "movement_donor": "native Oathkeeper Vire's Might",
        "relocated_native_button": RELOCATED_BUTTON if active and "vires_might" in active else None,
        "in_game_verified": False,
    }
