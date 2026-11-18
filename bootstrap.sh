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
	if ! command -v brew >/dev/null; then
		# If not installed - install via Ruby
		if command -v ruby >/dev/null; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		else
			echo "Cannot install brew, Ruby is not installed"
			return 1
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

    sudo apt-get update -qq
    read -rp "Wish to upgrade via apt-get?" -n 1;
    echo "";
    if [[ $REPLY =${HOME} ^[Yy]$ ]]; then
        sudo apt-get upgrade
        sudo apt-get autoremove
    fi

    # In mac this can be done in brew
    if ! [ -d ${HOME}/.fzf ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
        ${HOME}/.fzf/install --all
    fi

    sync_repo_list

}

# Little helper function
function link() {  # link <src> <dest>
    if [ -e "$2" ] && [ ! -L "$2" ]; then
        mv "$2" "$2.bak.$(date +%s)"
    fi
    ln -sfn "$1" "$2"
}

# Install: Quick Bootstrap install of dotfiles
function install() {

    _print_header "Starting install"
    case $(uname) in
        'Darwin')
            _print_header "This is a mac - Installing with brewfiles"
            ln -sf ${HOME}/zaccam-dotfiles/Brewfile ${HOME}/Brewfile
			brewsetup
            [ -f ${HOME}/zaccam-dotfiles/.macos ] && source ${HOME}/zaccam-dotfiles/.macos
            ;;
        'Linux')
            _print_header "This is a linux machine"
			debianSetup
            # TODO: Linux Package Support - can also include WSL
            echo "No support for package install yet - TODO"
            ;;
        *)
            _print_header "System doesn't match understood case, bailing"
            exit 1
            ;;

    esac

    for dotfile in "${dotfiles[@]}"; do
        [ -f "${HOME}/zaccam-dotfiles/.${dotfile}" ] && \
            ln -sf "${HOME}/zaccam-dotfiles/.${dotfile}" "${HOME}/.${dotfile}"
    done

    link "$DOTFILES/config" "$HOME/.config"
    link "$DOTFILES/.bin"   "$HOME/.bin"
    _print_header "Dotfiles have been installed!"
}


## UPDATE- Update the existing dotfiles via git pull
function update() {
    _print_header "Updating dotfiles"
    cd ${HOME}/zaccam-dotfiles/ && git pull origin master
    _print_header "Dotfiles have been updated!"
}

# BACKUP - All specified dotfiles to be backed up
function backup() {
    _print_header "Backing up current dotfiles"
    check_create_dir "${HOME}/dotfiles.backup"

    for dotfile in "${dotfiles[@]}"; do
        [ -f "${HOME}/.${dotfile}" ] && [ ! -L "$HOME/.${dotfile}" ] && cp -vR "${HOME}/.${dotfile}" ${HOME}/dotfiles.backup/
    done
    # [ -d ${HOME}/.config ] && cp -vR ${HOME}/dotfiles.backup/
    _print_header "Dotfiles have been backed up!"
}

# Setup a gitconfig local with name and email to remove the hardcoded versions
# from repo that will always cause issues
function setup_git_details()
{
	if ! [ -f "${HOME}/.gitconfig.local" ]
	then
		_print_header "Setting up gitconfig"

		git_credential='cache'
		if [ "$(uname -s)" == "Darwin" ]
		then
			git_credential='osxkeychain'
		fi

		user ' - What is your git author name?'
		read -er git_authorname
		user ' - What is your git author email?'
		read -er git_authoremail

		cat << EOF > "${HOME}/.gitconfig.local"
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
    mkdir -p "${HOME}/.repos.d"
    for f in $DOTFILES/repofiles.d/*; do
        ln -sfn "${f}" "${HOME}/.repos.d/"
    done

    pkgs=()
    while read -r pkg; do
        [[ -z $pkg || $pkg == \#* ]] && continue
            if apt-cache show "$pkg" &>/dev/null; then
                pkgs+=("$pkg")
            else
                echo "Skipping unavailable package: $pkg" >&2
            fi
        done < "${DOTFILES}/repofiles.d/debian.pkgs"

        ((${#pkgs[@]})) && sudo apt-get install -y "${pkgs[@]}"

    # Need to link in fd because an existing program uses the shortcut fd, and
    # thus we have to manually link it - from fd installation page
    command -v fdfind >/dev/null && ln -sf "$(command -v fdfind)" /usr/local/bin/fd
    command -v batcat >/dev/null && ln -sf /usr/bin/batcat /usr/local/bin/bat
}


# Check before create of directories
function check_create_dir()
{
    dir=$1
    [ ! -d "${dir}" ] && mkdir -p "${dir}"
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

    setup_git_details
    # sync_repo_list
	# install_python
	install_tmux
}


# Install Python with pyenv
function install_python() {

    if ! command -v python3; then
        _print_header "Installing Python"
        if command -v pyenv > /dev/null; then
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
	[ ! -d ${HOME}/.tmux/plugins/tpm ] \
		&& git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm \
		&& ${HOME}/.tmux/plugins/tpm/bin/install_plugins
}

# Install tmux
function install_silver()
{
    # Checkout and install silver prompt
	[ ! -d ${DOTFILES}/.cargo/bin/silver ] \
		&& git clone https://github.com/zacaryc/silver.git ${HOME}/git/misc/silver \
		&& cargo install --path "${HOME}/git/misc/silver"
}

case "$1" in
    "")
        read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
        echo "";
        if [[ $REPLY =${HOME} ^[Yy]$ ]]; then
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

