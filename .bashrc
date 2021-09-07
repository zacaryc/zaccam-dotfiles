# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f "${HOME}/.bashrc_local" ]; then
    . "${HOME}/.bashrc_local"
fi

[ -f "${HOME}/.fzf.bash" ] && source "${HOME}/.fzf.bash"
export FZF_DEFAULT_OPTS='
	 --color=fg:#707880,bg:#1d1f21,hl:#5f819d
	 --color=fg+:#c5c8c6,bg+:#303030,hl+:#0e9ae6
	 --color=info:#85678f,prompt:#81a2be,pointer:#a54242
	 --color=marker:#b294bb,spinner:#373b41,header:#8c9440'

# Source git prompt niceties
if [ -f /home/zaccam/.git-prompt.sh ]; then
    source /home/zaccam/.git-prompt.sh
elif [ -f /usr/share/doc/git-1.9.3/contrib/completion/git-prompt.sh ]; then
    source /usr/share/doc/git-1.9.3/contrib/completion/git-prompt.sh
fi

# Normal Colors
Black='\e[0;30m'        # Black
Red='\033[0;31m'        # Red
Green='\033[0;32m'      # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\033[0;35m'     # Purple
Cyan='\033[0;36m'       # Cyan
White='\033[0;37m'      # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\033[1;36m'      # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset

ALERT=${BWhite}${On_Red} # Bold White on red background

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
export EDITOR=vim
export PAGER=most
export POWERLINE_FONT=1

export PATH="${HOME}/.rbenv/bin:${PATH}"
eval "$(rbenv init --no-rehash -)"
(rbenv rehash &) 2> /dev/null
export PATH="${HOME}/.local/bin:${PATH}"

# This has to be at the end
if [ -f "${HOME}/.bash_alias_completion" ]
then
	# shellcheck source=/home/zaccam/.bash_alias_completion
	source "${HOME}/.bash_alias_completion" 2>/dev/null 1>/dev/null &
fi

# Dedupe the PATH environment variable
PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
