function Test-CloudProfile
{
  Write-White "PREREQUISITE: did you already configure `$env:CloudProfile?"
  Write-White "Here's what I found:"
  Write-Cyan "$env:CloudProfile"
  Write-White "Does it look right?"
  if($(choose "yn" -showOptions) -eq 'n') {
    Write-Red "You've identified that the pre-requisite is wrong. Consider re-running or reviewing earlier scripts."
    exit
  }
}
