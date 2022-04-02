<#
.SYNOPSIS
  Generalized function to insert a line in a config file.

.DESCRIPTION
  This reads a target file, checks to see if it contains a reference
  to the line meant to be inserted, and inserts it if it doesn't exist.
  If the target file doesn't exist, it uses the -CreateIfMissing switch
  to decide what to do.
  Generally, this function is meant to insert a line that reads or sources
  from our prebuilt configs. It's possible to use it for other purposes,
  but that's the intended use.

.PARAMETER DryRun
	Display what actions would be taken but don't actually do them.

.PARAMETER Target
	Specify the target file that should be updated to reference
  the source file. 

.PARAMETER IncludeLine
	The formatted line of text that will be inserted into the Target.
  When using this to configure Target to read from a source file,
  be sure to include the source file reference in the line being
  inserted into the Target.
  A few examples:
  - vi's .vimrc: `execute 'source ' . substitute(substitute('/'.$source, ':\\','/', 'g'    ), '\\', '/', 'g')`
  - bash's .bash_profile: `test -f $source && . $source`
  - pwsh's $profile: `if($source -and (Test-Path $source)) {. $source}`

.PARAMETER NewLine
	Specify the characters that make up a new line. 
  Defaults to `carriage return` + `newline`

.LINK
	https://github.com/HeyZiko/mywindows/
#>
function MyWindows-Update-Config-File
{
  param (
    [alias("d")][switch]$DryRun,
    [string] $Target,
    [string] $IncludeLine,
    [string] $NewLine = "`r`n"
  )

  # Add a bit of buffer between the line being inserted and the rest of the lines.
  $IncludeLineMargined ="$IncludeLine$NewLine"

  Write-White "
  ========
  This script makes '$Target' read from a source
  "

  Test-MyWindowsConfig

  Write-White "Checking for $Target"
  if (-not (Test-Path $Target)) {
    Write-White "No $Target found, $($DryRun ? "DRYRUN: Pretend " : $null)creating it."
    if($DryRun) {
      Write-White "DRYRUN: Would have written the following into $Target :"
      Write-Cyan $IncludeLineMargined
    }
    else {
      $IncludeLineMargined | Set-Content $Target
    }
  }
  else {
    Write-White "Found $Target. Checking to see if you already configured it."
    $existingText = Select-String -Path $Target -pattern $([Regex]::Escape($IncludeLine))
    if($existingText) {
      Write-Green "Looks like you've already configured $Target, nothing more to do here!"
    }
    else {
      Write-DarkYellow "You haven't configured $Target yet. $($DryRun ? "DRYRUN: Pretend " : $null)Updating it now."
      $IncludeLineMargined += ((Get-Content $Target) -join "$NewLine")
      if($DryRun) {
        Write-White "DRYRUN: Would have written the following into $Target :"
        Write-Cyan $IncludeLineMargined
      }
      else {
        $IncludeLineMargined | Set-Content $Target
      }
    }
  }
}