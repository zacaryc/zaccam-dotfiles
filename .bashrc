# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f /home/${USER}/.bashrc_local ]; then
    . /home/${USER}/.bashrc_local
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

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
Y=`date "+%Y"`
M=`date "+%m"`
NOW=`date "+%Y%m%d"`

####################
# Load Bash Aliases
####################
[ -f ${HOME}/.bash_aliases ] && . ${HOME}/.bash_aliases


####################
# FUNCTIONS
####################

# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location
function v() {
    if [ -f /usr/local/bin/vim ]; then
        VIMPATH=/usr/local/bin/vim
    else
        VIMPATH=/usr/bin/vim
    fi

    if [ $# -eq 0 ]; then
        ${VIMPATH} .
    else
        ${VIMPATH} "$@"
    fi
}
alias vim="v"

# cd
function mycd {
    if [[ $# -ge 2 ]]
    then
        if [[ `expr $# % 2` -ne 0 ]]
        then
            echo "ERR (mycd): Uneven number of params passed."
            return 1
        fi

        toDir=`pwd`
        from=''

        for i in $@
        do
            if [[ $from == '' ]]
            then
                from=$i
            else
                to=$i
                toDir=`echo $toDir | sed "s/$from/$to/g"`
                from=''
            fi
        done

        builtin cd $toDir
    else
        builtin cd $*
    fi
}
alias cd='mycd'

alias gdp="git diff origin...HEAD"
git_diff_remote()
{
    if ! git rev-parse --is-inside-git-dir >/dev/null 2>/dev/null; then
        echo "Not inside git directory"
        return
    fi
    local branch="$(git branch | grep \* | cut -d ' ' -f2)"

    git diff origin/${branch}
}
alias gdr=git_diff_remote

function gcf()
{
    git diff --name-only origin...HEAD
}
function gdi() # Get Deployment Items
{
    for item in `gcf`; do echo "|${item}|"; done
}

alias gdif="sh /home/$USER/.bin/get_full_deployment.sh"


function deadsyms()
{
    for f in $(find . -type l -exec sh -c "file -b {} | grep -q ^broken" \; -print 2>/dev/null); do
        echo Unlinking ${f};
        unlink ${f};
    done
}

function mydf()         # Pretty-print of 'df' output.
{                       # Inspired by 'dfc' utility.
    for fs ; do

        if [ ! -d $fs ]
        then
          echo -e $fs" :No such file or directory" ; continue
        fi

        local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )
        local free=( $(command df -Pkh $fs | awk 'END{ print $4 }') )
        local nbstars=$(( 20 * ${info[1]} / ${info[0]} ))
        local out="["
        for ((j=0;j<20;j++)); do
            if [ ${j} -lt ${nbstars} ]; then
               out=$out"*"
            else
               out=$out"-"
            fi
        done
        out=${info[2]}" "$out"] ("$free" free on "$fs")"
        echo -e $out
    done
}

function vf()
{
    vim $(fzf)
}

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:ll:h"
export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HISTCONTROL=ignoredups
export HOSTFILE=$HOME/.hosts    # Put a list of remote hosts in ~/.hosts
export EDITOR=vim
export POWERLINE_FONT=1


export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
