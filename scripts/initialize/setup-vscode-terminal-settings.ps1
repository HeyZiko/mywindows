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
$target = "$env:APPDATA\Code\User\$fileToUpdate";
$source = "$env:MyWindowsConfig\.windows-terminal.settings.json"
$verificationContent = "MYWINDOWS_VERIFICATION_TEXT"

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
    if ($(Wait-Choose "yn" -showOptions) -eq 'y')
    {
      Write-DarkYellow "$($DryRun ? "DRYRUN: Pretend " : $null)Overwriting Windows Terminal settings."
      if(-not $DryRun) {
        Copy-Item $source -Destination $target
      }
    }
  }
}

. "$env:MyWindowsScripts\common\end-execution.ps1"
