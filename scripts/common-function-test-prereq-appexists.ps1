function Test-AppExists
{
  Param(
    [string]$appName
  )

  Write-Info "PREREQUISITE: is $appName installed and available?
  Here's what I found:
  $((& which $appName).Source)
  Does it look right?"
  if($(choose "yn" -showOptions) -eq 'n') {
    Write-Red "You've identified that the pre-requisite is wrong. Consider re-running or reviewing earlier scripts."
    exit 1
  }
}
