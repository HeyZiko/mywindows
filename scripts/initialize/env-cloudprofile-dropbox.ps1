. "$((Get-Item $PSScriptRoot).parent)\common\start-execution.ps1"

Write-White "
========
This script uncovers the dropbox location and sets or resets the CloudProfile environment variable.
"
if($env:CloudProfile) {
  Write-DarkYellow "`$env:CloudProfile has already been set as $env:CloudProfile. 
  Reset the CloudProfile environment variable?"
  if($(choose "yn" -showOptions) -eq "n") {
    exit 1
  }
  else {
    Write-Red "When this script completes, review the PATH environment variable 
    because there might some legacy paths that are no longer valid."
    Write-Green "Resetting the CloudProfile environment variable."
  }
}

$profileSubfolder = "\AllAccounts" # The subfolder, if any, for the common profile 

# Find the dropbox folder. See this page for more info: https://help.dropbox.com/installs-integrations/desktop/locate-dropbox-folder
Write-Host "Finding dropbox info.json file"
$dropboxInfoJsonPath1 = "$env:APPDATA\Dropbox\info.json"
$dropboxInfoJsonPath2 = "$env:LOCALAPPDATA\Dropbox\info.json"
$whichDropboxInfoJsonPath = ""
if((Test-Path $dropboxInfoJsonPath1 -PathType Leaf))
{
  $whichDropboxInfoJsonPath = $dropboxInfoJsonPath1
}
if ((Test-Path $dropboxInfoJsonPath2 -PathType Leaf))
{
  $whichDropboxInfoJsonPath = $dropboxInfoJsonPath2
}
if ([string]::IsNullOrWhiteSpace($whichDropboxInfoJsonPath))
{ 
  throw "The dropbox info.json couldn't be found at either of the expected locations. See this page for more info: https://help.dropbox.com/installs-integrations/desktop/locate-dropbox-folder
    Tried Location 1: $dropboxInfoJsonPath1
    Tried Location 2: $dropboxInfoJsonPath2
  "
  prompt
  exit 1
}

# Interpret the JSON to get the dropbox folder
Write-Host "Getting dropbox path from $whichDropboxInfoJsonPath"
$dropboxInfoJson = get-content $whichDropboxInfoJsonPath | convertfrom-json
$dropboxPath = $dropboxInfoJson.personal.path
$dropboxProfilePath = "$dropboxPath$profileSubfolder"

Write-Host "Establishing CloudProfile environment variable as $dropboxProfilePath"
[Environment]::SetEnvironmentVariable('CloudProfile',"$dropboxProfilePath",'Machine')
if($env:CloudProfile) {
  Write-Green "`$env:CloudProfile=$env:CloudProfile"
}
else {
  Write-Red "Failed to set `$env:CloudProfile. Consider running this script as Administrator."
  exit 1
}

. "$((Get-Item $PSScriptRoot).parent)\common\end-execution.ps1"
