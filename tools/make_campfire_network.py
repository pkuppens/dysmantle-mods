"""Generate the campfire-network mod: fast travel to/between campfires, no DLC, load order proof.

Usage: python tools/make_campfire_network.py   (mod-info.xml is hand-written)
Replaces campfire-fast-travel (same files, so never enable both).

Why the old mod failed, and what this one adds:
- Vanilla only switches the CAMPFIRE_FAST_TRAVEL feature on inside the Underworld (DLC1) cave-entrance trigger, and the
  DLC1 quest forces it back to false on every other stage while the quest is active. Both are patched to "true".
- Campfire: lighting AND resting set the feature, the stage flag, and craft COMPASS + the Triangulation transmitter.
- Recipes: DLC1 gate removed; the transmitter is cheap (vanilla: 15 mana beads + 5 electronics).
- load_priority 200 (higher than Better Tools 100) so these files win over other mods.
"""

import re

from modlib import patch_once, read_game_file, write_mod_file

MOD = "campfire-network"

UNLOCK = (
    "&#9;if (!Game_IsRecipeCrafted(&#34;COMPASS&#34;)) Game_CraftRecipe(&#34;COMPASS&#34;);&#10;"
    "&#9;if (!Game_IsRecipeCrafted(&#34;TRANSMITTER_CAMP_FAST_TRAVEL&#34;)) Game_CraftRecipe(&#34;TRANSMITTER_CAMP_FAST_TRAVEL&#34;);&#10;"
    "&#9;Game_SetFeatureAvailable(&#34;CAMPFIRE_FAST_TRAVEL&#34;, true);&#10;"
    "&#9;KeyValueStore_SetKeyValueBoolean(Stage_GetKeyValueStore(), &#34;always_allow_campfire_fast_travel&#34;, true);&#10;"
)
HEAD = "&#10;{&#10;"


def make_campfire() -> None:
    text = read_game_file("actors/objects/campfire.xml")
    for n in (0, 1):  # 0 = light the fire, 1 = rest / open Camp menu
        head = f'interaction_{n}_script_to_run_on_interaction="function OnInteraction(so_self, so_activator){HEAD}'
        text = patch_once(text, head, head + UNLOCK, f"campfire interaction {n}")
    write_mod_file(MOD, "actors/objects/campfire.xml", text)


def make_recipes() -> None:
    text = read_game_file("dysmantle/recipes.xml")
    for recipe_id in ("TRANSMITTER_CAMP_FAST_TRAVEL", "CAMP_UPGRADE_FAST_TRAVEL"):
        text, n = re.subn(r'(<node id="' + recipe_id + r'"[^>]*?)\s+requires_iap="DLC1"', r"\1", text)
        assert n == 1, f"{recipe_id}: requires_iap not found exactly once"
    text = patch_once(text, 'requires_materials="15xMANA_BEAD,5xELECTRONICS"', 'requires_materials="2xIRON"', "transmitter cost")
    text = patch_once(text, 'requires_materials="1xMANA_SHARD,10xWOOD"', 'requires_materials="2xWOOD"', "smoke signal cost")
    # Carried over from campfire-fast-travel: Storage Box Upgrade costs scrap metal, not mana beads.
    text = patch_once(text, 'requires_materials="15xIRON,20xMANA_BEAD"', 'requires_materials="15xIRON,20xSCRAP_METAL"', "storage box")
    write_mod_file(MOD, "dysmantle/recipes.xml", text)


def make_dlc1_quest() -> None:
    text = read_game_file("quests/dlc_1_main.nut")
    old = 'else\r\n\t\t\t\t\t\t\tGame_SetFeatureAvailable("CAMPFIRE_FAST_TRAVEL", false)'
    if old not in text:
        old = old.replace("\r\n", "\n")
    assert text.count(old) == 2, f"dlc_1_main: expected 2 forced-off sites, found {text.count(old)}"
    write_mod_file(MOD, "quests/dlc_1_main.nut", text.replace(old, old.replace("false)", "true)")))


def make_dlc1_trigger() -> None:
    rel = "actors/interactives/stage-leave-enter-trigger-dlc1-enter.xml"
    text = read_game_file(rel)
    old = "Game_SetFeatureAvailable(&#34;CAMPFIRE_FAST_TRAVEL&#34;, Game_IsQuestCompleted(quest_id));"
    text = patch_once(text, old, old.replace("Game_IsQuestCompleted(quest_id)", "true"), "dlc1 enter trigger")
    write_mod_file(MOD, rel, text)


if __name__ == "__main__":
    make_campfire()
    make_recipes()
    make_dlc1_quest()
    make_dlc1_trigger()
    print(f"{MOD} written")
