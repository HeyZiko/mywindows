<#
.SYNOPSIS
  Configures bash_profile to read from our config location.

.PARAMETER DryRun
	Display what actions would be taken but don't actually do them.

.LINK
	https://github.com/HeyZiko/mywindows/
#>

. "$env:MyWindowsScripts\common\start-execution.ps1"


$target = Join-Path $env:APPDATA "Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
$source = "$Env:CloudProfile\.windows\taskbar-shortcuts\";
$shortcuts = Join-Path $source "*.lnk"

Write-White "
========
This script adds pre-built taskbar shortcuts.
"

Test-MyWindowsConfig $($DryRun ? "-DryRun " : $null)

if (-not (Test-Path $source)) {
  Write-White("Taskbar shortcut folder is missing. Expected:
    $source");
  exit 1;
}

Write-White "$($DryRun ? "DRYRUN: Pretend " : $null)Copying the following shortcuts to $target`:`n$shortcuts"
if(-not $DryRun) {
  Copy-Item -Path $shortcuts -Destination $target;
}

. "$env:MyWindowsScripts\common\end-execution.ps1"
