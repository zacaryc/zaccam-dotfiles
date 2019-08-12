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
alias src="source ~/.bashrc"
alias bashrc="vim ~/.bashrc"
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


git_purge()
{
    git fetch -p && \
    for branch in `git branch -vv | awk '{print $1,$4}' | grep 'gone]' | awk '{print $1}'`; do
        git branch -D $branch;
    done
}
