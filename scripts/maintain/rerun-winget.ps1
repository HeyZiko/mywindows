<#
.SYNOPSIS
  Credit: Curtis Konelsky
  Install software packages using `winget` package manager.

	See: https://docs.microsoft.com/en-us/windows/package-manager/winget/

.DESCRIPTION
	Provided the name of a text file containing winget package ids, installs all packages that are not already installed.

	NOTES:
	- Installs `winget` if not already installed.
	- If run without a `filename` argument, attempts to find `.winget` from a handful of default locations.
	- Attempts to upgrade packages.

.PARAMETER filename
	Name of a file containing winget package ids, one per line. Blank lines are OK. Lines beginning with '#' are considered comments.
	Get package ids by running `winget search <name of some software>` and check the `id` column.		

.PARAMETER DryRun
	Switch to display what actions would be taken but don't actually do them.

.LINK
	https://docs.microsoft.com/en-us/windows/package-manager/winget/
#>

Param(
	[string]$filename,
	[alias("d")][switch]$DryRun
)

. "$env:MyWindowsScripts\common\start-execution.ps1"

$self = (Join-Path $PSScriptRoot (Split-Path $PSCommandPath -leaf))

# Implement Linux-style --help option.
if ($filename -match '^(--help)$') {
	# Use PowerShell built-in help, but trim off useless automatically-generated end of help message.
	(((Get-Help $self -Detailed) | Out-String) -split '    <CommonParameters>')[0]
	exit 0
}

$defaultPackagesFile = ".winget"
$possiblePackageLocations = @(
	$filename,
	".\$defaultPackagesFile",
	"$PSScriptRoot\$defaultPackagesFile",
	"$env:MyWindowsConfig\$defaultPackagesFile"
)

foreach ($packageLocation in $possiblePackageLocations) {
	if ($packageLocation -and (Test-Path $packageLocation)) {
		Write-Green "Using packages file: $packageLocation"
		$packages = $packageLocation
		break
	}
}
if (-not ($packages)) {
	Write-Red "Couldn't find any package files. Please specify the full path and file name containing winget packages to install."
	exit 1
}

# Find or install winget
$winget = (& "$Env:windir\system32\where.exe" "winget")
if ( $? ) {
	"Found winget at: $winget"
	if ($DryRun) {
		Write-DarkYellow "Operating in -DryRun mode; no changes will be made"
	}
}
else {
	if ($DryRun) {
		Write-Red "Winget not found; would attempt to install if -DryRun not specified"
		exit 1
	}
	Write-DarkYellow "Winget not found; attempting to fetch package from GitHub..."
	$package = "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
	curl -L -o $package https://aka.ms/getwinget
	if ( -not $? ) {
		Write-Red "ERROR: Failed trying to fetch winget!"
		exit 1
	}
	"Attempting to install App Installer package..."
	Add-AppxPackage -Path .\$package | Out-Default
	if ( $? ) {
		Write-Green "Installed winget."
	}
	else {
		Write-Red "ERROR: Failed trying to install package $package"
		exit 1
	}
	"Confirming winget installed..."
	$winget = "$Env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"
	if ( -not (Test-Path $winget) ) {
		Write-Red "ERROR: winget not found at $winget"
		exit 1
	}
}

"Gathering installed packages list..."
# If script pauses here, type Y and press Enter
# winget requires accepting terms and sending geographic location id
$installed = (& "$winget" "list")
if ( -not $? ) {
	Write-Red "ERROR: tried running 'winget list' but failed: code=$? result=$installed"
	exit 1
}
$installedArray = $installed -split "\n"


# Install packages
@(Get-Content $packages) | ForEach-Object {
	# Lines starting with '#' are treated as comments and are echoed to screen as are blank lines
	if (($_ -like '#*') -or ([string]::IsNullOrWhiteSpace($_))) {
		Write-DarkCyan "$_"
	}
 else {
		# Check if candidate package is already installed, in two ways:
		# (1) check if package name appears in `winget list` output (previously captured in $installed variable)
		# (2) check if package name appears when doing a specific query by exact id: `winget list --id <id>'
		# Why isn't (1) good enough?  Because the ids can differ!
		# `winget list` reports the ids from Windows "Apps & features" list, whereas
		# `winget list --id <id>` reports the id that the winget package has in its manifest
		#
		# Example:
		#
		# $ winget.exe list
		# Name                          Id                                 Version  Available   Source
		# --------------------------------------------------------------------------------------------
		# Mozilla Firefox (x64 en-US)   Mozilla Firefox 95.0 (x64 en-US)   95.0     98.0.2
		#
		# $ winget.exe list --id Mozilla.Firefox
		# Name            Id              Version Available   Source
		# ----------------------------------------------------------
		# Mozilla Firefox Mozilla.Firefox 95.0    98.0.2      winget
		#
		$pkg = [Regex]::Escape("$_")
		
		$installedPkg = $installedArray -match $pkg
		if (($installedPkg) -or ((& $winget "list" "--id" "$_") -match $pkg)) {
			if ($installedPkg -match "((\d+\.){2,4}(\s|...)+){2,}\.*winget$") {
				if ($DryRun) {
					Write-Yellow "Would attempt to upgrade package: $_"
				}
				else {
					Write-Yellow "Upgrade package $($_)?"
					$result = Wait-Choose "yn" -showOptions
					if ($result -eq 'y') {
						Write-Green "Upgrading package $_"
						& "$winget" "upgrade" "$_"
					}
					else {
						Write-DarkYellow "Skipping upgrade of $_"
					}
				}
			}
			else {
				Write-Green "$_ already installed; no upgrades available."
			}
		}
		else {
			if ($DryRun) {
				Write-Yellow "Would attempt to install package: $_"
			} 
			else {
				Write-Yellow "Install package $($_)?"
				$result = Wait-Choose "yn" -showOptions
				if ($result -eq 'y') {
					Write-Green "Installing package $_"
					& "$winget" "install" "$_"
				}
				else {
					Write-DarkYellow "Skipping package $_"
				}
			}
		}
	}
}
if ($DryRun) {
	"`nRun the command again without -DryRun to actually install or update packages"
}

. "$env:MyWindowsScripts\common\end-execution.ps1"
