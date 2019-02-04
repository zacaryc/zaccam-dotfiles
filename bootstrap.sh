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
    'bash_logout'
    'gitconfig'
    'global_gitignore'
    'profile'
    'hushlogin'
)


# Check if there is connectivity - ping can be blocked by some firewalls thus
# this implementation
function checkConnectivity() {
	case "$(curl -s --max-time 2 -I http://google.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
	  [23]) echo "HTTP connectivity is up" && return 0;;
	  5) echo "The web proxy won't let us through" && return 1;;
	  *) echo "The network is down or very slow" && return 1;;
	esac
}

# For macOS running all of the brew required steps
function brewsetup() {

	# Check if connectivity is up
	if ! checkConnectivity; then
		echo "Cannot continue brew steps without connectivity. Skipping"
		return 1
	fi

	# Check if brew is installed
	if ! which brew >/dev/null; then
		# If not installed - install via Ruby
		if which ruby >/dev/null; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		else
			echo "Cannot install brew, Ruby is not installed"
			return
		fi
	fi

	brew bundle
	brew doctor
	brew cleanup --force
}

# Install: Quick Bootstrap install of dotfiles
function install() {

    case $(uname) in
        'Darwin')
            _print_header "This is a mac - Installing with brewfiles"
            ln -sf ~/zaccam-dotfiles/Brewfile ~/Brewfile
			brewsetup
            [ -f ~/zaccam-dotfiles/.macos ] || source ~/zaccam-dotfiles/.macos
            ;;
        'Linux')
            _print_header "This is a linux machine"
            # TODO: Linux Package Support - can also include WSL
            echo "No support for package install yet - TODO"
            ;;
    esac

    for dotfile in "${dotfiles[@]}"; do
        [ -f ~/zaccam-dotfiles/.${dotfile} ] && \
            ln -sf ~/zaccam-dotfiles/.${dotfile} ~/.${dotfile}
    done
    [ -d ~/zaccam-dotfiles/.config ] && \
        ln -sfh ~/zaccam-dotfiles/.config ~/.config
    _print_header "Dotfiles have been installed!"
}


## UPDATE- Update the existing dotfiles via git pull
function update() {
    cd ~/zaccam-dotfiles/ && git pull origin master
    _print_header "Dotfiles have been updated!"
}

# BACKUP - All specified dotfiles to be backed up
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
    [ -d ~/Projects/ ] && mkdir -p ~/Projects/

}


# Install Python with pyenv
function install_python() {

    if which pyenv > /dev/null; then
        CFLAGS="-I$(brew --prefix openssl)/include" && export CFLAGS
        LDFLAGS="-L$(brew --prefix openssl)/lib" && export LDFLAGS
        PYENV_ROOT="/usr/local/python" && export PYENV_ROOT

        sudo mkdir -p "$PYENV_ROOT"
        sudo chown -R "$(whoami):admin" "$PYENV_ROOT"

        p "Installing Python 2 with pyenv"
        pyenv install --skip-existing 2.7.13
        p "Installing Python 3 with pyenv"
        pyenv install --skip-existing 3.6.2
        pyenv global 2.7.13

        grep -q "${PYENV_ROOT}" "/etc/paths" || \
        sudo sed -i "" -e "1i\\
    ${PYENV_ROOT}/shims
    " "/etc/paths"

        init_paths
        rehash

        pip install --upgrade "pip" "setuptools"

        # Basic Packages
        pip install --upgrade "requests"
        pip install --upgrade "requests-cache" "requests[security]"

    fi


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

