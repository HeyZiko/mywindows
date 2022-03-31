. "$((Get-Item $PSScriptRoot).parent)\common\start-execution.ps1"


Write-White "
========
This script adds a bin folder from CloudProfile to the PATH environment variable.
"

Test-CloudProfile

$portableBinSubfolder = "$env:CloudProfile\apps\bin" # The subfolder, if any, for portable binaries 

Write-DarkYellow "Adding the portable binaries folder to the environment path"
if(-not ($env:PATH -Like "*$portableBinSubfolder*"))
{
  SETX PATH "$env:PATH;$portableBinSubfolder"
}
if(-not ($env:PATH -Like "*$portableBinSubfolder*")){
  Write-Red "Failed to set `$env:PATH. Consider running this script as Administrator."
}

. "$((Get-Item $PSScriptRoot).parent)\common\end-execution.ps1"
