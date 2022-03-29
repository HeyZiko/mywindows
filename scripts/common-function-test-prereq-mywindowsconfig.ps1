function Test-MyWindowsConfig
{
  Write-Info "PREREQUISITE: did you already configure `$env:MyWindowsConfig?
  Here's what I found:
  $env:MyWindowsConfig
  Does it look right?"
  if($(choose "yn" -showOptions) -eq 'n') {
    Write-Red "You've identified that the pre-requisite is wrong. Consider re-running or reviewing earlier scripts."
    exit 1
  }
}
