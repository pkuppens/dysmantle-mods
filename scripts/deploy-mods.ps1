# Copy each mod in my-mods\ to "<Documents>\DYSMANTLE Mods\<mod>" (where the game loads docs:// mods from).
# Only folders with a mod-info.xml are deployed; drafts without one (e.g. easy-mode-draft) are skipped.
. "$PSScriptRoot\common.ps1"
New-Item -ItemType Directory -Force $ModsRoot | Out-Null
Get-ChildItem "$RepoRoot\my-mods" -Directory | ForEach-Object {
    if (-not (Test-Path (Join-Path $_.FullName 'mod-info.xml'))) {
        "Skipped $($_.Name) (no mod-info.xml, not a complete mod)"
        return
    }
    Copy-Item $_.FullName $ModsRoot -Recurse -Force
    "Deployed $($_.Name) -> $ModsRoot"
}
