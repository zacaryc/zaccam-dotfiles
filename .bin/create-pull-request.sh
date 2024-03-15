#!/bin/bash

BITBUCKET_URL="stash.pros.com"
USER="zcampbell"

# Build the url string
make_url()
{
    local branch
    branch="$(git rev-parse --abbrev-ref HEAD)"
    local repo
    repo="$(basename $(git rev-parse --show-toplevel))"
    local full_string="${BITBUCKET_URL}/projects/~${USER}/repos/${repo}/pull-requests?create&sourceBranch=refs%2Fheads%2F${branch}"

    echo "${full_string}"
}

full_url="https://$(make_url)"
echo "${full_url}"
# explorer.exe "${full_url}"
/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe "${full_url}"
