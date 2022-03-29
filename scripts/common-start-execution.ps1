foreach ($commonScript in Get-ChildItem "$PSScriptRoot" -Filter "common-function*.ps1")
{
  # Include common functions by executing each script 
  # that follows the pattern "common-function-<blahblahblah>.ps1" 
  . $commonScript
}

# By default, we want to write out the verbose statements.
$oldVerbosity = $VerbosePreference
$VerbosePreference = "continue"
