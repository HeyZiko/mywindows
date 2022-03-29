. $PSScriptRoot\common-start-execution.ps1

Write-Info "This script sets git and ssh settings."

Test-AppExists "ssh"

Write-Info "Registering valid git destinations."
  ssh git@github.com
  ssh git@bitbucket.org
  ssh git@heroku.org
  ssh git@ssh.dev.azure.com
prompt

. $PSScriptRoot\common-end-execution.ps1