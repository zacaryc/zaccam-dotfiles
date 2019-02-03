# Zac's Dotfiles

## Pre-Requisites

To install end to end nicely please make sure the following are installed

### Homebrew (MacOS)

Required: Ruby - to install and run Homebrew
* Run ``bootstrap.sh``

----

### Windows Setup

* Set Execution policy
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
* Install Boxstarter
```
. { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
```
* Windows Config file - should setup WSL and sensible defaults
```
Install-BoxstarterPackage -PackageName windows.ps1 -DisableReboots
```
* Then afterwards run the regular ``bootstrap.sh`` file in the Windows Linux Subsystem
