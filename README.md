# mywindows
A set of scripts and config files that help rapidly whip a new windows machine into shape, or keep a current one up-to-date.

Basic structure:
- `config` contains configuration files that are meant to be referenceable
- `scripts` contain setup and maintenance scripts

Important environment variables that get set during setup:
- `$CloudProfile` is a folder shared via dropbox, onedrive, etc. containing large files and binaries
- `$MyWindowsConfig` is the local version of this repo's `config` folder
- `$MyWindowsScripts` is the local version of this repo's `scripts` folder
