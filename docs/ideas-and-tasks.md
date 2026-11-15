# Ideas and tasks

Local working list for this repo. Move items to Done when verified **in the game**.

## Next (verify what exists)

- [ ] Back up saves (`scripts/backup-saves.ps1`), deploy (`scripts/deploy-mods.ps1`), enable the three mods in-game, launch with `--features MODS`.
- [ ] **campfire-fast-travel**: no Fast Travel seen in game, tracked as open issue #1 in `docs/open-issues.md`.
- [x] **mana-bead-drops** (v2, actor-XML route): beads drop in game (confirmed 2026-11-15). v1 (script OnDeath hook) never dropped anything.
- [ ] Check both new mods against the active Workshop mods for overlapping files (a Workshop mod that also changes `recipes.xml` or `campfire.xml` conflicts; the later load wins).
- [ ] Decide whether Level Up Faster is still wanted at 40% damage / 70% HP / 40% XP.

## Ideas

- **Tower-aware bead drops**: only drop beads while the local link tower is not yet upgraded. Needs a way to map an actor to its tower (maybe nearest `LINK_TOWER` actor via `Stage_QueryStageObjectsWithTag` + `Game_GetTowerAreaLevel`). Unverified API semantics; try once the plain version is confirmed.
- **Mana-bead drops are now the XML route**; the cost is that the mod embeds Level Up Faster's stats. Cleaner fix: one combined enemy-XML generator with switches per feature.
- **One build script**: a `tools/build_all.py` that runs every generator, to stop mods drifting after a game update.
- **Game-update check**: store a hash of each source file a generator reads; warn when the unpacked file changed (the `patch_once` asserts already catch pattern breaks).
- **Cheaper fast travel recipes** (transmitter 15 beads + 5 electronics is steep without a bead source).
- **Combine game-settings hooks**: a single generated `game-settings.nut` that holds XP, HP multiplier and any "run on stage load" hook, so several mods can share the one polled function.
- Mods mentioned in `README.md` "Next ideas": more outfits/helmets, `GetMonsterHitPointsMultiplier`, level-ups granting HP.

## Conventions (so new mods stay consistent)

- One folder per mod in `my-mods/`, with a hand-written `mod-info.xml` (copy an existing one; without it `deploy-mods.ps1` skips the folder).
- Generated files come from `tools/make_<mod>.py` via `tools/modlib.py`; do not hand-edit generated files, change the generator and re-run.
- Check "File ownership" in `docs/modding-notes.md` before touching a path another mod already overrides.
- Record every verified finding or gotcha in `docs/modding-notes.md`.
