<#
.SYNOPSIS
  Configures bash_profile to read from our config location.

.PARAMETER DryRun
	Display what actions would be taken but don't actually do them.

.LINK
	https://github.com/HeyZiko/mywindows/
#>

param (
  [alias("d")][switch]$DryRun
)

. "$env:MyWindowsScripts\common\start-execution.ps1"

$newline = "`r`n"
$fileToUpdate = $profile
$target = $fileToUpdate;
$source = '$env:MyWindowsConfig\.powershellrc.ps1'
$include = "if($source -and (Test-Path $source)) {. $source}"

"
========
This script makes the primary $fileToUpdate read from $source.
"
#. "MyWindows-Update-Config-File $($DryRun ? "-DryRun" : $null) -Target $target -IncludeLine $include"

Test-MyWindowsConfig

Write-White "Checking for $target"
if (-not (Test-Path $target)) {
  Write-White "No $target found, creating it."
  $include | Set-Content $target
}
else {
  Write-White "Found $target. Checking to see if you already configured it."
  $existingText = Select-String -Path $target -pattern [Regex]::Escape($source)
  Write-White "$existingText"
  if($existingText) {
    Write-White "Looks like you've already configured $target, nothing more to do here!"
  }
  else {
    Write-White "You haven't configured $target yet. Updating it now."
    $include += ((Get-Content $target) -join "$newline")
    $include | Set-Content $target
  }
}

. "$env:MyWindowsScripts\common\end-execution.ps1"
