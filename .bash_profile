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
    local hour=$(date +%k)

    if (( hour < 12 )); then
        echo "Доброе утро"
    elif (( hour < 18 )); then
        echo "Добрый день"
    else
        echo "Добрый вечер"
    fi
}

echo "$(greeting) Mr. Campbell. You joined PROS $(( ($(date +%s) - $(date +%s -d '2019/07/03')) / 86400 )) days ago"
echo "There are $(( $(date -d 25-Dec +%j) - $(date +%j))) days until Christmas."
