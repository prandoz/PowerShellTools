# How to install and configure OhMyPosh
## With Command prompt or PoweShell install OhMyPosh
winget install JanDeDobbeleer.OhMyPosh -s winget

## On Powershell edit profiel
code $profile

## On Powershell install DejaVuSansMono font
oh-my-posh font install

## Go to setting of PowerShell and set to use DejaVuSansMono font

## Go to https://ohmyposh.dev and choose themes and download json from github
## Copy json on folder, in my case D:\Config

# Enable OhMyPosh on startup with themes
oh-my-posh.exe init pwsh --config "D:\Config\wholespace.omp.json" | Invoke-Expression