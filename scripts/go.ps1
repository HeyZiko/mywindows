<#
.SYNOPSIS
  Runs the mywindows configuration

.DESCRIPTION
	Runs the mywindows configuration scripts with feedback from the user.
	Note that the environment scripts require elevated permission.
  TODO: Instead of all the user prompting, use switches across all of the scripts to drive the process.
  TODO: Add a -DryRun switch to all scripts, and have it propagate down. Use the switch to explain what would have been done.

.PARAMETER DryRun
	Display what actions would be taken but don't actually do them.

.PARAMETER EnvSetup #TODO
	Execute environment variable and other low-level system configuration scripts.

.PARAMETER Initialization #TODO
	Execute initialization scripts that are typically done as one-time setups.

.PARAMETER Maintenance #TODO
	Execute maintenance scripts that are typically done as one-time setups.

.LINK
	https://github.com/HeyZiko/mywindows/
#>

param (
  [alias("d")][switch]$DryRun
  #[alias("e")][switch]$EnvSetup,
  #[alias("i")][switch]$Initialization,
  #[alias("m")][switch]$Maintenance
)

. "$PSScriptRoot\common\start-execution.ps1"

#=== Step 1: Initialize the environment variables
Write-White "======"
Write-White "$($DryRun ? "DRYRUN: Pretend " : $null)Run the one-time environment variable setup scripts?"
Write-White "Typically this is done when first setting up a new machine or when performing an overhaul."
if($(choose "yn" -showOptions) -eq 'y') {
  foreach ($script in Get-ChildItem "$PSScriptRoot\initialize" -Filter "env*.ps1")
  {
    Write-White "$($DryRun ? "DRYRUN: Pretend " : $null)Running $script"
    $identity = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
    if (-not $identity.IsInRole($adminRole)) {
      Write-DarkYellow "Execution context doesn't have admin privileges. $($DryRun ? "DRYRUN: Pretend " : $null)Attempting to elevate."
      $command = "$script -DryRun:`$$DryRun; & Read-Host -Prompt 'Press Enter to exit';"
      Write-White "Running $command"
      Start-Process pwsh "$($DryRun ? $null : "-Verb RunAs") -ExecutionPolicy Bypass -NoProfile -Command $command"
    }
    else {
      . $script
    }
  }
}

#=== Step 2: Run all initialize scripts *except* environment variables
Write-White "======"
Write-White "$($DryRun ? "DRYRUN: Pretend " : $null)Run the one-time initialization scripts?"
Write-White "Typically this is done when first setting up a new machine or when performing an overhaul."
if($(choose "yn" -showOptions) -eq 'y'){
  foreach ($script in Get-ChildItem "$PSScriptRoot\initialize" -Filter "*.ps1")
  {
    # Skip env scripts, which needed elevation and were run in a previous block
    if($script -notlike "*env-*") {
      Write-White "$($DryRun ? "DRYRUN: " : $null)Running $script"
      . $script -DryRun:$DryRun
    }
  }  
}

#=== Step 3: Run all maintain scripts
Write-White "======"
Write-White "$($DryRun ? "DRYRUN: Pretend " : $null)Run the maintenance scripts?"
if($(choose "yn" -showOptions) -eq 'y'){
  foreach ($script in Get-ChildItem "$PSScriptRoot\maintain" -Filter "*.ps1")
  {
    Write-White "$($DryRun ? "DRYRUN: " : $null)Running $script"
    . $script -DryRun:$DryRun
  }
}

. "$PSScriptRoot\common\end-execution.ps1"
