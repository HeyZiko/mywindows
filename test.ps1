. "$((Get-Item $PSScriptRoot))\scripts\common\start-execution.ps1"
$startExecution = "$((Get-Item $PSScriptRoot))\scripts\common\start-execution.ps1"

Write-Red "Yo"
$endExecution = "$((Get-Item $PSScriptRoot))\scripts\common\end-execution.ps1"
. $endExecution
