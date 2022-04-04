function Wait-Choose
{
  Param(
    [string]$choices,
    [switch]$showOptions
  )
  
  if(-not $choices) {
    Write-DarkYellow "Please specify the characters that the user can Wait-Choose from, eg:"
    Write-DarkYellow "> Wait-Choose ""yn"""
  }

  $characters = $choices.ToCharArray()

  if($showOptions) {
    Write-White "Options: $(foreach ($letter in $characters) { "$letter,"})EOL".Replace(",EOL","")
  }

  #Pause for input
  Do {$choice = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')} 
  until ($characters.Contains($choice.Character))

  return $choice.Character
}