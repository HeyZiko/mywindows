# Run the MyWindows configuration
. $PSScriptRoot\common\start-execution.ps1

#=== Step 1: Initialize the environment variables
Write-White "======
Should we run the one-time environment variable setup scripts? 
Typically this is done when first setting up a new machine
or when performing an overhaul."
if($(choose "yn" -showOptions) -eq 'y') {
  foreach ($script in Get-ChildItem "$PSScriptRoot\initialize" -Filter "env*.ps1")
  {
    $identity = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
    if (-not $identity.IsInRole($adminRole)) {
      Write-DarkYellow "Execution context doesn't have admin privileges. Attempting to elevate."
      $command = "`"$script; & pause;`""
      Start-Process pwsh -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command $command";
    }
    else {
      . $script
    }
  }
}

#=== Step 2: Run all initialize scripts *except* environment variables
Write-White "======
Should we run the one-time initialization scripts? 
Typically this is done when first setting up a new machine
or when performing an overhaul."
if($(choose "yn" -showOptions) -eq 'y'){
  foreach ($script in Get-ChildItem "$PSScriptRoot\initialize" -Filter "*.ps1")
  {
    # Skip env scripts
    if($script -notlike "*env-*") {
      Write-White "Running $script"
      . $script
    }
  }  
}

#=== Step 3: Run all maintain scripts
Write-White "======
Should we run the maintenance scripts?"
if($(choose "yn" -showOptions) -eq 'y'){
  foreach ($script in Get-ChildItem "$PSScriptRoot\maintain" -Filter "*.ps1")
  {
    . $script
  }
}

. $PSScriptRoot\common\end-execution.ps1
