function Test-MyWindowsConfig
{
  Write-White "PREREQUISITE: did you already configure `$env:MyWindowsConfig?"
  Write-White "Here's what I found:"
  Write-Cyan "$env:MyWindowsConfig"
  Write-White "Does it look right?"
  if($(Wait-Choose "yn" -showOptions) -eq 'n') {
    Write-Red "You've identified that the pre-requisite is wrong. Consider re-running or reviewing earlier scripts."
    exit
  }
}
