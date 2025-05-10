# mywindows
A set of scripts and config files that help rapidly whip a new windows machine into shape, or keep a current one up-to-date.

## Folder Structure
_Description of the repo folder structure_
- `/config` contains configuration files that are meant to be referenceable
- `/scripts` contain setup and maintenance scripts

## Environment Variables
_These environment variables get set during setup and are required for the solution to work optimally_
- `$CloudProfile` is a folder shared via dropbox, onedrive, etc. containing large files and binaries
- `$MyWindowsConfig` is the local version of this repo's `config` folder
- `$MyWindowsScripts` is the local version of this repo's `scripts` folder

## Prerequisites
- Windows powershell (`winget install microsoft.powershell`)
- git (`winget install git.git`)
- This repo needs to be pulled down locally into a folder that will become the root folder for the aforementioned `$MyWindows*` environment variables
- Windows default execution policy is restricted, but these scripts are unsigned and therefore won't run. To run these scripts, the execution policy will need to be updated (`Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser`)

## Setup
