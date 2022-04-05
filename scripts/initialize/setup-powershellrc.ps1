<#
.SYNOPSIS
  Configures bash_profile to read from our config location.

.PARAMETER DryRun
	Display what actions would be taken but don't actually do them.

.LINK
	https://github.com/HeyZiko/mywindows/
#>

param (
  [alias("d")][switch]$DryRun
)

. "$env:MyWindowsScripts\common\start-execution.ps1"

$target = $profile;
$source = '$env:MyWindowsConfig\.powershellrc.ps1'
$include = "if(Test-Path $source) { . $source }"

. MyWindows-Update-Config-File -DryRun:$DryRun -Target $target -IncludeLine $include

. "$env:MyWindowsScripts\common\end-execution.ps1"
