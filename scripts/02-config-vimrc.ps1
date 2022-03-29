. $PSScriptRoot\common-start-execution.ps1


$newline = "`r"
$fileToUpdate = ".vimrc"
$target = "~\$fileToUpdate";
$source = '$MyWindowsConfig."/.vimrc_common"'
$include = "execute 'source ' . substitute(substitute('/'.$source, ':\\','/', 'g'    ), '\\', '/', 'g')"

Write-Info "This script makes the primary $fileToUpdate read from $source."

Test-MyWindowsConfig

Write-Info "Checking for $target"
if (-not (Test-Path $target)) {
  Write-Info "No $target found, creating it."
  $include | Set-Content $target
}
else {
  Write-Info "Found $target. Checking to see if you already configured it to use DropboxCommon."
  $existingText = Select-String -Path $target -pattern $source
  Write-Info "$existingText"
  if($existingText -eq $null) {
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
