#!/usr/bin/env bash

_print_header() {
  printf "\n\e[0;32m > $1\n\n\e[0m"
}

_error() {
  printf "\n\e[1;31m X $1\n\n\e[0m"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
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
	  [23]) return 0;; # HTTP Connectivity is up
	  5) _error "The web proxy won't let us through" && return 1;;
	  *) _error "The network is down or very slow" && return 1;;
	esac
}

# For macOS running all of the brew required steps
function brewsetup() {

	# Check if connectivity is up
	if ! checkConnectivity; then
		_error "Cannot continue brew steps without connectivity. Skipping"
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
	brew cleanup
}

# For Debian/Linux setup files
function debianSetup() {

	# Check if connectivity is up
	if ! checkConnectivity; then
		_error "Cannot continue package updates without connectivity. Skipping debian setup"
		return 1
	fi

    read -p "Wish to update/upgrade via apt-get?" -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo apt-get update
        sudo apt-get upgrade
        sudo apt-get autoremove
    fi

    # In mac this can be done in brew
    if ! [ -f ~/.fzf ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    fi

    sudo apt-get install $(grep -hv "^#" "${HOME}/zaccam-dotfiles/repofiles.d/debian.pkgs")
}


# Install: Quick Bootstrap install of dotfiles
function install() {

    _print_header "Starting install"
    case $(uname) in
        'Darwin')
            _print_header "This is a mac - Installing with brewfiles"
            ln -sf ~/zaccam-dotfiles/Brewfile ~/Brewfile
			brewsetup
            [ -f ~/zaccam-dotfiles/.macos ] || source ~/zaccam-dotfiles/.macos
            ;;
        'Linux')
            _print_header "This is a linux machine"
			debianSetup
            # TODO: Linux Package Support - can also include WSL
            echo "No support for package install yet - TODO"
            ;;
    esac

    for dotfile in "${dotfiles[@]}"; do
        [ -f ~/zaccam-dotfiles/.${dotfile} ] && \
            ln -sf ~/zaccam-dotfiles/.${dotfile} ~/.${dotfile}
    done
    [ -d ~/zaccam-dotfiles/config ] && \
        ln -sf ~/zaccam-dotfiles/config ~/.config
    [ -d ~/zaccam-dotfiles/.bin ] && \
        ln -sf ~/zaccam-dotfiles/.bin ~/.bin
    _print_header "Dotfiles have been installed!"
}


## UPDATE- Update the existing dotfiles via git pull
function update() {
    _print_header "Updating dotfiles"
    cd ~/zaccam-dotfiles/ && git pull origin master
    _print_header "Dotfiles have been updated!"
}

# BACKUP - All specified dotfiles to be backed up
function backup() {
    _print_header "Backing up current dotfiles"
    check_create_dir "${HOME}/dotfiles.backup"

    for dotfile in "${dotfiles[@]}"; do
        [ -f ~/.${dotfile} ] && cp -vR ~/.${dotfile} ~/dotfiles.backup/
    done
    [ -d ~/.config ] && cp -vR ~/dotfiles.backup/
    _print_header "Dotfiles have been backed up!"
}

# Setup a gitconfig local with name and email to remove the hardcoded versions
# from repo that will always cause issues
function setup_git_details()
{
	if ! [ -f ${HOME}/.gitconfig.local ]
	then
		_print_header "Setting up gitconfig"

		git_credential='cache'
		if [ "$(uname -s)" == "Darwin" ]
		then
			git_credential='osxkeychain'
		fi

		user ' - What is your git author name?'
		read -e git_authorname
		user ' - What is your git author email?'
		read -e git_authoremail

		cat << EOF > ${HOME}/.gitconfig.local
[user]
	name = ${git_authorname}
	email = ${git_authoremail}
[credential]
    helper = ${git_credential}
EOF
	fi
}

# Sometimes things don't sit in nice packages
# And I need to clone and build from source
# Sometimes I just have repos that I consistently return back to that I want up
# Can add local work/related repos to bootstrap as well
function sync_repo_list()
{
    for f in $(find $DOTFILES/repofiles.d/); do
        ln -sf ${f} ${HOME}/.repos.d/
    done

    sudo apt-get install $(grep -hv "^#" "${DOTFILES}/repofiles.d/debian.pkgs")
    # Need to link in fd because an existing program uses the shortcut fd, and
    # thus we have to manually link it - from fd installation page
    [ -z "$(which fdfind)" ] && ln -s "$(which fdfind)" /usr/local/bin/fd
    [ -f /usr/bin/batcat ] && ln -s /usr/bin/batcat /usr/local/bin/bat
}


# Check before create of directories
function check_create_dir()
{
    dir=$1
    [ ! -d ${dir} ] && mkdir -p ${dir}
}

# Setup of folder structures etc
function setup() {

    _print_header "Initial Setup"
    check_create_dir "${HOME}/git"
    check_create_dir "${HOME}/git/work"
    check_create_dir "${HOME}/git/projects"
    check_create_dir "${HOME}/git/reference"
    check_create_dir "${HOME}/git/misc"
    check_create_dir "${HOME}/Projects"
    check_create_dir "${HOME}/.tmuxinator"
    check_create_dir "${HOME}/.repos.d/"
    check_create_dir "${HOME}/.bin"

    setup_git_details
    sync_repo_list
	# install_python
	install_tmux
}


# Install Python with pyenv
function install_python() {

    if ! command -v python3; then
        _print_header "Installing Python"
        if which pyenv > /dev/null; then
            CFLAGS="-I$(brew --prefix openssl)/include" && export CFLAGS
            LDFLAGS="-L$(brew --prefix openssl)/lib" && export LDFLAGS
            PYENV_ROOT="/usr/local/python" && export PYENV_ROOT

            sudo mkdir -p "$PYENV_ROOT"
            sudo chown -R "$(whoami):admin" "$PYENV_ROOT"

            # p "Installing Python 2 with pyenv"
            # pyenv install --skip-existing 2.7.13
            printf "Installing Python 3 with pyenv"
            pyenv install --skip-existing 3.6.2
            pyenv global 3.6.2

            grep -q "${PYENV_ROOT}" "/etc/paths" || \
            sudo sed -i "" -e "1i\\ ${PYENV_ROOT}/shims " "/etc/paths"

            init_paths
            rehash

            pip install --upgrade "pip" "setuptools"

            # Basic Packages
            pip install --upgrade "requests"
            pip install --upgrade "requests-cache" "requests[security]"

        fi

        _print_header "Finished installing python"
    fi
}

# Install tmux
function install_tmux()
{
    # Install tmux package manager tpm and plugins
	[ ! -d ~/.tmux/plugins/tpm ] \
		&& git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
		&& ~/.tmux/plugins/tpm/bin/install_plugins
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
    "--setup" | "-s")
        setup
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

