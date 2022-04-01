. "$((Get-Item $PSScriptRoot).parent)\common\start-execution.ps1"

Write-White "
========
This script configures the ssh-agent service to run manually.
See https://stackoverflow.com/questions/52113738/starting-ssh-agent-on-windows-10-fails-unable-to-start-ssh-agent-service-erro
"
$sshAgentService = Get-Service ssh-agent
if($sshAgentService.StartupType -ne 'Disabled') {
  Write-DarkYellow "ssh-agent is already enabled. Details:
  $sshAgentService
  Reset startup type to manual?"
  if($(choose "yn" -showOptions) -eq "n") {
    exit 1
  }
  else {
    Write-Green "Resetting startup of ssh-agent to be manual."
  }
}


Write-DarkYellow "Setting ssh-agent service startup-type to manual"
$sshAgentService | Set-Service -StartupType Manual
$sshAgentService = Get-Service ssh-agent
if($sshAgentService.StartupType -eq 'Manual') {
  Write-Green "ssh-agent startup-type set to $($sshAgentService.StartupType)"
}
else {
  Write-Red "Failed to set ssh-agent startup-type. Consider running this script as Administrator."
  exit 1
}
prompt

. "$((Get-Item $PSScriptRoot).parent)\common\end-execution.ps1"
