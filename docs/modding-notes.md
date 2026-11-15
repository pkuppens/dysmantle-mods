# Modding notes (findings, gotchas)

Verified = read in the unpacked game data or seen in vanilla code. Untested = nothing here has been run in the game yet.

## Gotchas

- **`nx-pak-tool.exe` extracts next to the pak, not into the current directory.** Running it on the Steam pak creates `<Steam>\DYSMANTLE\data-windows\` inside the game folder. A loose folder there could shadow the pak. Copy the pak into `unpacked\` first and extract there, or move the result out (done once; the Steam folder is clean again). Extraction takes about 45 s.
- A mod replaces a file **as a whole**. Two mods that override the same path do not merge: the later one silently wins. Always check `my-mods/*/` for overlapping paths before adding a mod (see "File ownership" below).
- `python -I` ignores the script directory, so `tools/*.py` cannot import `modlib` with it. Run them as `python tools/make_x.py` (or `uv run python tools/make_x.py`).
- Grepping the whole `unpacked/` tree for binary strings is slow (1.5 GB). Restrict with `--include` or search `.nut`/`.xml` only.

## File ownership (which mod overrides what)

| Path | Owner |
|------|-------|
| `dysmantle/game-settings.nut` | level-up-faster (XP curve, monster HP). Also the only per-stage-entry script hook found, see below |
| `actors/enemies/*.xml` | level-up-faster (monster damage). mana-bead-drops overrides 18 of these too, built on top of the level-up-faster versions, so it loads after it (priority 1) |
| `actors/objects/campfire.xml`, `dysmantle/recipes.xml` | campfire-fast-travel (recipes.xml also holds the Storage Box Upgrade cost change: 20 mana beads -> 20 scrap metal) |


## Campfire fast travel (how vanilla does it)

- Gated by DLC1 (`requires_iap="DLC1"`) on the recipes `TRANSMITTER_CAMP_FAST_TRAVEL` (install at a link tower, level 1, 15 mana beads + 5 electronics) and `CAMP_UPGRADE_FAST_TRAVEL` ("Smoke Signal", level 5, 1 mana shard + 10 wood), and on the quests `campfire-fast-travel-*.nut`.
- Engine-side switches (the Camp UI is compiled into `prog.dll`, `ui/Campfire.xml` only holds the hidden `FastTravel` button): the feature `CAMPFIRE_FAST_TRAVEL` (`Game_SetFeatureAvailable`) and the stage key-value `always_allow_campfire_fast_travel`. Vanilla DLC1 quest scripts set the latter to `false` to force the story route, which suggests `true` means "always allowed".
- `always_allow_campfire_fast_travel` appears only in DLC1 data (`quests/dlc_1_main.nut`, `link-tower-30s.xml`, `stages/dlc1/chunk-*.stage`), never set to `true` anywhere. So its exact effect on the main island is a guess; the campfire-fast-travel mod sets it to `true` and also un-gates the vanilla recipe route as a fallback.
- Recipe `COMPASS` (level 10, after Link Tower Toolkit) is required for the Camp menu's Fast Travel button: until crafted the button is locked with "Invent Compass to unlock Fast Travel" (engine string). Then, without the flag above, "Install Campfire Triangulation Transmitter ...". The mod crafts it via `Game_CraftRecipe("COMPASS")` (as vanilla `OnSetupNewGame` does for test games).

## Script hooks that exist

- Enemy script `OnDeath(so_actor)` exists in the engine, but a bead drop hooked into `common.nut` **never fired in game** for ordinary monsters. Do not rely on it.
- `GetMonsterHitPointsMultiplier()` in `game-settings.nut` is polled on every stage entry, usable as a "run on stage load" hook, but only one mod can own that file.
- Quest scripts get `OnActorStartDying(actor)` (see `quests/quest-api.txt`), but only while the quest is active.
- Vanilla pattern to give materials: `Game_SpawnMaterials(so_self, Game_GetPrimaryPlayerActor(), "2xIRON")`.
- Tower APIs: `Game_IsTowerActivated(id)`, `Game_GetTowerAreaLevel(id)`, `Game_IsTransmitterInstalled(tower_id, recipe_id)`. There is no "which tower covers this actor" call; tower ids are stage object ids (e.g. `DLC1_TOWER_A`).

## Drops

- Engine-driven from actor XML keys: `drops_material_id` (always) and `drops_random_material_id` (one random pick from the list; repeat an id to weight it, e.g. `IRON,IRON,IRON,STEEL`).
- `MANA_BEAD` vanilla sources: `mana-spirit` (always), mana props/crystals, farming. Ordinary monsters drop scrap/plastics etc.
