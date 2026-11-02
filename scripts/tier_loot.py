"""Scoped loot-quality boosts for custom enemy variants only.

Two separate native mechanics:
* Epic/Legendary/explicit rare equipment MASTER TABLE selection is reweighted
  in the cloned monster's own equipment slots.
* Ordinary green items usually arise from RARE AFFIXES on common equipment.
  These need tier-private master->level->dynamic-affix table clones, not
  changes to any shared vanilla record. Boost the rare-affix roll weights.

The multipliers are RELATIVE to source weights, not flat percentage points
or guarantees of final item-drop rates. No quest/potion/component tables,
native monsters, global master tables or hero orb proxies are overwritten.
"""
from decimal import Decimal, InvalidOperation, ROUND_HALF_UP
from functools import lru_cache
from hashlib import sha256
from pathlib import Path
import math
import re

from dbr import DBR
from references import resolve

RANKED = {"b":"rare", "c":"epic", "d":"legendary"}
AFFIX_RARE = (
    "normalPrefixRareSuffix", "rareBothPrefixSuffix",
    "rarePrefixNormalSuffix", "rarePrefixOnly", "rareSuffixOnly",
)
AFFIX_OTHER = (
    "bothPrefixSuffix", "brokenOnly", "noPrefixNoSuffix",
    "prefixOnly", "suffixOnly",
)
MAX_INTEGER = 2147483647
LOOT_PATH = re.compile(r"^records/items/loottables/[a-z0-9_/-]+\.dbr$")
SLOT = re.compile(r"^loot([A-Za-z0-9]+)Item([1-6])$")
WEIGHT_SCALE = 100
CONFIG_FIELDS = {"enabled", "rare_multiplier", "epic_multiplier", "legendary_multiplier"}


def validate_settings(settings):
    if settings is None:
        return
    if (not isinstance(settings, dict) or set(settings) != CONFIG_FIELDS
            or type(settings["enabled"]) is not bool):
        raise ValueError("Invalid custom tier loot rewards configuration")
    for field in ("rare_multiplier", "epic_multiplier", "legendary_multiplier"):
        number = settings[field]
        if (type(number) not in (int, float) or not math.isfinite(number)
                or not 1 <= number <= 3):
            raise ValueError("Tier loot " + field + " must be finite, 1..3")


def _native(logical, reference):
    if not isinstance(logical, str) or not LOOT_PATH.fullmatch(logical):
        return None
    path = resolve(logical, reference)
    if not path.is_file():
        return None
    return DBR.from_file(path)


def _own_path(tier, source):
    suffix = sha256(source.encode("utf-8")).hexdigest()[:20]
    # Category and unique source hash prevent collisions between master,
    # level and dynamic records with similar basenames.
    return f"records/items/loottables/monsterexpansion/{tier}/{suffix}.dbr"


def _num(record, field):
    if not record._locations(field):
        return 0
    raw = record.get(field)
    if not re.fullmatch(r"(?:0|[1-9]\d*)", raw):
        raise ValueError("Unsafe loot weight " + field + ": " + raw)
    value = int(raw)
    if value > MAX_INTEGER:
        raise ValueError("Overlarge native loot weight: " + field)
    return value


def _rounded(value):
    n = int(value.quantize(Decimal("1"), rounding=ROUND_HALF_UP))
    if n > MAX_INTEGER or n < 0:
        raise ValueError("Loot weight exceeds native int limit")
    return str(n)


def _scale_category_weights(weights, categories, factors):
    """Reweight in odds space to preserve total and target relative probabilities.

    Integer weighting uses a fixed scale to prevent rounding away rare rolls.
    A category without a positive native weight remains absent.
    """
    total = sum(weights)
    modified = dict(weights)
    if total == 0:
        return modified
    active = {cat: Decimal(str(mult)) for cat, mult in factors.items()
              if Decimal(str(mult)) > 1}
    grouped = {cat: sum(weights[k] for k in weights if categories.get(k) == cat)
               for cat in active}
    if not any(grouped.values()):
        return modified
    # The unboosted base includes unmodified rare, epic or legendary entries
    # whose multiplier is 1, plus other non-equipment/consumable entries.
    other = total - sum(grouped.values())
    if other <= 0:
        return modified
    target_mass = sum(active[cat] * grouped[cat] for cat in active)
    if target_mass >= total:
        return modified
    anchor = Decimal(other) / (Decimal(total) - target_mass)
    for key, old in weights.items():
        cat = categories.get(key)
        factor = active.get(cat)
        scaled = Decimal(old) * WEIGHT_SCALE * (
            factor * anchor if factor is not None else 1)
        # The unboosted categories may be multiplied by WEIGHT_SCALE to
        # preserve their ratios, not their absolute drop chances.
        if old:
            modified[key] = max(1, int(_rounded(scaled)))
        else:
            modified[key] = 0
    return modified


def _equipment_quality(logical, reference):
    """Only recognise quality suffixes when the source master emits equipment."""
    if not LOOT_PATH.fullmatch(logical):
        return None
    match = re.search(r"_([abcd])\d{2}\.dbr$", logical, re.I)
    if not match:
        return None
    record = _native(logical, reference)
    if record is None:
        return None
    if record.get("templateName") != "database/templates/lootmastertable.tpl":
        return None
    links = [record.get(f"lootName{i}") for i in range(1,31)
             if record._locations(f"lootName{i}") and record.get(f"lootName{i}")]
    # Excludes components, crafting materials, consumables, etc.
    if not links or sum("/weapons/" in x or "/gear" in x for x in links) < len(links) / 2:
        return None
    return match.group(1).lower()


def _dynamic_affix(source, tier, multiplier, reference):
    record = _native(source, reference)
    if record is None or record.get("templateName") != (
            "database/templates/lootitemtable_dynweighted_dynaffix.tpl"):
        return None
    if not all(record._locations(k) for k in AFFIX_RARE + AFFIX_OTHER):
        return None
    weights = {k: _num(record, k) for k in AFFIX_RARE + AFFIX_OTHER}
    rare = sum(weights[k] for k in AFFIX_RARE)
    common = sum(weights[k] for k in AFFIX_OTHER)
    if not rare or not common or Decimal(str(multiplier)) == 1:
        return None
    result = _scale_category_weights(
        weights, {k:"rare" for k in AFFIX_RARE}, {"rare":multiplier})
    if all(result[k] == weights[k] for k in weights):
        return None
    for k, n in result.items():
        record.set(k, str(n))
    return _own_path(tier, source), record.render()


def _level_table(source, tier, multiplier, reference):
    record = _native(source, reference)
    if record is None or record.get("templateName") != "database/templates/leveltable.tpl":
        return None
    if not record._locations("records"):
        return None
    candidates = record.get("records").split(";")
    support = {}
    replacements = []
    for item in candidates:
        altered = _dynamic_affix(item, tier, multiplier, reference)
        if altered:
            name, data = altered
            support[name] = data
            replacements.append(name)
        else:
            replacements.append(item)
    if not support:
        return None
    record.set("records", ";".join(replacements))
    name = _own_path(tier, source)
    support[name] = record.render()
    return name, support


@lru_cache(maxsize=512)
def _private_rare_master(source, tier, multiplier, reference_text):
    """Pure immutable graph response; safe to share across variant records."""
    reference = Path(reference_text)
    master = _native(source, reference)
    if master is None or _equipment_quality(source, reference) != "a":
        return None
    support = {}
    for n in range(1, 31):
        field = f"lootName{n}"
        if not master._locations(field):
            continue
        original = master.get(field)
        if not original:
            continue
        alternate = _level_table(original, tier, multiplier, reference)
        if alternate:
            path, files = alternate
            support.update(files)
            master.set(field, path)
    if not support:
        return None
    name = _own_path(tier, source)
    support[name] = master.render()
    return name, tuple(sorted(support.items()))


def enhance_monster_loot(monster, proto, tier_id, reference):
    """Modify only the custom monster clone; return tier-private loot DBRs."""
    settings = proto.get("loot_rewards")
    validate_settings(settings)
    if not settings or not settings["enabled"]:
        return {}, {"quality_slots":0, "rare_affix_slots":0}

    source = DBR(monster.render())
    groups = {}
    for line in source.lines:
        key = line.partition(",")[0]
        match = SLOT.fullmatch(key)
        if not match:
            continue
        slot, index = match.groups()
        main_field = f"chanceToEquip{slot}"
        weight_field = f"chanceToEquip{slot}Item{index}"
        if not source._locations(main_field) or not source._locations(weight_field):
            continue
        if Decimal(source.get(main_field)) <= 0:
            continue
        logical = source.get(key)
        category = _equipment_quality(logical, reference)
        if category is None:
            continue
        groups.setdefault(slot, []).append((key, weight_field, logical, category))

    support, direct_count, rare_count = {}, 0, 0
    factors = {letter:Decimal(str(settings[field])) for letter, field in (
        ("b","rare_multiplier"), ("c","epic_multiplier"),
        ("d","legendary_multiplier"))}

    for slot, entries in groups.items():
        weights = {w:_num(source, w) for _, w, _, _ in entries}
        # Include all native entries, even quest, consumable and other kinds,
        # in the probability denominator; never promote these classes.
        for i in range(1, 7):
            field = f"chanceToEquip{slot}Item{i}"
            if source._locations(field):
                weights.setdefault(field, _num(source, field))
        categories = {w:cat for _, w, _, cat in entries if cat in factors}
        changed = _scale_category_weights(weights, categories, factors)
        if any(changed[k] != weights[k] for k in changed):
            for k, val in changed.items():
                source.set(k, str(val))
            direct_count += 1
        if factors["b"] > 1:
            for key, weight_field, logical, cat in entries:
                if cat != "a" or _num(source, weight_field) == 0:
                    continue
                alternate = _private_rare_master(
                    logical, tier_id, str(factors["b"]), str(reference))
                if alternate:
                    name, records = alternate
                    source.set(key, name)
                    for p, data in records:
                        if p in support and support[p] != data:
                            raise ValueError("Conflicting tier loot support path")
                        support[p] = data
                    rare_count += 1

    # Update just the clone's native loot fields. No original or shared table
    # is mutated, and no new guaranteed loot roll is added.
    monster.lines = source.lines
    return {Path("database") / p: text for p, text in support.items()}, {
        "quality_slots":direct_count, "rare_affix_slots":rare_count
    }
