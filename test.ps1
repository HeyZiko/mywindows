
Param (
  [alias("d")][switch]$DryRun
  #[alias("e")][switch]$EnvSetup,
  #[alias("i")][switch]$Initialization,
  #[alias("m")][switch]$Maintenance
)

. "$((Get-Item $PSScriptRoot))\scripts\common\start-execution.ps1"

$DryRun.IsPresent
$DryRun.PSStandardMembers
$DryRun.ToString()
$DryRun ? "yes" : "no"

. "$((Get-Item $PSScriptRoot))\scripts\common\end-execution.ps1"
