# DYSMANTLE mods

Goal: make the game easier (more damage reduction, faster XP/levelling).

## Key finding

Nothing needed to be downloaded. DYSMANTLE ships its own modding kit:
`C:\Program Files (x86)\Steam\steamapps\common\DYSMANTLE\modding_kit\`

The developers say there is no documentation ("use at your own risk"). The official kit README is copied here as `KIT_README_official.txt`.

## What is in this directory

| Path | What |
|------|------|
| `tools/nx-pak-tool.exe` | Official pak unpacker/packer. **Not in git**: copy it from the Steam kit (see Setup) |
| `tools/developer.xml` | Optional developer-mode switch (copy next to `prog.xml`; not needed for simple mods) |
| `unpacked/data-windows/` | Game data unpacked from `data-windows.pak` (1.5 GB, gitignored). Reference: see how the game defines things |
| `my-mods/level-up-faster/` | **The mod in use** (monsters 40% damage / 70% HP, level-ups need 40% XP). Deployed to `Documents\DYSMANTLE Mods\` |
| `my-mods/campfire-fast-travel/` | Fast travel between campfires without DLC1 (campfire script + un-gated recipes); also Storage Box Upgrade costs scrap metal, not beads. **Fast travel not working yet**, see `docs/open-issues.md` |
| `my-mods/mana-bead-drops/` | Ordinary monsters drop a Mana Bead (20%, 50% if mana-infused; includes Level Up Faster's monster stats, loads after it). Chances in `tools/make_mana_bead_drops.py`. Works in game |
| `docs/modding-notes.md`, `docs/ideas-and-tasks.md` | Findings/gotchas, and the working list of tasks and ideas |
| `docs/active-mods.reference.xml` | Which Workshop mods were enabled (IDs only; re-subscribe on Steam) |
| `my-mods/easy-mode-draft/` | Draft mod: override files that make levelling 3x faster and Soldier outfit damage reduction 15% -> 60% |
| `scripts/` | `deploy-mods.ps1`, `backup-saves.ps1`, `restore-saves.ps1` |

## Setup on a new PC

1. Install Steam and DYSMANTLE. Subscribe to the Workshop mods listed in `docs/active-mods.reference.xml` (the numeric IDs are Workshop item IDs).
2. Clone this repo.
3. Copy `nx-pak-tool.exe` from `<Steam>\steamapps\common\DYSMANTLE\modding_kit\` into `tools\` (not redistributed here).
4. Needed to regenerate the mods (`tools\make_*.py`): unpack the game data. `nx-pak-tool.exe` extracts **next to the pak**, so copy `data-windows.pak` into `unpacked\` first and run the tool there (details in `docs/modding-notes.md`). Result: `unpacked\data-windows\`.
5. `powershell -ExecutionPolicy Bypass -File scripts\deploy-mods.ps1` copies the mod to `Documents\DYSMANTLE Mods\`. In the game: Mods > enable *Level Up Faster* > Apply.
   - `-ExecutionPolicy Bypass` is needed on a default Windows setup, which blocks `.ps1` files ("running scripts is disabled on this system"). It applies to that one run only and changes no system setting. Use the same flag for the backup/restore scripts below.
   - Only mods that contain a `mod-info.xml` are deployed. `easy-mode-draft` has none, so the script skips it (see "Steps to try the draft mod").
6. Launch option in Steam: `--features MODS`.

## Saves

Saves live in `%APPDATA%\10tons\DYSMANTLE\`. Steam Cloud also syncs them, but a cloud conflict can overwrite local progress, so keep a manual snapshot.
Snapshots are **not** in git (personal data). They go to `Documents\DYSMANTLE Mods\saves-backup\<date>\`, which OneDrive syncs between machines.

- Backup: `powershell -ExecutionPolicy Bypass -File scripts\backup-saves.ps1` (game closed)
- Restore: `powershell -ExecutionPolicy Bypass -File scripts\restore-saves.ps1 [date]`
- Before restoring, set Steam offline for the first launch (or disable Steam Cloud for the game), otherwise the cloud copy may win.
- Restoring has been done once on this PC; the character data inside each snapshot is unverified.
## How mods work (from the kit README)

- Any file in your mod folder overrides the same path in the base game. Example: `actors/players/survivor-male.xml` overrides the player.
- Scripts are Squirrel (`.nut`), actors are XML.
- To unpack a pak: `tools\nx-pak-tool.exe data-windows.pak` (extracts into `data-windows/`).

## Where the numbers live (found in `unpacked/`)

| Want | File | Setting |
|------|------|---------|
| XP needed per level | `dysmantle/game-settings.nut` | `GetExperiencePointsRequiredForLevel(level)`, formula `(1000+20*level)*level*level`. Divide it to level faster |
| Damage taken | `items/outfits/*.nut`, `items/headgears/*.nut` | `damage_reduction_percentage_increase` (soldier outfit = 15) |
| XP bonus | `items/pets/persian.nut` | `experience_points_percentage_increase` (15, +5 per upgrade level). Easy lever: raise this and use the Persian Cat |
| Enemy HP | `dysmantle/game-settings.nut` | `GetMonsterHitPointsMultiplier()`, returns 1.0. Set e.g. 0.5 to halve enemy HP |
| Player base HP | `actors/players/survivor-male.xml` | `max_hit_points` = 20. Probably scaled by level in the engine; **untested**, so don't count on this |

Not found: a single "XP gain multiplier" setting. Lowering the level curve is the simplest equivalent.

## Steps to try the draft mod

1. **Back up saves** into `saves-backup/`. The kit warns that it's easy to corrupt saves with mods and dev tools.
2. Start the game with mods enabled: `DYSMANTLE.exe --features MODS,STAGE_EDITOR,SHADEGROWN_DEVELOPMENT_ENVIRONMENT`
   (in Steam: Properties > Launch options, add `--features MODS`).
3. Main menu > **Mods** > accept disclaimer > hammer & wrench icon > **Create Mod..**, follow the wizard. This generates the mod folder with `mod-info.xml` (its format is not documented, so let the game create it).
4. Copy the contents of `my-mods/easy-mode-draft/` (the `dysmantle/` and `items/` folders) into that mod folder.
5. In the subscribed mods list, enable the mod and click **Apply Mods** (restart if needed).
6. Check: next level-up should need roughly a third of the XP.

## Caveats / unverified

- The draft overrides whole files. If a game update changes `game-settings.nut`, re-copy from `unpacked/` and re-apply the edit.
- I could not read the DYSMANTLE Fandom modding page (HTTP 402) and did not watch the tutorial videos:
  - Getting started: https://www.youtube.com/watch?v=fi9DGmST6N4
  - Modding tutorial: https://www.youtube.com/watch?v=cBCz3AXxU8Y
- The modding tutorial (cBCz3AXxU8Y) is about adding a new item (tool/outfit/trinket), not stat tweaks, so it is not needed for the stat mods. Its description lists the folders an item mod touches: `items/`, `dysmantle/recipes.xml`, `ui/invent.xml`, `models/`, `actors/`. Mods must be re-checked after every game update.
- `my-mods/level-up-faster/` (monster damage 40%, HP 70%, level-up XP 40%) is generated by `tools/make_weak_monsters.py`. Untested in game.
- Other resources: Nexus Mods https://www.nexusmods.com/dysmantle/ ; official Discord #modding channel.
- In game (2026-11-15): mana-bead drops and the Storage Box recipe change work; campfire fast travel does not (see `docs/open-issues.md`).

## Next ideas

- Check whether level-ups grant HP (look at the player skill/perk definitions and `Game_*` script API) before editing `max_hit_points`.
- Make a mod that edits more outfits/helmets, or `GetMonsterHitPointsMultiplier`.
