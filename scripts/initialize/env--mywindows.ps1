<#
.SYNOPSIS
  Sets up the location where mywindows was cloned as a set of environment variables.

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
This script sets up some core environment variables for the scripts and config to work.
"
if($env:MyWindowsScripts -and $env:MyWindowsConfig) {
  Write-DarkYellow "`$env:MyWindowsScripts has already been set as $env:MyWindowsScripts
  and `$env:MyWindowsConfig has already been set as $env:MyWindowsConfig.
  $($DryRun ? "DRYRUN: Pretend " : $null)Reset these environment variables?"
  if($(choose "yn" -showOptions) -eq "n") {
    exit 1
  }
  else {
    Write-Green "$($DryRun ? "DRYRUN: Pretend " : $null)Resetting the environment variables MyWindowsScripts and MyWindowsConfig."
  }
}


$MyWindowsConfig = "$((Get-Item $PSScriptRoot).parent.parent)\config"
$MyWindowsScripts = "$((Get-Item $PSScriptRoot).parent)"
Write-DarkYellow "$($DryRun ? "DRYRUN: Pretend " : $null)Establishing MyWindowsConfig environment variable as $MyWindowsConfig"
if (-not $DryRun) {
  [Environment]::SetEnvironmentVariable('MyWindowsConfig',"$MyWindowsConfig",'Machine')
  if($env:MyWindowsConfig) {
    Write-Green "`$env:MyWindowsConfig=$env:MyWindowsConfig"
  }
  else {
    Write-Red "Failed to set `$env:MyWindowsConfig. Consider running this script as Administrator."
    exit 1
  }
}

Write-DarkYellow "$($DryRun ? "DRYRUN: Pretend " : $null)Establishing MyWindowsScripts environment variable as $MyWindowsScripts"
if (-not $DryRun) {
  [Environment]::SetEnvironmentVariable("MyWindowsScripts","$MyWindowsScripts",'Machine')
  if($env:MyWindowsScripts) {
    Write-Green "`$env:MyWindowsScripts=$env:MyWindowsScripts"
  }
  else {
    Write-Red "Failed to set `$env:MyWindowsScripts. Consider running this script as Administrator."
    exit 1
  }
}

. "$((Get-Item $PSScriptRoot).parent)\common\end-execution.ps1"
