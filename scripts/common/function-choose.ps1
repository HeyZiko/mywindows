function choose
{
  Param(
    [string]$choices,
    [switch]$showOptions
  )
  
  if(-not $choices) {
    Write-Host "Please specify the characters that the user can choose from, eg:"
    Write-Host "> choose ""yn"""
  }

  $characters = $choices.ToCharArray()

  if($showOptions) {
    Write-Host "Options: $(foreach ($letter in $characters) { "$letter,"})EOL".Replace(",EOL","")
  }

  #Pause for input
  Do {$choice = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')} 
  until ($characters.Contains($choice.Character))

  return $choice.Character
}