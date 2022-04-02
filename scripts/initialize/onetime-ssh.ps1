<#
.SYNOPSIS
  Configures bash_profile to read from our config location.

.PARAMETER DryRun
	Display what actions would be taken but don't actually do them.

.LINK
	https://github.com/HeyZiko/mywindows/
#>

param (
  [alias("d")][switch]$DryRun
)

. "$env:MyWindowsScripts\common\start-execution.ps1"

Test-AppExists "ssh"

Write-White "Registering valid git destinations."
  ssh git@github.com
  ssh git@bitbucket.org
  ssh git@heroku.org
  ssh git@ssh.dev.azure.com
prompt

. "$env:MyWindowsScripts\common\end-execution.ps1"