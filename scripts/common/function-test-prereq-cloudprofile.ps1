function Test-CloudProfile
{
  Write-White "PREREQUISITE: did you already configure `$env:CloudProfile?
  Here's what I found:
  $env:CloudProfile
  Does it look right?"
  if($(choose "yn" -showOptions) -eq 'n') {
    Write-Red "You've identified that the pre-requisite is wrong. Consider re-running or reviewing earlier scripts."
    exit 1
  }
}
