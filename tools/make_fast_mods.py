"""Generate the `faster-crafting` and `faster-farming` mods from the unpacked game data.

Run from the repo root:  python tools/make_fast_mods.py
Needs unpacked/data-windows/ (see README). Re-run after a game update.
"""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "unpacked" / "data-windows" / "dysmantle"
MODS = ROOT / "my-mods"

CRAFT_FACTOR = 0.1  # refine durations at 10%


def fmt(value: float) -> str:
    return f"{value:.4f}".rstrip("0").rstrip(".")


def scale_attr(text: str, attr: str, factor: float) -> tuple[str, int]:
    pattern = re.compile(rf'({attr}\s*=\s*")([0-9.]+)(")')
    return pattern.subn(lambda m: m.group(1) + fmt(float(m.group(2)) * factor) + m.group(3), text)


def mod_info(title: str, description: str, tags: str) -> str:
    return f"""<?xml version="1.0" encoding="iso-8859-1"?>
<root>

	<array id="INFO">
		<node id="required_program_id" value="DYSMANTLE" />
		<node id="required_mod_api_version" value="1" />
		<node id="mod_version" value="0.1.0" />
		<node id="title" value="{title}" />
		<node id="author" value="Me" />
		<node id="description" value="{description}" />
		<node id="tags" value="{tags}" />
		<node id="load_priority" value="0" />
	</array>

</root>
"""


def write_mod(name: str, rel: str, content: str, info: str) -> None:
    out = MODS / name
    (out / rel).parent.mkdir(parents=True, exist_ok=True)
    (out / rel).write_bytes(content.encode("utf-8"))
    (out / "mod-info.xml").write_bytes(info.encode("iso-8859-1"))


def main() -> None:
    # Crafting: sawmill, smelter and every other refiner share refine_duration_in_seconds per material.
    # Fuel burns per second, so a 10x shorter job automatically uses 10x less fuel; fuel_duration is left alone.
    mat = (SRC / "material-types.xml").read_bytes().decode("utf-8")
    mat, n = scale_attr(mat, "refine_duration_in_seconds", CRAFT_FACTOR)
    write_mod(
        "faster-crafting", "dysmantle/material-types.xml", mat,
        mod_info("Faster Crafting", "Sawmill, smelter and other refiners work 10x faster (fuel use drops with it).", "CRAFTING,CHEAT"),
    )
    print(f"faster-crafting: {n} refine durations scaled")

    # grow_time_minutes is world time (20x real time). Real minutes N -> N/20 real minutes == N world minutes,
    # so keep the original number as an integer and switch attribute. The game rejected decimals.
    seeds = (SRC / "seeds.xml").read_bytes().decode("utf-8")
    seeds, m = re.subn(r'grow_time_minutes_real_time(\s*=\s*")(\d+)"', lambda g: "grow_time_minutes" + g.group(1) + g.group(2) + '"', seeds)
    write_mod(
        "faster-farming", "dysmantle/seeds.xml", seeds,
        mod_info("Faster Farming", "Crops grow 20x faster (70 min becomes 3.5 min).", "FARMING,CHEAT"),
    )
    print(f"faster-farming: {m} grow times converted")


if __name__ == "__main__":
    main()
