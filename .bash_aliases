#------------------------------------
# User specific aliases and functions
#------------------------------------

##
# System Specific Functions
##
alias l="ls"
alias ll="ls -lah"
alias la="ll -ah"
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
alias gp='git pull'
alias gitclean='git branch --merged | egrep -v "(^\*|master|dev|production)" | xargs git branch -d'
alias gpu='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias grh='git reset --hard'
alias gg='git grep'
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
##
# Misc
##
alias src="source ~/.$(basename ${SHELL})rc"
alias bashrc="vim ~/.$(basename ${SHELL})rc"
alias zshrc="vim ~/.$(basename ${SHELL})rc"
alias srcvim="source ~/.vimrc"
alias vimrc="vim ~/.vimrc"
alias tarc="tar -czvf"
alias tarx="tar -xvzf"
alias zdiff="sdiff -s -W -w250"
alias duh='du -sch * 2>/dev/null | sort -h'
alias du="du -mch"
alias cdb="cd ~/.bin/"
alias cdg="cd ~/git/"
alias cds="cd ~/svn/"
alias cdv="cd ~/.vim/"


git_purge()
{
    git fetch -p && \
    for branch in `git branch -vv | awk '{print $1,$4}' | grep 'gone]' | awk '{print $1}'`; do
        git branch -D $branch;
    done
}

# vf() { fzf | xargs -r -I % $EDITOR % ;}
function vf()
{
    vim $(fzf --select-1 --exit-0)
}

function mynewcd() {
    if [[ "$#" != 0 ]]; then
        if [[ $# -ge 2 ]]
        then
            if [[ `expr $# % 2` -ne 0 ]]
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

            builtin cd "${toDir}"
        else
            builtin cd "$@";
        fi
        return
    fi
    while true; do
        local lsd
        lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
        local dir
        dir="$(printf '%s\n' "${lsd[@]}" |
            fzf-tmux --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                ls -p --color=always "${__cd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null
    done
}

function custom_changedir()
{
    local project_root
    project_root="${1}"
    local dir
    dir="$(find "${project_root}" -mindepth 1 -maxdepth 1 -type d -not -path '*/\.*' \
        -not -empty -not -path '*/\_\_*' \
        -exec sh -c 'for f do basename -- "$f";done' sh {} + \
        | fzf-tmux --prompt="Which Project >" --select-1 --exit-0)"
    builtin cd "${project_root}/${dir}"
}
alias cdw='custom_changedir ${HOME}/git/work'
alias cdp='custom_changedir ${HOME}/git/projects'

