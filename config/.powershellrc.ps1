#=== Add the following line (uncommented) to $profile, 
#    a variable available in any pwsh session containing the user's 
#    pwsh config script.
#. $env:MyWindowsConfig/.powershellrc.ps1
#===

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

#=== Dev aliases
function src { set-location "c:\src\symend-deployments" }
New-Alias vscode code

#=== Establish the global git include if it doesn't already exist. 
#==== It would have been preferable to use the environment variable directly in the git config, but git doesn't expand envvars grrrr.
$MyWindowsConfigNix = $env:MyWindowsConfig.Replace("\","/")
git config --global include.path $MyWindowsConfigNix/.gitconfig_common

#=== Set up oh-my-posh
Import-Module posh-git
Import-Module oh-my-posh
oh-my-posh init pwsh --config "$env:MyWindowsConfig\.ohmyposh.json" | Invoke-Expression

#=== Register ssh rsa keys so that the password isn't required at every git origin interaction
Start-Service ssh-agent
#ssh-add $env:CloudProfile\.ssh\ziko@zarconsulting.com\id_rsa
ssh-add $env:CloudProfile\.ssh\ziko@rajabali.ca\id_rsa
ssh-add $env:CloudProfile\.ssh\ziko.rajabali@symend.com\id_rsa
