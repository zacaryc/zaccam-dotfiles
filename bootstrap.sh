#!/usr/bin/env bash

_print_header() {
  printf "\n\e[0;32m > $1\n\n\e[0m"
}

declare -a dotfiles=(
	'vimrc'
	'tmux.conf'
	'zshrc'
	'dircolors'
	'subversion'
	'Xresources'
	'bashrc'
	'bash_aliases'
    'bash_profile'
	'gitconfig'
	'global_gitignore'
    'profile'
)

function install() {

	case $(uname) in
		'Darwin')
			_print_header "This is a mac - Installing with brewfiles"
			ln -sf ~/zaccam-dotfiles/Brewfile ~/Brewfile
            brew bundle
			;;
		'Linux')
			_print_header "This is a linux machine"
			echo "No support for package install yet - TODO"
			;;
	esac

	for dotfile in "${dotfiles[@]}"; do
        [ -f ~/zaccam-dotfiles/.${dotfile} ] && \
            ln -sf ~/zaccam-dotfiles/.${dotfile} ~/.${dotfile}
	done
    [ -d ~/zaccam-dotfiles/.config ] && \
        ln -sf ~/zaccam-dotfiles/.config ~/.config
	_print_header "Dotfiles have been installed!"
}

function update() {
	cd ~/zaccam-dotfiles/ && git pull origin master
	_print_header "Dotfiles have been updated!"
}

function backup() {
	mkdir -p ~/dotfiles.backup/

	for dotfile in "${dotfiles[@]}"; do
		[ -f ~/.${dotfile} ] && cp -vR ~/.${dotfile} ~/dotfiles.backup/
	done
    [ -d ~/.config ] && cp -vR ~/dotfiles.backup/
	_print_header "Dotfiles have been backed up!"
}

# Setup of folder structures etc
function setup() {

	[ -d ~/git/ ] && mkdir -p ~/git/

}


case "$1" in
	"")
		read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
		echo "";
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			setup;
			backup;
			install;
		fi
		;;
	"--install" | "-i")
		install
		;;
	"--update" | "-u")
		update
		;;
	"--backup" | "-b")
		backup
		;;
	*)
		echo "No manual entry for $1"
		;;
esac

