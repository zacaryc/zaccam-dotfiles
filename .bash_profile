#!/bin/bash

# ~/.bash_profile: executed by the command interpreter for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# Set umask
umask 002

# Set sensible LS COLORS
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "${HOME}/.bashrc" ]; then
	. "${HOME}/.bashrc"
    fi
fi

function greeting {
    local hour
    hour=$(date +%k)

    if (( hour < 12 )); then
        echo "Доброе утро"
    elif (( hour < 18 )); then
        echo "Добрый день"
    else
        echo "Добрый вечер"
    fi
}

echo "$(greeting) Mr. Campbell."

if [ -f "${HOME}/.bash_profile_local" ]; then
    # shellcheck disable=SC1091
    source "${HOME}/.bash_profile_local"
fi
