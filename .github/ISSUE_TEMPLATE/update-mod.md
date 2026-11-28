---
name: Update existing mod
about: Change, fix, extend, publish or retire an existing DYSMANTLE mod
title: "[UPDATE MOD][private|public] [mod-name]: [what changes]"
labels: update-mod
assignees: ""
---

<!--
HOW TO USE (humans and agents)
- Fill every [placeholder]. Replace it, or write "pending: [what is needed]" if unknown.
- Tick the decision boxes. Unticked = "no". Edit the title tag ([private|public]) to match.
- Comments like this one are invisible in the rendered issue.
- Branch: feature/ISSUE-NNN-[mod-name]-[short]. Commits: "#NNN: type: description".
-->

## Mod
- Folder: `my-mods/[mod-name]/`; current version: [x.y.z]; currently: [private | Workshop ID ...]
- Generator: [`tools/make_[...].py` | none, hand-written]

## Reason
- [ ] **Bug fix**: observed: [what happens in game]; expected: [what should happen]
- [ ] **New or changed behaviour**: [what]
- [ ] **Game update broke it** (a `patch_once` assertion failed, or the unpacked file changed): game version: [version]
- [ ] **Conflict with another mod**: [which]
- [ ] **Publish a private mod to the Workshop**, or **unpublish**
- [ ] **Retire / delete** this mod (superseded by: [mod-name])

## Decisions
<!-- Each box triggers extra steps in "Workflow steps" below. -->
- [ ] **Version bump** from [current] to [x.y.z]. Semantic versioning, `mod_version` in `mod-info.xml`:
  - `z`: fix/patch, no behaviour change beyond the fix
  - `y`: minor internal change (tuning values, small additions that keep saves and dependants working)
  - `x`: interface-breaking change: a changed file/path set that others depend on, removed or renamed items/recipes/flags, changed load priority or dependency, anything that can break saves or mods built on this one. Needs a change note, and dependants must be checked
  - `0.0.z` very alpha, `0.y.z` beta, `x>=1` released in public. Moving 0.y.z -> 1.0.0 = first public release
  - Update `description` if the Goal/behaviour changed (it is public text)
- [ ] **Public (Workshop item)** after this change: leave unticked to stay or become private / local only
- [ ] **Add or replace preview icon** (`preview.jpg`)
- [ ] **Regenerate from unpacked game data** (re-unpack first if the game was updated)
- [ ] **Changes the set of overridden files** (new or removed paths)
- [ ] **Changes save-affecting state** (items, quests, recipes, flags): back up saves first
- [ ] **Needs more research before implementing** (see "Open questions")

## Change specification
### Current vs wanted
| Setting / file | Now | Wanted |
|----------------|-----|--------|
| [game path or generator constant] | [value] | [value] |

### Evidence
<!-- Paste: in-game hint text, screenshot, log, relevant lines from docs/open-issues.md or docs/modding-notes.md. -->
[evidence]

### Open questions
- [question, and how to find out]

### Out of scope
- [thing not changed]

## Conflict check (required before implementing)
- [ ] Re-checked overlapping paths against other `my-mods/` folders and "File ownership" in `docs/modding-notes.md` (especially if the path set changed)
- [ ] Re-checked enabled Workshop mods in `docs/active-mods.reference.xml`
- [ ] Mods that build on this one, or that this one builds on (load order via `load_priority`): [none | list]. If this mod's files change, regenerate dependants (e.g. `mana-bead-drops` embeds `level-up-faster` stats)
- [ ] Overlaps found: [none | path -> other mod -> resolution]
- [ ] "File ownership" table updated if paths moved

## Workflow steps
1. [ ] Validate: reproduce the problem or confirm the wish; check `docs/open-issues.md` for known context
2. [ ] Research; record verified findings in `docs/modding-notes.md`
3. [ ] Implement in the generator (preferred) or the files; keep the `patch_once()` asserts
4. [ ] Bump `mod_version` / `description` in `mod-info.xml` if ticked above
5. [ ] Update the `README.md` mod table, `docs/ideas-and-tasks.md`, `docs/open-issues.md`
6. [ ] Test (see below), record the result in this issue
7. [ ] PR (`Closes #NNN`), squash merge, delete branch

**Only if public (Workshop):**
- [ ] Re-upload the new version from `my-mods/[mod-name]/` through the in-game Mods menu, updating the existing item (Workshop ID: [ID]); do not create a duplicate
- [ ] Write a change note for subscribers: [changelog text]; mention if saves may depend on the previous behaviour

**Only if retiring:**
- [ ] Remove the folder from `my-mods/`, the deployed copy in `Documents\DYSMANTLE Mods\<mod>`, and its entry in `active-mods.xml`
- [ ] If it was a Workshop item: unpublish/delete it there and remove the ID from the README

**Only if preview icon:**
- [ ] [Describe or attach the image]

## Install and test
<!-- Back up saves first. -->
1. Close the game. `powershell -ExecutionPolicy Bypass -File scripts\backup-saves.ps1`
2. `powershell -ExecutionPolicy Bypass -File scripts\deploy-mods.ps1` (it only adds and overwrites; if files were removed, delete the deployed mod folder first)
3. Launch with `--features MODS`; Mods > make sure the mod is enabled > **Apply Mods** (restart if needed)
4. Check `%APPDATA%\10tons\DYSMANTLE\active-mods.xml` lists the mod with `enabled="true"`
5. Test the exact scenario from "Evidence", then again with the normal mod set enabled

### Acceptance criteria
- [ ] [The reported problem no longer happens / the new behaviour is visible: expected value]
- [ ] No regression: earlier behaviour of this mod still works
- [ ] Still works with the normal enabled mod set (conflict check passed)
- [ ] Existing save loads without errors
- [ ] Docs and version updated

## Test result
- Game version / date: [version, date]
- Result: [pass | fail | untested]: [notes, exact in-game hint text if relevant]

## Notes for agents
<!-- Prefer changing the generator over hand-editing generated files. If "Open questions" is non-empty, research first and write the answer into this issue before changing files. Nothing is verified until the Test result says so. -->
