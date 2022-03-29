. $PSScriptRoot\common-start-execution.ps1


Write-Info"========
This script uncovers the dropbox location and sets / resets an environment variable for the shared path.
========"
prompt

$profileSubfolder = "\AllAccounts" # The subfolders, if any, for the common profile 
$portableBinSubfolder = "\AllAccounts\apps\bin" # The subfolders, if any, for portable binaries 

# Find the dropbox folder. See this page for more info: https://help.dropbox.com/installs-integrations/desktop/locate-dropbox-folder
Write-Info "Finding dropbox info.json file"
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
}

# Interpret the JSON to get the dropbox folder
Write-Info "Getting dropbox path from $whichDropboxInfoJsonPath"
$dropboxInfoJson = get-content $whichDropboxInfoJsonPath | convertfrom-json
$dropboxPath = $dropboxInfoJson.personal.path
$dropboxProfilePath = "$dropboxPath$profileSubfolder"
$dropboxProfileBinPath = "$dropboxPath$portableBinSubfolder"

Write-DarkYellow "Establishing CloudProfile environment variable as $dropboxProfilePath"
[Environment]::SetEnvironmentVariable('CloudProfile',"$dropboxProfilePath",'Machine')
if($env:CloudProfile) {
  Write-Green "`$env:CloudProfile=$env:CloudProfile"
}
else {
  Write-Red "Failed to set `$env:CloudProfile. Consider running this script as Administrator."
}

Write-DarkYellow "Add the portable binaries folder to the environment path"
if(-not ($env:PATH -Like "*$dropboxProfileBinPath*"))
{
  SETX PATH "$env:PATH;$dropboxProfileBinPath"
}
if(-not ($env:PATH -Like "*$dropboxProfileBinPath*")){
  Write-Red "Failed to set `$env:PATH. Consider running this script as Administrator."
}

. $PSScriptRoot\common-end-execution.ps1