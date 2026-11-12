"""Generate the weak-monsters mod: monsters deal 40% damage, have 70% HP, level-ups need 40% XP.

Usage: uv run python tools/make_weak_monsters.py
Reads unpacked/data-windows, writes my-mods/level-up-faster/.
"""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "unpacked" / "data-windows"
OUT = ROOT / "my-mods" / "level-up-faster"

DAMAGE_FACTOR = 0.4
HP_FACTOR = 0.7
XP_FACTOR = 0.4

DAMAGE_RE = re.compile(r'(<node id="damage" value=")([0-9.]+)(")')


def scale_damage(match: re.Match) -> str:
    scaled = max(1, round(float(match.group(2)) * DAMAGE_FACTOR))
    return f"{match.group(1)}{scaled}{match.group(3)}"


def write_enemy_overrides() -> int:
    count = 0
    for src in (SRC / "actors" / "enemies").glob("*.xml"):
        text = src.read_text(encoding="utf-8")
        new_text, n = DAMAGE_RE.subn(scale_damage, text)
        if n == 0:
            continue
        dest = OUT / src.relative_to(SRC)
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(new_text, encoding="utf-8")
        count += 1
    return count


def write_game_settings() -> None:
    text = (SRC / "dysmantle" / "game-settings.nut").read_text(encoding="utf-8")
    old_xp = "local points = (1000+20*level)*level*level;"
    new_xp = f"local points = ((1000+20*level)*level*level) * {XP_FACTOR}; // {int(XP_FACTOR * 100)}% XP needed"
    old_hp = "function GetMonsterHitPointsMultiplier()\n{\n\treturn 1.0;"
    new_hp = f"function GetMonsterHitPointsMultiplier()\n{{\n\treturn {HP_FACTOR};"
    assert old_xp in text and old_hp in text, "game-settings.nut changed; update the patterns"
    text = text.replace(old_xp, new_xp).replace(old_hp, new_hp)
    dest = OUT / "dysmantle" / "game-settings.nut"
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_text(text, encoding="utf-8")


if __name__ == "__main__":
    write_game_settings()
    print(f"game-settings.nut written; {write_enemy_overrides()} enemy files overridden")
