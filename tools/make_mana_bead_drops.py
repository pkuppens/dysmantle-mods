"""Generate the mana-bead-drops mod: normal monsters sometimes drop a Mana Bead.

Usage: python tools/make_mana_bead_drops.py   (run tools/make_weak_monsters.py first)
Reads unpacked/data-windows, writes my-mods/mana-bead-drops/ (mod-info.xml is hand-written).

How: the engine picks ONE entry from an enemy's `drops_random_material_id` list on death, and a
repeated id is weighted (vanilla uses "IRON,IRON,IRON,STEEL"). We pad the original list and add
MANA_BEAD entries so that MANA_BEAD gets roughly the chosen chance per kill.

(An earlier version used a script OnDeath hook. It never produced a bead in game, so it was dropped.)

Level Up Faster already overrides these same enemy files and a mod replaces a file as a whole, so this
mod starts from Level Up Faster's version of a file when it exists. Result: this mod carries the weak-monster
stats too and must load AFTER level-up-faster (load_priority 1). Re-run both generators together.
"""

import re

from modlib import MODS, SRC, write_mod_file

MOD = "mana-bead-drops"
CHANCE = 0.20  # per kill of an ordinary monster
CHANCE_MANA_INFUSED = 0.50  # per kill of a mana-infused monster (file name contains "mana")
SLOTS = 20  # list size used for weighting; chance = beads / SLOTS (rounded)

DROPS_RE = re.compile(r'(<node id="drops_random_material_id"[^>]*?value=")([^"]*)(")')
SKIP = ("boss", "turret")


def weighted(original: str, chance: float) -> str:
    items = [i.strip() for i in original.split(",") if i.strip()]
    beads = max(1, round(chance * SLOTS))
    reps = max(1, round((SLOTS - beads) / len(items)))
    return ",".join(items * reps + ["MANA_BEAD"] * beads)


def build() -> list[str]:
    done = []
    for src in sorted((SRC / "actors" / "enemies").glob("*.xml")):
        name = src.stem
        if any(s in name for s in SKIP):
            continue
        base = MODS / "level-up-faster" / "actors" / "enemies" / src.name
        path = base if base.exists() else src
        with open(path, encoding="utf-8", newline="") as f:
            text = f.read()
        m = DROPS_RE.search(text)
        if not m or "TOMB_ORB" in m.group(2) or "MANA_BEAD" in m.group(2):
            continue
        chance = CHANCE_MANA_INFUSED if "mana" in name else CHANCE
        text = DROPS_RE.sub(lambda x: x.group(1) + weighted(x.group(2), chance) + x.group(3), text, count=1)
        write_mod_file(MOD, f"actors/enemies/{src.name}", text)
        done.append(name)
    return done


if __name__ == "__main__":
    done = build()
    print(f"{MOD}: {len(done)} enemies patched (chance {CHANCE:.0%}, mana-infused {CHANCE_MANA_INFUSED:.0%})")
    print(", ".join(done))
