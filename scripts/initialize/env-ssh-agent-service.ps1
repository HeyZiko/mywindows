<#
.SYNOPSIS
  Configures the ssh-agent service to be started manually.

.DESCRIPTION
  The ssh-agent service spins up automatically when running a git command
  against a remote location, when configured to use ssh. However, this means
  that you have to punch in your rsa key password on every git fetch, 
  git pull, git push, etc.
  In later scripts, we invoke the agent and add the keys with each launch of a
  shell. However, this only works if we can run the ssh-agent manually, which
  we can't in its default state in Windows 10 because it's disabled.
  Therefore, in this script, we change the service parameters to allow 
  it to be started manually.

  See https://stackoverflow.com/questions/52113738/starting-ssh-agent-on-windows-10-fails-unable-to-start-ssh-agent-service-erro

.PARAMETER DryRun
	Display what actions would be taken but don't actually do them.

.LINK
	https://github.com/HeyZiko/mywindows/
#>

param (
  [alias("d")][switch]$DryRun
)

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
  $($DryRun ? "DRYRUN: Pretend " : $null)Reset startup type to manual?"
  if($(choose "yn" -showOptions) -eq "n") {
    exit 1
  }
  else {
    Write-Green "$($DryRun ? "DRYRUN: Pretend " : $null)Resetting startup of ssh-agent to be manual."
  }
}


Write-DarkYellow "$($DryRun ? "DRYRUN: Pretend " : $null)Setting ssh-agent service startup-type to manual"
if(-not $DryRun) {
  $sshAgentService | Set-Service -StartupType Manual
  $sshAgentService = Get-Service ssh-agent
  if($sshAgentService.StartupType -eq 'Manual') {
    Write-Green "ssh-agent startup-type set to $($sshAgentService.StartupType)"
  }
  else {
    Write-Red "Failed to set ssh-agent startup-type. Consider running this script as Administrator."
    exit 1
  }
}

. "$((Get-Item $PSScriptRoot).parent)\common\end-execution.ps1"
