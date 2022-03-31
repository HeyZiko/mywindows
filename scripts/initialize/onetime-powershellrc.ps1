. $env:MyWindowsScripts\common\start-execution.ps1

$newline = "`r`n"
$fileToUpdate = $profile
$target = $fileToUpdate;
$source = '$env:MyWindowsConfig\.powershellrc.ps1'
$include = ". $source"

Write-White "This script makes the primary $fileToUpdate read from $source."

Test-MyWindowsConfig

Write-White "Checking for $target"
if (-not (Test-Path $target)) {
  Write-White "No $target found, creating it."
  $include | Set-Content $target
}
else {
  Write-White "Found $target. Checking to see if you already configured it."
  $existingText = Select-String -Path $target -pattern $($source.Replace("\", "\\"))
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
prompt

. $env:MyWindowsScripts\common\end-execution.ps1
