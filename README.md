# Zac's Dotfiles

![](https://img.shields.io/github/license/zacaryc/zaccam-dotfiles.svg?style=for-the-badge)

![](https://img.shields.io/github/languages/count/zacaryc/zaccam-dotfiles.svg?style=for-the-badge)

## Getting Started

To install end to end nicely please make sure the following are installed

### Homebrew (MacOS)

*Required:* 
* Ruby - to install and run Homebrew

1. Run ``bootstrap.sh``

----

### Linux

TODO: Setup package installation still
1. Run ``bootstrap.sh``

----

### Windows Setup

*In Powershell*

1. Set Execution policy
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
2. Install Boxstarter
```
. { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
```
3. Windows Config file - should setup WSL and sensible defaults
```
Install-BoxstarterPackage -PackageName windows.ps1 -DisableReboots
```

*In Linux Subsystem*
4. Then afterwards run the regular ``bootstrap.sh`` file in the Windows Linux Subsystem
