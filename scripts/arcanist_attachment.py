"""Reversible Arcanist skeleton line and standalone Guardian of Empyrion.

The 3-skill Necromancer skeleton tree is cloned without forking pet actors.
The Oathkeeper guardian is a standalone native summon with no new transmuters.
Five unconnected Arcanist buttons are rehomed only while skeletons are enabled.
"""
import json
import re
from pathlib import Path

from dbr import DBR
from references import resolve

TREE = "records/skills/playerclass05/_classtree_class05.dbr"
PANEL = "records/ui/skills/class05/classtable.dbr"
PREFIX = "records/ui/skills/class05/"
SKILL_PREFIX = "records/skills/playerclass05/"
SKELETON_SOURCES = [
    "records/skills/playerclass08/summon_skeleton1.dbr",
    "records/skills/playerclass08/summon_skeleton2.dbr",
    "records/skills/playerclass08/summon_skeleton3_petmodifier.dbr",
]
SKELETON_BUTTON_SOURCES = [
    "records/ui/skills/class08/skill22.dbr",
    "records/ui/skills/class08/skill23.dbr",
    "records/ui/skills/class08/skill24.dbr",
]
SKELETON_TARGETS = [
    SKILL_PREFIX + "ben_raiseskeletons1.dbr",
    SKILL_PREFIX + "ben_raiseskeletons2.dbr",
    SKILL_PREFIX + "ben_raiseskeletons3_petmodifier.dbr",
]
SKELETON_BUTTON_TARGETS = [PREFIX + f"skill{i}.dbr" for i in (32, 33, 34)]
SKELETON_POSITIONS = [(246, 459), (406, 459), (566, 459)]
GUARDIAN_SOURCE = "records/skills/playerclass09/summon_celestialguardian1.dbr"
GUARDIAN_BUTTON_SOURCE = "records/ui/skills/class09/skill19.dbr"
GUARDIAN_TARGET = SKILL_PREFIX + "ben_summon_celestialguardian1.dbr"
GUARDIAN_BUTTON_TARGET = PREFIX + "skill35.dbr"
GUARDIAN_POSITION = (726, 179)

# Original class05 UI panel uses 1-26 and 28-31, skipping 27. All coordinates
# verified from the base-game record files before preparing this patch.
NATIVE_BUTTON_POSITIONS = {
    1:(646,319), 2:(886,319), 3:(246,249), 4:(486,249),
    5:(646,249), 6:(806,249), 7:(886,249), 8:(326,179),
    9:(566,179), 10:(566,459), 11:(246,459), 12:(486,459),
    13:(726,459), 14:(806,459), 15:(406,109), 16:(246,39),
    17:(406,39), 18:(406,389), 19:(566,389), 20:(806,389),
    21:(486,109), 22:(726,109), 23:(886,109), 24:(886,389),
    25:(326,319), 26:(566,319), 28:(406,211), 29:(726,281),
    30:(326,71), 31:(646,39),
}
# Rehome only standalone passives and Nullification. Preserve original X
# mastery-tier columns; do not relocate dependent modifiers/transmuters.
MOVES = {
    PREFIX + "skill10.dbr":(566,109),  # Nullification
    PREFIX + "skill11.dbr":(246,109),  # Inner Focus
    PREFIX + "skill12.dbr":(486,39),   # Arcane Will
    PREFIX + "skill13.dbr":(726,39),   # Mental Alacrity
    PREFIX + "skill14.dbr":(806,179),  # Fabric of Reality
}
EXPECTED_MOVE_SKILLS = {
    "skill10.dbr":"nullification",
    "skill11.dbr":"passive01",
    "skill12.dbr":"passive02",
    "skill13.dbr":"passive03",
    "skill14.dbr":"passive04",
}


def load_settings(repo):
    path = Path(repo) / "config/arcanist_summons.json"
    if not path.exists():
        return None
    settings = json.loads(path.read_text(encoding="utf-8"))
    validate_settings(settings)
    return settings


def validate_settings(settings):
    if (not isinstance(settings, dict) or set(settings) != {
            "schema_version", "enabled", "tree", "panel",
            "skeletons", "guardian", "relocated_buttons"
    } or type(settings["schema_version"]) is not int
            or settings["schema_version"] != 1 or type(settings["enabled"]) is not bool
            or settings["tree"] != TREE or settings["panel"] != PANEL):
        raise ValueError("Invalid Arcanist attachment configuration")
    skeletons, guardian = settings["skeletons"], settings["guardian"]
    if (not isinstance(skeletons, dict) or set(skeletons) != {"enabled", "skills"}
            or type(skeletons["enabled"]) is not bool
            or not isinstance(skeletons["skills"], list)
            or len(skeletons["skills"]) != 3):
        raise ValueError("Invalid Arcanist skeleton line")
    for i, entry in enumerate(skeletons["skills"]):
        allowed = {
            "source":SKELETON_SOURCES[i],
            "target":SKELETON_TARGETS[i],
            "button_source":SKELETON_BUTTON_SOURCES[i],
            "button_target":SKELETON_BUTTON_TARGETS[i],
            "position":list(SKELETON_POSITIONS[i]),
            "set":{"petBurstSpawn":"4","petLimit":"4"} if i == 0 else {},
        }
        if not isinstance(entry, dict) or entry != allowed:
            raise ValueError("Unexpected Arcanist skeleton donor or position")
    allowed_guardian = {
        "enabled":guardian.get("enabled") if isinstance(guardian, dict) else None,
        "source":GUARDIAN_SOURCE,
        "target":GUARDIAN_TARGET,
        "button_source":GUARDIAN_BUTTON_SOURCE,
        "button_target":GUARDIAN_BUTTON_TARGET,
        "position":list(GUARDIAN_POSITION),
    }
    if (not isinstance(guardian, dict)
            or type(guardian.get("enabled")) is not bool
            or guardian != allowed_guardian):
        raise ValueError("Unexpected Guardian of Empyrion donor or position")
    moves = settings["relocated_buttons"]
    if (not isinstance(moves, dict)
            or moves != {p:list(xy) for p, xy in MOVES.items()}):
        raise ValueError("Unreviewed original Arcanist button moves")
    return settings


def build_attachment(settings, reference):
    if settings is None:
        return {}, None
    validate_settings(settings)
    reference = Path(reference)

    def source(logical):
        return DBR.from_file(resolve(logical, reference))

    tree, panel = source(TREE), source(PANEL)
    if (tree.get("templateName") != "database/templates/skilltree.tpl"
            or panel.get("templateName") !=
            "database/templates/ingameui/skillpanectrl.tpl"):
        raise ValueError("Arcanist tree/panel templates changed")
    original_buttons = panel.get("tabSkillButtons").split(";")
    native = [p for p in original_buttons
              if re.fullmatch(r"records/ui/skills/class05/skill\d{2}\.dbr", p)]
    expected = {PREFIX + f"skill{i:02}.dbr" for i in NATIVE_BUTTON_POSITIONS}
    if set(native) != expected or len(native) != len(expected):
        raise ValueError("Arcanist skill-button list changed; inspect native layout")
    slots = {int(match.group(1)) for line in tree.lines
             if (match := re.match(r"skillName(\d+),", line))}
    if slots != set(range(1, 32)):
        raise ValueError("Arcanist native tree no longer has 31 skills")

    activated_skeletons = settings["enabled"] and settings["skeletons"]["enabled"]
    activated_guardian = settings["enabled"] and settings["guardian"]["enabled"]
    coordinates = {}
    files = {}

    def emit(logical, record):
        resolve(logical, reference)
        target = Path("database") / logical
        if target in files:
            raise ValueError("Duplicate Arcanist generated record")
        files[target] = record.render()

    for key in native:
        original = source(key)
        m = re.fullmatch(r"records/ui/skills/class05/skill(\d{2})\.dbr", key)
        number = int(m.group(1))
        pos = (int(original.get("bitmapPositionX")),
               int(original.get("bitmapPositionY")))
        if pos != NATIVE_BUTTON_POSITIONS[number]:
            raise ValueError("Unreviewed original Arcanist UI layout: " + key)
        if key in MOVES:
            original_skill = original.get("skillName")
            if not original_skill.endswith("/" + EXPECTED_MOVE_SKILLS[key.rsplit("/", 1)[-1]] + ".dbr"):
                raise ValueError("Expected to move a standalone passive/Nullification only")
            if activated_skeletons:
                pos = MOVES[key]
                original.set("bitmapPositionX", str(pos[0]))
                original.set("bitmapPositionY", str(pos[1]))
            emit(key, original)  # Also emit originals for disabled-state rollback.
        coordinates[key] = pos

    template_path = reference / "original/database/templates/skilltree.tpl"
    if not template_path.is_file():
        raise ValueError("Missing native skilltree template")
    template = template_path.read_text(encoding="utf-8-sig")
    active = []
    buttons = list(original_buttons)

    def attach(entry, skill, is_active):
        button = source(entry["button_source"])
        if (button.get("templateName") !=
                "database/templates/ingameui/skillbutton.tpl"
                or button.get("skillName") != entry["source"]):
            raise ValueError("Skill button does not match native summon donor")
        xy = tuple(entry["position"])
        button.set("skillName", entry["target"])
        button.set("bitmapPositionX", str(xy[0]))
        button.set("bitmapPositionY", str(xy[1]))
        emit(entry["target"], skill)
        emit(entry["button_target"], button)
        if is_active:
            slot = 32 + len(active)
            for field in (f"skillName{slot}", f"skillLevel{slot}"):
                if f'name = "{field}"' not in template:
                    raise ValueError("Arcanist summon exceeds skilltree template capacity")
                if tree._locations(field):
                    raise ValueError("Arcanist extra skill slot already occupied")
            tree.lines.append(f"skillName{slot},{entry['target']},\n")
            tree.lines.append(f"skillLevel{slot},0,\n")
            buttons.append(entry["button_target"])
            active.append(entry["target"])
            coordinates[entry["button_target"]] = xy

    for i, entry in enumerate(settings["skeletons"]["skills"]):
        skill = source(entry["source"])
        original_class = (
            "Skill_TargetedSpawnPet", "Skill_Modifier",
            "SkillSecondary_PetModifier"
        )[i]
        if skill.get("Class") != original_class:
            raise ValueError("Skeleton skill class changed in native references")
        if i == 0:
            if skill.get("petBurstSpawn") != "3" or skill.get("petLimit") != "3":
                raise ValueError("Unexpected Necromancer base skeleton summon")
            for field, value in entry["set"].items():
                skill.set(field, value)
        attach(entry, skill, activated_skeletons)

    guardian_entry = settings["guardian"]
    guardian = source(GUARDIAN_SOURCE)
    if (guardian.get("Class") != "Skill_TargetedSpawnPet"
            or guardian.get("templateName") !=
            "database/templates/skill_targetedspawnpet.tpl"):
        raise ValueError("Guardian donor is not the expected permanent native summon")
    # Remove only native Oathkeeper modifier connectors because the two
    # Oathkeeper augment skills are not included in this Arcanist attachment.
    for field in ("skillConnectionOff", "skillConnectionOn"):
        guardian.set(field, "")
    attach(guardian_entry, guardian, activated_guardian)

    # Prevent unreviewed UI collisions, including the previously absent
    # original transmuter buttons 28-31 and both newly added summon types.
    places = list(coordinates.items())
    for i, (first, (x, y)) in enumerate(places):
        if not (246 <= x <= 886 and 39 <= y <= 459):
            raise ValueError("Arcanist button outside native skill layout")
        for second, (a, b) in places[i+1:]:
            if abs(x-a) < 60 and abs(y-b) < 60:
                raise ValueError("Overlapping Arcanist buttons: " + first + ", " + second)

    if active:
        panel.set("tabSkillButtons", ";".join(buttons))
    emit(TREE, tree)
    emit(PANEL, panel)
    return files, {
        "skeletons_enabled": activated_skeletons,
        "guardian_enabled": activated_guardian,
        "active_skills": active,
        "original_buttons_moved": len(MOVES) if activated_skeletons else 0,
        "status": "configured; F7 and in-game summon/UI tests required",
    }
