. $PSScriptRoot\common-start-execution.ps1


$newline = "`r"
$fileToUpdate = ".bash_profile"
$target = "~\$fileToUpdate";
$source = '$MyWindowsConfig/.bashrc_common'
$include = "$($newline)test -f $source && . $source$newline$newline"

Write-Info "This script makes the primary $fileToUpdate read from $source."

Test-MyWindowsConfig

Write-Info "Checking for $target"
if (-not (Test-Path $target)) {
  Write-Info "No $target found, creating it."
  $include | Set-Content $target
}
else {
  Write-Info "Found $target. Checking to see if you already configured it as desired."
  $existingText = Select-String -Path $target -pattern $source
  if($existingText) {
    Write-Info "Looks like you've already configured $target, nothing more to do here!"
  }
  else {
    Write-Info "You haven't configured $target yet. Updating it now."
    $include += ((Get-Content $target) -join "$newline")
    $include | Set-Content $target
  }
}
prompt

. $PSScriptRoot\common-end-execution.ps1
