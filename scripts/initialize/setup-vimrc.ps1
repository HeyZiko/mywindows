<#
.SYNOPSIS
  Configures bash_profile to read from our config location.

.PARAMETER DryRun
	Display what actions would be taken but don't actually do them.

.LINK
	https://github.com/HeyZiko/mywindows/
#>

. "$env:MyWindowsScripts\common\start-execution.ps1"

$fileToUpdate = ".vimrc"
$target = "~\$fileToUpdate";
$source = '$MyWindowsConfig."/.vimrc_common"'
$include = "execute 'source ' . substitute(substitute('/'.$source, ':\\','/', 'g'    ), '\\', '/', 'g')"

. MyWindows-Update-Config-File -DryRun:$DryRun -Target $target -IncludeLine $include

. "$env:MyWindowsScripts\common\end-execution.ps1"
