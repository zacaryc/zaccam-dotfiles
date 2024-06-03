#!/bin/bash
# shellcheck disable=SC2139

#------------------------------------
# User specific aliases and functions
#------------------------------------

##
# System Specific Functions
##
if [ -x "$(command -v exa)" ]; then
    alias l="exa --color=auto"
    alias ls="exa --color=auto"
    alias ll="exa -l --color=auto --icons"
    alias la="ll -ah"
    alias tree="exa --icons --tree"
else
    alias l="ls --color=auto"
    alias ls="ls --color=auto"
    alias ll="ls -lah --color=auto"
    alias la="ll -ah"
fi
alias lss="svn st"
alias claer="clear"
alias clera="clear"
alias clearls="clear && ls"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias grep='grep -a --color'
alias egrep='egrep -a --color'
alias zgrep='zgrep -a --color'
alias zegrep='zegrep -a --color'
alias lr="la -R"
alias g="grep"
alias gs="ls | grep"
alias gl="ll | grep"
alias cls="clear; echo '' &&  ls"
##
# Git and SVN commands
##
alias sst="svn st"
alias svnd="svn diff"
alias gst='git status -s'
alias gb='git branch'
alias gc='git checkout'
alias gcp='git checkout production'
alias gf='git fetch --all'
alias gd='git diff'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gp='git up'
alias gitclean='git branch --merged | egrep -v "(^\*|master|dev|production)" | xargs git branch -d'
alias gpu='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias grh='git reset --hard'
alias gg='git grep'
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias gfl='git flow'
##
# Misc
##
alias src="source ~/.$(basename ${SHELL})rc"
alias bashrc="vim ~/.$(basename ${SHELL})rc"
alias zshrc="vim ~/.$(basename ${SHELL})rc"
alias srcvim="source ~/.vimrc"
alias vimrc="vim ~/.vimrc"
alias nvimrc="v ~/.config/nvim"
alias tarc="tar -czvf"
alias tarx="tar -xvzf"
alias zdiff="sdiff -s -W -w250"
alias duh='du -sch * 2>/dev/null | sort -h'
alias du="du -mch"
alias cdb="cd ~/.bin/"
alias cdg="cd ~/git/"
alias cds="cd ~/svn/"
alias cdv="cd ~/.vim/"
alias cdc="cd ~/.config/"
alias cdd="cd ${DOTFILES}"


####################
# FUNCTIONS
####################


# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location

# Set the path on startup to continue using
if [ -f /usr/bin/nvim ]; then
    VIMPATH=/usr/bin/nvim
elif [ -f /usr/local/bin/vim ]; then
    VIMPATH=/usr/local/bin/vim
else
    VIMPATH=/usr/bin/vim
fi

function v() {
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
        if [[ $(( $# % 2 )) -ne 0 ]]
        then
            echo "ERR (mycd): Uneven number of params passed."
            return 1
        fi

        toDir=$(pwd)
        from=''

        for i in "$@"
        do
            if [[ $from == '' ]]
            then
                from=$i
            else
                to=$i
                toDir=$(echo "${toDir}" | sed "s/${from}/${to}/g")
                from=''
            fi
        done

        builtin cd "${toDir}"
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

    git diff "origin/${branch}"
}
alias gdr=git_diff_remote

function gcf()
{
    git diff --name-only origin...HEAD
}
function gdi() # Get Deployment Items
{
    for item in $(gcf); do echo "|${item}|"; done
}

alias gdif="sh /home/${USER}/.bin/get_full_deployment.sh"


function deadsyms()
{
    for f in $(find . -type l -exec sh -c "file -b {} | grep -q ^broken" \; -print 2>/dev/null); do
        echo "Unlinking ${f}";
        unlink "${f}";
    done
}

function mydf()         # Pretty-print of 'df' output.
{                       # Inspired by 'dfc' utility.
    for fs ; do

        if [ ! -d "${fs}" ]
        then
          echo -e "${fs}\" :No such file or directory\"" ; continue
        fi

        local info="( $(command df -P ${fs} | awk 'END{ print $2,$3,$5 }') )"
        local free="( $(command df -Pkh ${fs} | awk 'END{ print $4 }') )"
        local nbstars=$(( 20 * ${info[1]} / ${info[0]} ))
        local out="["
        for ((j=0;j<20;j++)); do
            if [ ${j} -lt ${nbstars} ]; then
               out=$out"*"
            else
               out=$out"-"
            fi
        done
        out="${info[2]}\" \"${out}\"] (\"${free}\" free on \"${fs}\")\""
        echo -e "${out}"
    done
}

git_purge()
{
    git fetch -p && \
    for branch in $(git branch -vv | awk '{print $1,$4}' | grep 'gone]' | awk '{print $1}'); do
        git branch -D $branch;
    done
}

function vf()
{
    # v "$(fzf --select-1 --exit-0)"
    fzf --select-1 --exit-0 --bind "enter:become(${VIMPATH} {})"
}

function vg()
{
    rg --line-number . | fzf --delimiter : --nth 3.. --bind "enter:become(${VIMPATH} {1} +{2})"
}

function vb()
{
    fd -u . "${HOME}/.bin" | fzf --select-1 --exit-0 --bind "enter:become(${VIMPATH} {})"
}

function vd()
{
    fd -H . "${DOTFILES}" | fzf --select-1 --exit-0 --bind "enter:become(${VIMPATH} {})"
}

function mynewcd() {
    if [[ "$#" != 0 ]]; then
        if [[ $# -ge 2 ]]
        then
            if [[ $(expr $# % 2) -ne 0 ]]
            then
                echo "ERR (mycd): Uneven number of params passed."
                return 1
            fi

            toDir=$(pwd)
            from=''

            for i in "$@"
            do
                if [[ $from == '' ]]
                then
                    from=$i
                else
                    to=$i
                    toDir="${toDir//${from}/${to}}"
                    from=''
                fi
            done

            builtin cd "${toDir}" || return
        else
            builtin cd "$@" || return;
        fi
        return
    fi
    while true; do
        local lsd
        lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
        local dir
        dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                ls -p --color=always "${__cd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null || return 123
    done
}

function cdff()
{
    cd "$(fd . --type d | fzf --exit-0 --select-1)" || return
}
alias cdf="cdff"

function custom_changedir()
{
    # If there is a custom check tag, check the project type
    local project_root
    # local custom_checks
    project_root="${1}"
    # custom_checks="${2}"
    # [ -n "${custom_checks}" ] && return
    local dir
    if [ ${FD_EXISTS} -eq 0 ]; then
        dir="$(find "${project_root}" -mindepth 1 -maxdepth 1 -type d -not -path '*/\.*' \
            -not -empty -not -path '*/\_\_*' \
            -exec sh -c 'for f do basename -- "$f";done' sh {} + \
            | fzf-tmux --prompt="Which Project >" --select-1 --exit-0)"
    else
        dir="$(fd . --base-directory="${project_root}" --max-depth 1 --type d \
                | fzf --prompt="Which Project >" --select-1 --exit-0)"
    fi
    builtin cd "${project_root}/${dir}" || return
}
alias cdw='custom_changedir ${HOME}/git/work'
alias cdp='custom_changedir ${HOME}/git/projects'

alias tf='tmuxinator-fzf-start.sh'


if [ -f "${HOME}/.bash_aliases_local" ]; then
    source "${HOME}/.bash_aliases_local"
fi
