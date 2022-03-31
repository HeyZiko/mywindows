. "$((Get-Item $PSScriptRoot).parent)\common\start-execution.ps1"

Write-White "
========
This script sets up some core environment variables for the scripts and config to work.
"
if($env:MyWindowsScripts -and $env:MyWindowsConfig) {
  Write-DarkYellow "`$env:MyWindowsScripts has already been set as $env:MyWindowsScripts
  and `$env:MyWindowsCommon has already been set as $env:MyWindowsCommon.
  Reset these environment variables?"
  if($(choose "yn" -showOptions) -eq "n") {
    exit 1
  }
  else {
    Write-Green "Resetting the environment variables MyWindowsScripts and MyWindowsCommon."
  }
}


$MyWindowsConfig = "$((Get-Item $PSScriptRoot).parent)\config"
$MyWindowsScripts = "$PSScriptRoot"
Write-DarkYellow "Establishing MyWindowsConfig environment variable as $MyWindowsConfig"
[Environment]::SetEnvironmentVariable('MyWindowsConfig',"$MyWindowsConfig",'Machine')
if($env:MyWindowsConfig) {
  Write-Green "`$env:MyWindowsConfig=$env:MyWindowsConfig"
}
else {
  Write-Red "Failed to set `$env:MyWindowsConfig. Consider running this script as Administrator."
  exit 1
}

Write-DarkYellow "Establishing MyWindowsScripts environment variable as $MyWindowsScripts"
[Environment]::SetEnvironmentVariable("MyWindowsScripts","$MyWindowsScripts",'Machine')
if($env:MyWindowsScripts) {
  Write-Green "`$env:MyWindowsScripts=$env:MyWindowsScripts"
}
else {
  Write-Red "Failed to set `$env:MyWindowsScripts. Consider running this script as Administrator."
  exit 1
}

prompt

. "$((Get-Item $PSScriptRoot).parent)\common\end-execution.ps1"
