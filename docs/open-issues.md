# Open issues

## #1 Campfire fast travel does not appear (campfire-fast-travel mod)

**Status:** open. Reported 2026-11-15 after in-game test: mod enabled, no Fast Travel seen.

**Setup tested:** main island, existing save, Compass recipe already crafted, mods enabled via `active-mods.xml`. The mod:
- patches `actors/objects/campfire.xml` so the campfire's `rest` interaction calls `Game_SetFeatureAvailable("CAMPFIRE_FAST_TRAVEL", true)` and sets stage key `always_allow_campfire_fast_travel` to `true`;
- removes `requires_iap="DLC1"` from `TRANSMITTER_CAMP_FAST_TRAVEL` and `CAMP_UPGRADE_FAST_TRAVEL` in `dysmantle/recipes.xml`.

**Not known yet (ask/check next session):**
- What the Camp menu shows exactly: no Fast Travel button, a locked button, or hint text ("Install Campfire Triangulation Transmitter ..."). The hint text tells which condition fails.
- Whether the campfire patch runs at all (the rest script may not be the code path that opens the camp menu; try adding a visible side effect to confirm, e.g. a log line or a protagonist message).
- Whether a Workshop mod overrides `campfire.xml` or `recipes.xml` (later load wins).

**Next steps to try, in order:**
1. Read the hint text in the Camp menu (see above).
2. Vanilla route: invent *Link Tower Toolkit*, then *Campfire Triangulation* (no DLC1 needed with the mod), install it at a link tower (15 mana beads + 5 electronics; beads now drop), then use *Smoke Signal* camp upgrade (level 5) at target campfires.
3. If the vanilla route works but the flag patch does not, drop the flag patch and keep the recipe un-gating.
4. If the vanilla route also fails, the engine itself checks DLC1 for the feature. Then try setting the feature from a place that runs on stage load (`GetMonsterHitPointsMultiplier` in `game-settings.nut`, shared with level-up-faster) and read engine strings in `prog.dll` near `FastTravel` for more conditions.
5. Check Workshop mod conflicts (IDs in `docs/active-mods.reference.xml`).
