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
$fileToUpdate = ".bash_profile"
$target = "~\$fileToUpdate";
$source = '$MyWindowsConfig/.bashrc_common'
$include = "test -f $source && . $source"

Write-White "
========
This script makes the primary $fileToUpdate read from $source.
"
#. "MyWindows-Update-Config-File $($DryRun ? "-DryRun" : $null) -Target $target -IncludeLine $include"


Test-MyWindowsConfig $($DryRun ? "-DryRun " : $null)

Write-White "Checking for $target"
if (-not (Test-Path $target)) {
  Write-White "No $target found, $($DryRun ? "DRYRUN: Pretend " : $null)creating it."
  if($DryRun) {
    Write-White "DRYRUN: Would have written the following into $target :"
    Write-Cyan $include
   }
   else {
    $include | Set-Content $target
   }
}
else {
  Write-White "Found $target. Checking to see if you already configured it."
  $existingText = Select-String -Path $target -pattern  [Regex]::Escape($source)
  if($existingText) {
    Write-White "Looks like you've already configured $target, nothing more to do here!"
  }
  else {
    Write-White "You haven't configured $target yet. $($DryRun ? "DRYRUN: Pretend " : $null)Updating it now."
    $include += ((Get-Content $target) -join "$newline")
    if($DryRun) {
      Write-White "DRYRUN: Would have written the following into $target :"
      Write-Cyan $include
     }
     else {
      $include | Set-Content $target
     }
  }
}

. "$env:MyWindowsScripts\common\end-execution.ps1"
