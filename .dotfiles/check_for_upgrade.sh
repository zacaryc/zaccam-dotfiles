#!/usr/bin/env bash

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

function _current_epoch() {
  echo $(($(date +%s) / 60 / 60 / 24))
}

function _update_dotfiles_update() {
  echo "LAST_EPOCH=$(_current_epoch)" > ~/.dotfiles-update
}

function _upgrade_dotfiles() {
  sh ${HOME}/.dotfiles/upgrade.sh
  # update the dotfiles file
  _update_dotfiles_update
}

epoch_target=$UPDATE_DOTFILE_DAYS
if [[ -z "$epoch_target" ]]; then
  # Default to old behavior
  epoch_target=3
fi

# Cancel upgrade if the current user doesn't have write permissions for the
# oh-my-dotfiles directory.
[[ -w "${HOME}" ]] || return 0

# Cancel upgrade if git is unavailable on the system
which git >/dev/null || return 0

if mkdir -p "${HOME}/.log/update.lock" 2>/dev/null; then
  if [ -f ~/.dotfiles-update ]; then
    . ~/.dotfiles-update

    if [[ -z "$LAST_EPOCH" ]]; then
      _update_dotfiles_update && return 0;
    fi

    epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
    if [ $epoch_diff -gt $epoch_target ]; then
      if [ "$DISABLE_UPDATE_PROMPT" = "true" ]; then
        _upgrade_dotfiles
      else
        printf "${BLUE}${BOLD}%s${NORMAL}" "[Oh My dotfiles] Would you like to check for updates? [Y/n]:"
        read line
        if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
          _upgrade_dotfiles
        else
          _update_dotfiles_update
        fi
      fi
    fi
  else
    # create the dotfiles file
    _update_dotfiles_update
  fi

  rmdir ${HOME}/.log/update.lock
fi
