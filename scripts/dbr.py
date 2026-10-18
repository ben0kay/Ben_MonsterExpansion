"""Minimal, strict Grim Dawn .dbr text reader/editor; never writes source files."""
from pathlib import Path


class DBRError(ValueError):
    """An unsupported or ambiguous DBR record was encountered."""


class DBR:
    def __init__(self, text):
        if "\x00" in text:
            raise DBRError("DBR contains NUL bytes")
        self.lines = text.splitlines(keepends=True)

    @classmethod
    def from_file(cls, path):
        return cls(Path(path).read_text(encoding="utf-8-sig"))

    def _locations(self, key):
        results = []
        for index, line in enumerate(self.lines):
            if "," not in line:
                continue
            first, rest = line.split(",", 1)
            if first == key:
                if "," not in rest:
                    raise DBRError(f"Invalid DBR field '{key}': no trailing comma")
                results.append(index)
        return results

    def get(self, key):
        indexes = self._locations(key)
        if len(indexes) != 1:
            raise DBRError(f"Expected one field '{key}', found {len(indexes)}")
        return self.lines[indexes[0]].split(",", 2)[1]

    def set(self, key, value):
        if not isinstance(value, str) or any(c in value for c in "\r\n,"):
            raise DBRError(f"Invalid replacement for '{key}'")
        indexes = self._locations(key)
        if len(indexes) != 1:
            raise DBRError(f"Expected one field '{key}', found {len(indexes)}")
        index = indexes[0]
        original = self.lines[index]
        parts = original.split(",", 2)
        self.lines[index] = f"{parts[0]},{value},{parts[2]}"

    def render(self):
        return "".join(self.lines)
