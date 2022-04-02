# Return verbosity to what it was previously
$VerbosePreference = $oldVerbosity

if($Indent) {
  if($Indent.Length -ge 2) {
    $Indent = $Indent.Substring(0, $Indent.Length-2)
  }
}

"$Indent/\ /\ /\ /\ /\ /\ /\ /\ /\"
