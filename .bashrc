# .bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export DOTFILES=${HOME}/zaccam-dotfiles

# Source global definitions
# if [ -f /etc/bashrc ]; then
#     . /etc/bashrc
# fi

if [ -f "${HOME}/.bashrc_local" ]; then
    . "${HOME}/.bashrc_local"
fi

[ -f "${HOME}/.fzf.bash" ] && source "${HOME}/.fzf.bash"

if ! command -V fd &>/dev/null; then
    export FD_EXISTS=0
else
    export FD_EXISTS=1
    export FZF_DEFAULT_COMMAND="fd --type file --follow"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

export FZF_DEFAULT_OPTS='
	 --color=fg:#707880,bg:#1d1f21,hl:#5f819d
	 --color=fg+:#c5c8c6,bg+:#303030,hl+:#0e9ae6
	 --color=info:#85678f,prompt:#81a2be,pointer:#a54242
	 --color=marker:#b294bb,spinner:#373b41,header:#8c9440'

####################
# Set PROMPT
####################

# Set PATH to include cargo if exists
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

export PATH

if command -V silver &>/dev/null; then
    PROMPT_COMMAND=silver_prompt
	silver_prompt() {
		PS1="$(code=$? jobs=$(jobs -p | wc -l) silver lprint)"
	}
	export VIRTUAL_ENV_DISABLE_PROMPT=1
else
    # Source git prompt niceties
    if [ -f "${HOME}/.git-prompt.sh" ]; then
        source "${HOME}/.git-prompt.sh"
    fi

    if [ -d "${DOTFILES}" ]; then
        if [ -d "${DOTFILES}/.dotfiles" ]; then
            source "${DOTFILES}/.dotfiles/prompt.bash"
        fi
    fi
fi

####################
# Colours
####################
# Normal Colors
if [ -z "$_COLORS_DEFINED" ]; then
    readonly Black='\e[0;30m'        # Black
    readonly Red='\033[0;31m'        # Red
    readonly Green='\033[0;32m'      # Green
    readonly Yellow='\e[0;33m'       # Yellow
    readonly Blue='\e[0;34m'         # Blue
    readonly Purple='\033[0;35m'     # Purple
    readonly Cyan='\033[0;36m'       # Cyan
    readonly White='\033[0;37m'      # White

    # Bold
    readonly BBlack='\e[1;30m'       # Black
    readonly BRed='\e[1;31m'         # Red
    readonly BGreen='\e[1;32m'       # Green
    readonly BYellow='\e[1;33m'      # Yellow
    readonly BBlue='\e[1;34m'        # Blue
    readonly BPurple='\e[1;35m'      # Purple
    readonly BCyan='\033[1;36m'      # Cyan
    readonly BWhite='\e[1;37m'       # White

    # Background
    readonly On_Black='\e[40m'       # Black
    readonly On_Red='\e[41m'         # Red
    readonly On_Green='\e[42m'       # Green
    readonly On_Yellow='\e[43m'      # Yellow
    readonly On_Blue='\e[44m'        # Blue
    readonly On_Purple='\e[45m'      # Purple
    readonly On_Cyan='\e[46m'        # Cyan
    readonly On_White='\e[47m'       # White

    readonly NC="\e[m"               # Color Reset

    readonly ALERT=${BWhite}${On_Red} # Bold White on red background
    export _COLORS_DEFINED=true
fi

#------------------------------------------------------------------------------
#-----------------------------------------------------------------------------
Y=$(date "+%Y")
M=$(date "+%m")
NOW=$(date "+%Y%m%d")

####################
# Environment Variables
####################
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:ll:h:clear:exit:history:[ ]*:ls"
export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HISTCONTROL=ignoredups
export HOSTFILE=$HOME/.hosts    # Put a list of remote hosts in ~/.hosts
export EDITOR=nvim
if command -V most &>/dev/null; then
    export PAGER=most
else
    export PAGER="less -RF"
fi
if command -V bat &>/dev/null; then
    export BAT_PAGER="less -RF"
fi
export POWERLINE_FONT=1

####################
# Load Bash Aliases
####################
[ -f "${HOME}/.bash_aliases" ] && . "${HOME}/.bash_aliases"
[ -f "${HOME}/.bash_aliases_local" ] && . "${HOME}/.bash_aliases_local"


####################
# Ruby setup
####################
# Unsure as to what originally required me to add this
# Commenting out for now as it drains time on login
# export PATH="${HOME}/.rbenv/bin:${PATH}"
# eval $(rbenv init --no-rehash -)
# (rbenv rehash &) 2> /dev/null

####################
# Completions
####################

# This has to be at the end
if [ -f "${HOME}/.bash_alias_completion" ]
then
	# shellcheck source=/home/zaccam/.bash_alias_completion
	source "${HOME}/.bash_alias_completion" 2>/dev/null 1>/dev/null &
fi

####################
# Set PATH values
####################

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Set PATH to include cargo if exists
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

# Dedupe the PATH environment variable
PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

# Export PATH back out
export PATH

[ -f "${HOME}/.fzf.bash" ] && source "${HOME}/.fzf.bash"
