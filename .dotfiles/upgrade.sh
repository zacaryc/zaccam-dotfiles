# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
fi

printf "${BLUE}%s${NORMAL}\n" "Updating Zac's Dotfiles"
if git --git-dir=${HOME}/.cfg/ --work-tree=${HOME} status --porcelain >/dev/null; then
    git --git-dir=${HOME}/.cfg/ --work-tree=${HOME} stash >/dev/null
    STASHED=1
fi
pushd ${HOME} >/dev/null
if git --git-dir=${HOME}/.cfg/ --work-tree=${HOME} pull --rebase --stat origin master
then
    printf '%s' "$GREEN"
    printf '%s\n'  '  _____            ____        _   '
    printf '%s\n'  ' |__  /__ _  ___  |  _ \  ___ | |_ '
    printf '%s\n'  '   / // _\`|/ __| | | | |/ _ \| __|'
    printf '%s\n'  '  / /| (_| | (__  | |_| | (_) | |_ '
    printf '%s\n'  ' /____\__,_|\___| |____/ \___/ \__|'
    printf '%s\n'  '                                   '
    printf "${BLUE}%s\n" "Hooray! Your dotfiles have been updated and/or is at the current version."
else
    printf "${RED}%s${NORMAL}\n" 'There was an error updating. Try again later?'
fi
popd >/dev/null
if [[ $STASHED ]]; then
     git --git-dir=${HOME}/.cfg/ --work-tree=${HOME} stash pop >/dev/null
 fi
