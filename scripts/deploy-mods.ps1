# Copy each mod in my-mods\ to "<Documents>\DYSMANTLE Mods\<mod>" (where the game loads docs:// mods from).
. "$PSScriptRoot\common.ps1"
New-Item -ItemType Directory -Force $ModsRoot | Out-Null
Get-ChildItem "$RepoRoot\my-mods" -Directory | ForEach-Object {
    Copy-Item $_.FullName $ModsRoot -Recurse -Force
    "Deployed $($_.Name) -> $ModsRoot"
}
