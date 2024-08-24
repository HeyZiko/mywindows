<#
.SYNOPSIS
  Sets up a dropbox subfolder as the CloudProfile environment variable.

.PARAMETER DryRun
	Display what actions would be taken but don't actually do them.

.PARAMETER ProfileSubfolder
	The subfolder in the dropbox root where profile and shared data is found.

.LINK
	https://github.com/HeyZiko/mywindows/
#>

param (
  [alias("d")][switch]$DryRun,
  # Default profile subfolder in the cloud drive root:
  [string]$ProfileSubfolder = "\CloudProfile"
)

. "$((Get-Item $PSScriptRoot).parent)\common\start-execution.ps1"

Write-White "
========
This script sets or resets the CloudProfile environment variable for either a dropbox or a onedrive cloud folder.
"
if($env:CloudProfile) {
  Write-DarkYellow "`$env:CloudProfile has already been set as $env:CloudProfile. 
  $($DryRun ? "DRYRUN: Pretend " : $null)Reset the CloudProfile environment variable?"
  if($(Wait-Choose "yn" -showOptions) -eq "n") {
    exit 1
  }
  else {
    Write-Green "$($DryRun ? "DRYRUN: Pretend " : $null)Resetting the CloudProfile environment variable."
  }
}


# Determine which cloud drive to use
$cloudDrive = ""
$cloudProfilePath = ""

Write-White "
====
Which cloud drive do you want to use?
1 = Dropbox
2 = OneDrive (Personal)
3 = OneDrive (Business)
"
$choice = $(Wait-Choose "123" -showOptions)
if ($choice -eq "1") {$cloudDrive = "dropbox"}
elseif ($choice -eq "2") {$cloudDrive = "onedrive-personal"}
elseif ($choice -eq "3") {$cloudDrive = "onedrive-business"}
else {
  Write-Red "Your choice of $choice was not recognized. Exiting."
  exit 1
}


if($cloudDrive -eq "dropbox")
{
  ########
  # Dropbox
  ########

  # Find the dropbox folder. See this page for more info: https://help.dropbox.com/installs-integrations/desktop/locate-dropbox-folder
  Write-White "Finding dropbox info.json file"
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
    exit 1
  }
  
  # Interpret the JSON to get the dropbox folder
  Write-White "Getting dropbox path from $whichDropboxInfoJsonPath"
  $dropboxInfoJson = get-content $whichDropboxInfoJsonPath | convertfrom-json
  $dropboxPath = $dropboxInfoJson.personal.path

  $cloudProfilePath = "$dropboxPath$ProfileSubfolder"
}
elseif ($cloudDrive -eq "onedrive-personal")
{
  $cloudProfilePath = "$env:OneDriveConsumer$ProfileSubfolder"
}
elseif ($cloudDrive -eq "onedrive-business")
{
  $cloudProfilePath = "$env:OneDriveCommercial$ProfileSubfolder"
}
else
{
  Write-Yellow "Did not recognize cloud drive choice $cloudDrive. Exiting."
  exit 1
}

Write-DarkYellow "$($DryRun ? "DRYRUN: Pretend " : $null)Establishing CloudProfile environment variable as $cloudProfilePath"
if(-not $DryRun) {
  [Environment]::SetEnvironmentVariable('CloudProfile',"$cloudProfilePath",'Machine')
  if($?) {
    Write-Green "`$env:CloudProfile=$env:CloudProfile"
  }
  else {
    Write-Red "Failed to set `$env:CloudProfile. Consider running this script as Administrator."
    exit 1
  }
}

. "$((Get-Item $PSScriptRoot).parent)\common\end-execution.ps1"
