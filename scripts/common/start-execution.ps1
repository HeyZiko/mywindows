$DryRun ? "***** THIS IS A DRY RUN *****" : $null

# Include common functions based on the convention of filenames that start with "function-"
foreach ($commonFunction in Get-ChildItem "$PSScriptRoot" -Filter "function*.ps1")
{
  "  Loading $commonFunction"
  . $commonFunction
}

# By default, we want to write out the verbose statements.
$oldVerbosity = $VerbosePreference
$VerbosePreference = "continue"
