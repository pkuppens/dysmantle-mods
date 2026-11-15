"""Shared helpers for the mod generators in tools/.

Mods override whole game files, so each generator copies a file from unpacked/data-windows
and patches it. patch_once() fails loudly when the game text changed after an update,
instead of silently producing a mod that does nothing.
"""

from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "unpacked" / "data-windows"
MODS = ROOT / "my-mods"


def read_game_file(rel: str) -> str:
    # newline="" keeps the original line endings (the game files mix CRLF and LF).
    with open(SRC / rel, encoding="utf-8", newline="") as f:
        return f.read()


def write_mod_file(mod: str, rel: str, text: str) -> Path:
    dest = MODS / mod / rel
    dest.parent.mkdir(parents=True, exist_ok=True)
    with open(dest, "w", encoding="utf-8", newline="") as f:
        f.write(text)
    return dest


def patch_once(text: str, old: str, new: str, what: str) -> str:
    count = text.count(old)
    assert count == 1, f"{what}: expected exactly 1 match, found {count}. The game was probably updated; re-check the pattern."
    return text.replace(old, new)
