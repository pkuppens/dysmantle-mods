# Restore a dated backup over the live saves. Usage: .\restore-saves.ps1 [2026-11-12]  (default: newest)
param([string]$Name)
. "$PSScriptRoot\common.ps1"
Assert-GameClosed
$src = if ($Name) { Join-Path $SaveBackupRoot $Name } else { (Get-ChildItem $SaveBackupRoot -Directory | Sort-Object Name | Select-Object -Last 1).FullName }
if (-not (Test-Path "$src\save")) { throw "No save folder in $src" }
# safety copy of whatever is there now
$safe = Join-Path $SaveBackupRoot ((Get-Date -Format 'yyyy-MM-dd_HHmm') + '-before-restore')
if (Test-Path "$LiveData\save") { New-Item -ItemType Directory -Force $safe | Out-Null; Copy-Item "$LiveData\save" "$safe\save" -Recurse }
New-Item -ItemType Directory -Force $LiveData | Out-Null
if (Test-Path "$LiveData\save") { Remove-Item "$LiveData\save" -Recurse -Force }
Copy-Item "$src\save" "$LiveData\save" -Recurse
"Restored $src (previous state kept in $safe)"
"Reminder: set Steam offline for the first launch, or Steam Cloud may overwrite the restore with its copy."
