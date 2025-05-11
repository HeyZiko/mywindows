#=== Add the following line (uncommented) to $profile, 
#    a variable available in any pwsh session containing the user's 
#    pwsh config script.
#if (Test-Path $env:MyWindowsConfig\.powershellrc.ps1) { . $env:MyWindowsConfig\.powershellrc.ps1 }
#===

#== Folder aliases
function mywindows { set-location "$env:MyWindowsScripts\.." }

#== Common linux commands
New-Alias which get-command
New-Alias less get-content
New-Alias grep select-string
New-Alias vim "$env:CloudProfile\apps\vim\vim.exe"
New-Alias vi vim
function touch {set-content $args ""}

#=== Git aliases
New-Alias gitlog "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
New-Alias mergeff "git merge --ff-only"
New-Alias fetch "git fetch"
New-Alias pull "git pull"
New-Alias push "git push"
New-Alias checkout "git checkout"
New-Alias github "gh"

#=== Dev aliases
New-Alias vscode code
function src { set-location "~\source"}

#=== Media aliases: Manage media from the CLI
# https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
# Send-VirtualKey is a ps1 script that runs unmanaged code (user32.dll),
#  therefore it's not kept in the MyWindows repo. Instead, it's in the cloudprofile bin folder.
function next { Send-VirtualKey -KeyCode 0xB0 } # VK_MEDIA_NEXT_TRACK
New-Alias skip next
function prev { Send-VirtualKey -KeyCode @(0xB1, 0xB1) } # VK_MEDIA_PREV_TRACK
function replay {Send-VirtualKey -KeyCode 0xB1 } # VK_MEDIA_PREV_TRACK
function stop { Send-VirtualKey -KeyCode 0xB2 } # VK_MEDIA_STOP
function pause { Send-VirtualKey -KeyCode 0xB3 } # VK_MEDIA_PLAY_PAUSE
New-Alias play pause

#=== Establish the global git include if it doesn't already exist. 
#==== It would have been preferable to use the environment variable directly in the git config, but git doesn't expand envvars grrrr.
$MyWindowsConfigNix = $env:MyWindowsConfig.Replace("\","/")
git config --global include.path $MyWindowsConfigNix/.gitconfig_common

#=== Set up oh-my-posh
oh-my-posh init pwsh --config "$env:MyWindowsConfig\.ohmyposh.json" | Invoke-Expression

#=== Get git working with ssh 
Start-Service ssh-agent
# $env:GIT_SSH = $(which ssh).Source.Replace("\","/") # git works with forward slashes, not backslashes
git config --global core.sshCommand $(which ssh).Source.Replace("\","/") # git requires Nix-style pathing

#=== Register the ssh rsa keys so that the password isn't required at every git origin interaction
# Get-ChildItem -Path "$env:CloudProfile\.ssh\" -Recurse -Filter "id_rsa" | Foreach-Object {
#  ssh-add $_
# }
