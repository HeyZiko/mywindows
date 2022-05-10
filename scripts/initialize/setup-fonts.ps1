<#
.SYNOPSIS
  Installs fonts from the Cloud Location.

.PARAMETER DryRun
  Display what actions would be taken but don't actually do them.

.LINK
  https://github.com/HeyZiko/mywindows/
#>

param (
  [alias("d")][switch]$DryRun
)

. "$env:MyWindowsScripts\common\start-execution.ps1"

$Source = "$env:CloudProfile\fonts"

Write-White "
========
This script installs fonts from the source '$Source'
"

Test-CloudProfile

Write-White "Checking for $Source"
if (-not (Test-Path $Source)) {
  Write-Red "No $Source found, cannot install any fonts."
}
else {
  Write-White "Found $Source. $($DryRun ? "DRYRUN: Pretend " : $null)Installing fonts."
  $Target = (New-Object -ComObject Shell.Application).Namespace(0x14)
  $FontList = Get-ChildItem -Path $Source -Recurse -Include *.ttf
  $FontList | ForEach-Object {
	  if(-not $DryRun) {
	  	$Target.CopyHere($_.fullname)
	  }
	  Write-Green "$($DryRun ? "DRYRUN: Would have " : $null)Installed the font $($_.fullname)"
	}
}

. "$env:MyWindowsScripts\common\end-execution.ps1"
