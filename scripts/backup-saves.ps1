# Snapshot live saves into "<Documents>\DYSMANTLE Mods\saves-backup\<yyyy-MM-dd>" (OneDrive syncs it).
. "$PSScriptRoot\common.ps1"
Assert-GameClosed
$dest = Join-Path $SaveBackupRoot (Get-Date -Format 'yyyy-MM-dd')
if (Test-Path $dest) { $dest += (Get-Date -Format '_HHmm') }
New-Item -ItemType Directory -Force $dest | Out-Null
foreach ($d in 'save','save.backups') { if (Test-Path "$LiveData\$d") { Copy-Item "$LiveData\$d" "$dest\$d" -Recurse } }
"Backup written to $dest"
