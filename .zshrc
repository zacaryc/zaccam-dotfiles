# Path to your oh-my-zsh installation.
export ZSH=/Users/Zac/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="spaceship"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=5

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

 # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git jira catimg)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin"
if [ -d $HOME/.cabal/bin ]; then export PATH="$PATH:$HOME/.cabal/bin"; fi
if which go > /dev/null; then export PATH="$PATH:$(go env GOPATH)/bin"; fi
if [ -d /Users/Zac/anaconda3/bin ]; then export PATH="/Users/Zac/anaconda3/bin:$PATH"; fi

if [ -f $ZSH/oh-my-zsh.sh ]; then
    source $ZSH/oh-my-zsh.sh
fi

# Auto Update the vim packages
# source $HOME/zaccam-dotfiles/updates.sh

####################
# Load Bash Aliases
####################
[ -f ${HOME}/.bash_aliases ] && . ${HOME}/.bash_aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias cdp="cd ~/Projects"

DIR_BROWSER=ranger
command -v ${DIR_BROWSER} >/dev/null 2>&1 || { echo >&2 "MY ZSHRC: ${DIR_BROWSER} not found - will use native vim netrw for directory browsing in v()"; DIR_BROWSER=vim }
function v()
{
    if [ $# -eq 0 ]; then
        ${DIR_BROWSER} .
    else
        if [ -d $1 ]; then
            ${DIR_BROWSER} $@
        else
            vim $@
        fi
    fi
}

