"""Generate the campfire-fast-travel mod: fast travel between campfires without DLC.

Usage: uv run python tools/make_campfire_fast_travel.py
Reads unpacked/data-windows, writes my-mods/campfire-fast-travel/ (mod-info.xml is hand-written).

Two layers, so the mod still helps if one of them does not work in game:
1. campfire.xml: every time you use a campfire, craft the Compass recipe if missing (the Camp menu keeps Fast Travel locked
   with "Invent Compass to unlock" until then), and switch on the CAMPFIRE_FAST_TRAVEL feature and the
   stage flag always_allow_campfire_fast_travel (no link tower transmitter needed).
2. recipes.xml: drop the DLC1 requirement from the vanilla route (Campfire Triangulation transmitter
   at a link tower, Smoke Signal camp upgrade), so it can be invented without the DLC.
"""

import re

from modlib import patch_once, read_game_file, write_mod_file

MOD = "campfire-fast-travel"

# The campfire's "rest" interaction runs this before the camp menu opens. Escaped like the rest of the XML.
FLAG_LINES = (
    "&#9;if (!Game_IsRecipeCrafted(&#34;COMPASS&#34;)) Game_CraftRecipe(&#34;COMPASS&#34;);&#10;"
    "&#9;Game_SetFeatureAvailable(&#34;CAMPFIRE_FAST_TRAVEL&#34;, true);&#10;"
    "&#9;KeyValueStore_SetKeyValueBoolean(Stage_GetKeyValueStore(), &#34;always_allow_campfire_fast_travel&#34;, true);&#10;"
)
REST_HEAD = 'interaction_1_script_to_run_on_interaction="function OnInteraction(so_self, so_activator)&#10;{&#10;'


def make_campfire() -> None:
    text = read_game_file("actors/objects/campfire.xml")
    text = patch_once(text, REST_HEAD, REST_HEAD + FLAG_LINES, "campfire rest interaction")
    write_mod_file(MOD, "actors/objects/campfire.xml", text)


def make_recipes() -> None:
    text = read_game_file("dysmantle/recipes.xml")
    for recipe_id in ("TRANSMITTER_CAMP_FAST_TRAVEL", "CAMP_UPGRADE_FAST_TRAVEL"):
        pattern = re.compile(r'(<node id="' + recipe_id + r'"[^>]*?)\s+requires_iap="DLC1"')
        text, n = pattern.subn(r"\1", text)
        assert n == 1, f"{recipe_id}: requires_iap not found exactly once"
    # Storage Box Upgrade (take materials out of the camp box) is stuck behind 20 mana beads. Use common scrap instead.
    text = patch_once(
        text,
        'requires_materials="15xIRON,20xMANA_BEAD"',
        'requires_materials="15xIRON,20xSCRAP_METAL"',
        "STORAGE_BOX_TAKE_AWAY cost",
    )
    write_mod_file(MOD, "dysmantle/recipes.xml", text)


if __name__ == "__main__":
    make_campfire()
    make_recipes()
    print(f"{MOD} written")
