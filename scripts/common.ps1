# Shared by the scripts. Paths are derived from the environment, nothing personal is hard-coded.
$ModsRoot  = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'DYSMANTLE Mods'   # OneDrive-redirected Documents when OneDrive backs up Documents
$SaveBackupRoot = Join-Path $ModsRoot 'saves-backup'
$LiveData  = Join-Path $env:APPDATA '10tons\DYSMANTLE'
$RepoRoot  = Split-Path $PSScriptRoot -Parent
function Assert-GameClosed { if (Get-Process DYSMANTLE -ErrorAction SilentlyContinue) { throw 'Quit DYSMANTLE first.' } }
