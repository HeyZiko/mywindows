. $PSScriptRoot\common-start-execution.ps1


# For the latest Windows Terminal settings.json target, see https://docs.microsoft.com/en-us/windows/terminal/install#settings-json-file"
$fileToUpdate = "settings.json"
$target = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\$fileToUpdate";
$source = "$env:MyWindowsConfig\.windows-terminal.settings.json"
$verificationContent = "574e775e-4f2a-5b96-ac1e-a2962a402336"

Write-Info "This script replaces the content in $fileToUpdate with the content in $source."

Test-MyWindowsConfig

Write-Info "Checking for $target"
if (-not (Test-Path $target)) {
  Write-Info "No $target found, creating it."
  Copy-Item $source -Destination $target
}
else {
  Write-Info "Found $target. Checking to see if you already configured it to use DropboxCommon."
  $existingText = Select-String -Path $target -pattern $verificationContent
  Write-Info "$existingText"
  if($existingText -eq $null) {
    Write-Info "Looks like you've already configured $target, nothing more to do here!"
  }
  else {
    Write-Info "You haven't configured $target yet. Overwrite it now?"
    $response = choose "yn"
    if ($response = 'y')
    {
      Copy-Item $source -Destination $target
    }
  }
}
prompt

. $PSScriptRoot\common-end-execution.ps1
