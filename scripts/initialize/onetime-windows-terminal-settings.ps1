<#
.SYNOPSIS
  Configures bash_profile to read from our config location.

.PARAMETER DryRun
	Display what actions would be taken but don't actually do them.

.LINK
	https://github.com/HeyZiko/mywindows/
#>

. "$env:MyWindowsScripts\common\start-execution.ps1"

$fileToUpdate = "settings.json"
# For the latest Windows Terminal settings.json target, see https://docs.microsoft.com/en-us/windows/terminal/install#settings-json-file"
$target = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\$fileToUpdate";
$source = "$env:MyWindowsConfig\.windows-terminal.settings.json"
$verificationContent = "574e775e-4f2a-5b96-ac1e-a2962a402336"

Write-White "
========
This script overwrites $fileToUpdate with $source.
"

Test-MyWindowsConfig

Write-White "Checking for $target"
if (-not (Test-Path $target)) {
  Write-White "No $target found, creating it."
  Copy-Item $source -Destination $target
}
else {
  Write-White "Found $target. Checking to see if you already configured it."
  $existingText = Select-String -Path $target -pattern $verificationContent
  Write-White "$existingText"
  if($existingText) {
    Write-Green "Looks like you've already configured $target, nothing more to do here!"
  }
  else {
    Write-White "You haven't configured $target yet. Overwrite it now?"
    if ($(choose "yn" -showOptions) -eq 'y')
    {
      Copy-Item $source -Destination $target
    }
  }
}

. "$env:MyWindowsScripts\common\end-execution.ps1"
