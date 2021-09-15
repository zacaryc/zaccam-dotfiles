#!/bin/bash

# Use this to extract git repos to their positions
install_repos ()
{
    distro=$1
    package_file="${2}/${distro}.pkgs"
    [ ! -f "${package_file}" ] && echo "Distro: [ "${distro}" ] doesn't have packages defined" &&
        exit 3
    echo "Extract Repo"
    echo ${package_file}
    repo_list=$(cat ${package_file} | grep -v "^#" | tr '\n' ' ')
    echo "${repo_list}"
    if [ ${distro} == "debian" ]; then
        sudo apt-get install ${repo_list}
    elif [ ${distro} == "arch" ]; then
        pacman -S ${repo_list}
    elif [ ${distro} == "fedora" ]; then
        sudo yum install ${repo_list}
    else
        echo -e "${BRed}Not sure what to do with distro = ${distro}, not
        continuing/installing anything!${NC}"
    fi
}

# Extracts repos from repo files passed in

echo -e "${BGreen}Bootstrap Debian Repo Script"

distro=$1

[ -z "${distro}" ] && echo "Need to define a distro" && exit 1

echo "Getting repo dir"
repo_def_path="${HOME}/.repos.d"

[ -d "${repo_def_path}" ] || exit 2

echo "All files check out"

install_repos "${distro}" "${repo_def_path}"



