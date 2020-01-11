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

if [ -d ${HOME}/.cfg ]; then
    DOTFILES_DIR=${HOME}/.cfg
    WORK_DIR=${HOME}
elif [ -d ${HOME}/zaccam-dotfiles ]; then
    DOTFILES_DIR=${HOME}/zaccam-dotfiles/.git
    WORK_DIR=${HOME}/zaccam-dotfiles
fi

if git --git-dir=${DOTFILES_DIR} --work-tree=${WORK_DIR} status --porcelain &>/dev/null; then
    git --git-dir=${DOTFILES_DIR}/ --work-tree=${WORK_DIR} stash >/dev/null
    STASHED=1
fi
pushd ${HOME} >/dev/null
if git --git-dir=${DOTFILES_DIR}/ --work-tree=${WORK_DIR} pull --rebase --stat origin master >/dev/null
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
if [[ ${STASHED} -eq 1 ]]; then
     git --git-dir=${DOTFILES_DIR}/ --work-tree=${WORK_DIR} stash pop >/dev/null
fi
