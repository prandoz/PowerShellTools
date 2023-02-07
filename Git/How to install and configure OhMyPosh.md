# How to install and configure OhMyPosh on PowerShell
### Install OhMyPosh
```
winget install JanDeDobbeleer.OhMyPosh -s winget
```
## Install font, I choose DejaVuSansMono
```
oh-my-posh font install
```

### Go to setting of PowerShell and set to use the new font

### On https://ohmyposh.dev and choose themes and download json from gitHub link, copy json file on folder where do you want store, in my case D:\Config

### Edit profile configuration file
```
code $profile
```
# Enable OhMyPosh on startup with themes
```
oh-my-posh.exe init pwsh --config "D:\Config\wholespace.omp.json" | Invoke-Expression
```
