. $PSScriptRoot\common-start-execution.ps1


Write-Info "This script adds pre-determined taskbar shortcuts."

Test-CloudProfile

$source = "$Env:CloudProfile\.windows\taskbar-shortcuts";
if (-not (Test-Path $source)) {
  Write-Info("Taskbar shortcut folder is missing. Expected:
    $source");
  break;
}
$target = Join-Path $env:APPDATA "Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
$shortcuts = Join-Path $source "*.lnk"

Write-Info "Copying the following shortcuts to $target:`n$shortcuts"
Copy-Item -Path $shortcuts -Destination $target;
prompt

. $PSScriptRoot\common-end-execution.ps1
