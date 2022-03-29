. $PSScriptRoot\common-start-execution.ps1

Write-Info 
"========
This script sets up some core environment variables for the scripts and config to work.
========"

$MyWindowsConfig = "$((Get-Item $PSScriptRoot).parent)\config"
$MyWindowsScripts = "$PSScriptRoot"
Write-DarkYellow "Establishing MyWindowsConfig environment variable as $MyWindowsConfig"
[Environment]::SetEnvironmentVariable('MyWindowsConfig',"$MyWindowsConfig",'Machine')
if($env:MyWindowsConfig) {
  Write-Green "`$env:MyWindowsConfig=$env:MyWindowsConfig"
}
else {
  Write-Red "Failed to set `$env:MyWindowsConfig. Consider running this script as Administrator."
}

Write-DarkYellow "Establishing MyWindowsScripts environment variable as $MyWindowsScripts"
[Environment]::SetEnvironmentVariable("MyWindowsScripts","$MyWindowsScripts",'Machine')
if($env:MyWindowsScripts) {
  Write-Green "`$env:MyWindowsScripts=$env:MyWindowsScripts"
}
else {
  Write-Red "Failed to set `$env:MyWindowsScripts. Consider running this script as Administrator."
}

prompt

. $PSScriptRoot\common-end-execution.ps1