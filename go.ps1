<#
.SYNOPSIS
  Runs the mywindows configuration

.DESCRIPTION
  Runs the mywindows configuration scripts with feedback from the user.
  Note that the environment scripts require elevated permission.
  TODO: Instead of all the user prompting, use switches across all of the scripts to drive the process.
  To see what each parameter means, run the script with the -?? parameter

.PARAMETER DryRun (d)
  Display what actions would be taken but don't actually do them.

.PARAMETER EnvSetup (e) #TODO
  Execute environment variable and other low-level system configuration scripts.

.PARAMETER Initialization (i) #TODO
  Execute initialization scripts that are typically done as one-time setups.

.PARAMETER Maintenance (m) #TODO
  Execute maintenance scripts that are typically done as one-time setups.

.PARAMETER MaintenanceUpdates (mu)
  Only execute software update maintenance scripts, and don't prompt for each software patch.

.LINK
  https://github.com/HeyZiko/mywindows/
#>

param (
  [alias("??")][switch]$Help,
  [alias("d")][switch]$DryRun,
  #[alias("e")][switch]$EnvSetup,
  #[alias("i")][switch]$Initialization,
  [alias("m")][switch]$Maintenance,
  [alias("mu")][switch]$MaintenanceUpdates #Maintenance only, Winget updates only
)

if($Help) {
  Get-Help "$PSScriptRoot\go.ps1" -Detailed
  Return
}

. "$PSScriptRoot\scripts\common\start-execution.ps1"

# If we're doing maintenance updates, we're necessarily doing maintenance scripts only.
if($MaintenanceUpdates) {$Maintenance = $true}

#=== Step 1: Initialize the environment variables
Write-White "======"
$currentStep = "One-time environment variable setup scripts"
$currentStepContext = "Typically this is done when first setting up a new machine or when performing an overhaul."

if($Maintenance) {
  Write-Yellow "Maintenance mode - Skipping $currentStep."
}
else {
  Write-White "$($DryRun ? "DRYRUN: Pretend " : $null)Run the $currentStep ?"
  Write-White "$currentStepContext"
  if($(Wait-Choose "yn" -showOptions) -eq 'y') {
    foreach ($script in Get-ChildItem "$PSScriptRoot\scripts\initialize" -Filter "env*.ps1")
    {
      $runElevated = $false

      Write-White "$($DryRun ? "DRYRUN: Pretend " : $null)Running $script"
      $identity = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
      $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
      if (-not $identity.IsInRole($adminRole)) {
        Write-DarkYellow "Execution context doesn't have admin privileges. $($DryRun ? "DRYRUN: Pretend " : $null)Attempting to elevate."
        $runElevated = !$DryRun
      }

      if ($runElevated) {
        $scriptWithArgs = "$script $($DryRun ? "-DryRun" : $null)" 
        Write-White "Running $scriptWithArgs"

        $pwshExecutionPolicy = "-ExecutionPolicy Bypass"
        $pwshNoProfile = "-NoProfile"
        $pwshFile = "-File $scriptWithArgs"

        # Run as admin
        try {
          Start-Process -Wait -Verb Runas -FilePath pwsh -ArgumentList "$pwshExecutionPolicy $pwshNoProfile $pwshFile"
        }
        catch {
          # This might be a red herring. Read more: https://stackoverflow.com/a/58721935/1876622
          $ignoreError = "This command cannot be run completely because the system cannot find all the information required."
          if(($Error.Count -gt 0) -and ($Error[$Error.Count-1].Exception.Message -ne $ignoreError)) {
            Write-Red $Error[$Error.Count-1].Exception.Message
          }
        }
      }
      else {
        & $script -DryRun:$DryRun
      }
    }
  }
}

#=== Step 2: Run all initialize scripts *except* environment variables
Write-White "======"
$currentStep = "One-time initialization scripts"
$currentStepContext = "Typically this is done when first setting up a new machine or when performing an overhaul."

if($Maintenance) {
  Write-Yellow "Maintenance mode - Skipping $currentStep."
}
else {
  Write-White "$($DryRun ? "DRYRUN: Pretend " : $null)Run the $currentStep ?"
  Write-White "$currentStepContext"
  if($(Wait-Choose "yn" -showOptions) -eq 'y'){
    foreach ($script in Get-ChildItem "$PSScriptRoot\scripts\initialize" -Filter "*.ps1")
    {
      # Skip env scripts, which needed elevation and were run in a previous block
      if($script -notlike "*env-*") {
        Write-White "Running $script -DryRun:$DryRun"
        & $script -DryRun:$DryRun
      }
    }  
  }
}

#=== Step 3: Run all maintain scripts
Write-White "======"
$currentStep = "Maintenance scripts"
$currentStepContext = "Typically this is done to keep the machine updated (i.e. update or add software packages, shortcuts, etc."

Write-White "$($DryRun ? "DRYRUN: Pretend " : $null)Run the $currentStep $($MaintenanceUpdates ? $null : "?")"
Write-White "$currentStepContext"
if(($MaintenanceUpdates) -or ($(Wait-Choose "yn" -showOptions) -eq 'y')){
  foreach ($script in Get-ChildItem "$PSScriptRoot\scripts\maintain" -Filter "*.ps1")
  {
    Write-White "Running $script -DryRun:$DryRun -UpdatesOnly:$MaintenanceUpdates"
    & $script -DryRun:$DryRun -UpdatesOnly:$MaintenanceUpdates
  }
}

. "$PSScriptRoot\scripts\common\end-execution.ps1"
