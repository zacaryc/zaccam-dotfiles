#!/bin/bash

BITBUCKET_BASE="${BITBUCKET_BASE:-https://bitbucket.dev.smbc.nasdaqomx.com}"
BITBUCKET_REPOSITORY_SLUG="${BITBUCKET_REPOSITORY_SLUG:-PUPPET}"
BITBUCKET_REPOSITORY_NAME="${BITBUCKET_REPOSITORY_NAME:-puppet-ops}"

PULLREQUEST_REST_URL_PUPPET="${BITBUCKET_BASE}/rest/api/latest/projects/${BITBUCKET_REPOSITORY_SLUG}/repos/${BITBUCKET_REPOSITORY_NAME}/pull-requests"
PULLREQUEST_URL="${BITBUCKET_BASE}/projects/${BITBUCKET_REPOSITORY_SLUG}/repos/${BITBUCKET_REPOSITORY_NAME}/pull-requests"

PULLREQUEST_ID=""

PUPPET_DIR=${PUPPET_DIR:-${HOME}/git/puppet/}
AFFECTED_SERVERS=()
AFFECTED_MARKETS=()
AFFECTED_REGIONS=()
AFFECTED_OS=()
AFFECTED_DIRECTORIES=()
AFFECTED_INPUT_DIRECTORIES=()
AFFECTED_OUTPUT_DIRECTORIES=()
REBENCH_MARKETS=()
RECACHE_MARKETS=()
type="None"

JSON_PARSE_ID_FUNC="import sys, json
j=json.load(sys.stdin)
v=j.get('values', [])
r=v.pop(0).get('id', []) if v else {}
print r";

#############################
# Bitbucket Functions
#############################
function getPullRequestURL()
{
    local repository="$1"
    local url_type="$2"

    if [ -z ${url_type} ]; then
        url_type="full"
    fi

    if [[ ${repository^^} == "PUPPET" ]]; then
        BITBUCKET_REPOSITORY_SLUG="PUPPET"
        BITBUCKET_REPOSITORY_NAME="puppet-ops"
    elif [[ ${repository^^} == "TEMPLATES" ]]; then
        BITBUCKET_REPOSITORY_SLUG="SBMI"
        BITBUCKET_REPOSITORY_NAME="templates"
    fi

    # Return the Full URL
    if [[ ${url_type^^} == "REST" ]]; then
        echo "${BITBUCKET_BASE}/rest/api/latest/projects/${BITBUCKET_REPOSITORY_SLUG}/repos/${BITBUCKET_REPOSITORY_NAME}/pull-requests"
    else
        echo "${BITBUCKET_BASE}/projects/${BITBUCKET_REPOSITORY_SLUG}/repos/${BITBUCKET_REPOSITORY_NAME}/pull-requests"
    fi
}

function getPullRequestRestURL()
{
    echo "$(getPullRequestURL "${1^^}" "REST")"
}

function getPullRequestID()
{
    local git_branch="$1"
    local repository="$2"

    local FULL_PULLREQUEST_REST_URL="$(getPullRequestRestURL "${repository^^}")?at=refs/heads/${git_branch}&direction=outgoing"

    [ -z "${PASSWORD}" ] || CREDENTIALS="${USER}:${PASSWORD}"
    xmlreturn=$(curl -k --silent -u "$CREDENTIALS" "${FULL_PULLREQUEST_REST_URL}")
    PULLREQUEST_ID=$(echo "${xmlreturn}" | python -c "${JSON_PARSE_ID_FUNC}")

    echo "${PULLREQUEST_ID}"
}

# Create the PR if it's missing
function createPullRequest()
{
    local repository=${1}
    local PULL_REQUEST_URL="$(getPullRequestRestURL "${repository^^}" "REST")"

    if [[ ${repository^^} == "PUPPET" ]]; then
        main_branch="production"
    else
        main_branch="master"
    fi

    # PUPPET BRANCH is expected to match the TEMPLATES branch too
    local JSON_DATA_PR_REQUEST="{\"title\": \"${PUPPET_BRANCH}\", \"description\": \"Pull Request Auto Generated via Get Full Deployment. Edit as needed\", \"fromRef\": {\"id\": \"refs/heads/${PUPPET_BRANCH}\"}, \"toRef\": {\"id\": \"refs/heads/${main_branch}\"}}"

    [ -z "${PASSWORD}" ] || CREDENTIALS="${USER}:${PASSWORD}"
    curl --silent -k --user "${CREDENTIALS}" -X POST -H 'Content-Type: application/json' --data "${JSON_DATA_PR_REQUEST}" ${PULL_REQUEST_URL} 2>/dev/null >/dev/null
}

#############################
# Add Functions
#############################

# Check if already exists in array
function addToAffectedMarket()
{
    new_entries="$@";

    for new_entry in $new_entries; do
        if [[ ! " ${AFFECTED_MARKETS[@]} " =~ " ${new_entry} " ]]; then
            AFFECTED_MARKETS+=("${new_entry}");
        fi
    done
}
# Check if already exists in array
function addToAffectedDirectories()
{
    new_entries="$@";

    for new_entry in $new_entries; do
        if [[ ! " ${AFFECTED_DIRECTORIES[@]} " =~ " ${new_entry} " ]]; then
            AFFECTED_DIRECTORIES+=("${new_entry}");
        fi
    done
}
# Check if already exists in array
function addToAffectedServer()
{
    new_entries="$@";

    for new_entry in $new_entries; do
        new_entry="${new_entry%%.*}";
        canonical_name=$(nslookup ${new_entry} | grep -Po "(?<=Name:\t).+?[^\.]+")

        # Hack for those that aren't properly in the DNS i.e. au04
        if [[ -z "${canonical_name}" ]]; then
            canonical_name=${new_entry}
        fi

        if [[ "x${new_entry}" == "x${canonical_name}" ]]; then
            client_name=$(getClientName ${canonical_name})
            full_server="${client_name}(${canonical_name})"
        else
            full_server="${new_entry}(${canonical_name})"
        fi
        if [[ ! " ${AFFECTED_SERVERS[@]} " =~ " ${full_server} " ]]; then
            AFFECTED_SERVERS+=("${full_server}");
            getRegion "${full_server}"
        fi
    done
}

#############################
# Get details functions
#############################
# Get Client Name for Server from canonical name
# Input should be full server canonical name
# Strip file down to the basename first
function getClientName()
{
    local canonical_name=$1;
    local HIERA_LOCATION="${HIERA_LOCATION:-${PUPPET_DIR}hiera/node}";

    stripped_canonical_name="${canonical_name##*/}";

    client_name=$(grep -Po "(?<=::client_name: ')[^']+" ${HIERA_LOCATION}/${stripped_canonical_name}*);

    if [ -z ${client_name} ]; then
        client_name=$(grep -Po "(?<=::server_alias: ')[^']+" ${HIERA_LOCATION}/${stripped_canonical_name}*);
    fi

    echo "${client_name}";
}

# Get the expected region by trying to parse the server name
function getRegion()
{
    local server=$1;
    if [[ "$server" =~ nl0.+ || "$server" =~ emea ]]; then
        if [[ ! " ${AFFECTED_REGIONS[@]} " =~ "EMEA" ]]; then
            AFFECTED_REGIONS+=("EMEA");
        fi
    elif [[ "$server" =~ au0.+ || "$server" =~ apac ]]; then
        if [[ ! " ${AFFECTED_REGIONS[@]} " =~ "APAC" ]]; then
            AFFECTED_REGIONS+=("APAC");
        fi
    elif [[ "$server" =~ ca0.+ || "$server" =~ ".+-us" ]]; then
        if [[ ! " ${AFFECTED_REGIONS[@]} " =~ "NSAC" ]]; then
            AFFECTED_REGIONS+=("NSAC");
        fi
    fi
}

# Get the server the feedprocessor config is installed on
function getServerFromFP()
{
    config=$1;
    local HIERA_LOCATION="${HIERA_LOCATION:-${PUPPET_DIR}hiera/node}";

    config_servers=$(grep -l ${config} ${HIERA_LOCATION}/*);
    for config_server in ${config_servers}; do
        client_name=$(getClientName ${config_server});
        addToAffectedServer ${client_name};
    done
}

# Get the server the feedprocessor config is installed on
function getDirectory()
{
    local config=$1;
    if [[ $type =~ Feedprocessor ]]; then
        local FEEDPROCESSOR_LOCATION="${FEEDPROCESSOR_LOCATION:-${PUPPET_DIR}modules/feedprocessor/files/configs}";
        [ ! -f ${FEEDPROCESSOR_LOCATION}/${config} ] && return
        for directory in $(sed -n '/<input.*>/,/<\/input>/p' ${FEEDPROCESSOR_LOCATION}/${config} | grep -Po '(?<=marketCode>)[^<]+' | sort -u); do
            addToAffectedDirectories "${directory}"
        done
        for directory in $(sed -n '/<output.*>/,/<\/output>/p' ${FEEDPROCESSOR_LOCATION}/${config} | grep -Po '(?<=marketCode>)[^<]+' | sort -u); do
            addToAffectedDirectories "${directory}"
        done
    fi
    if [[ $type =~ Monitorupload ]]; then
        local MONITORUPLOAD_LOCATION="${MONITORUPLOAD_LOCATION:-${PUPPET_DIR}modules/monitorupload/files/}";
        [ ! -f ${MONITORUPLOAD_LOCATION}/${config} ] && return
        for directory in $(grep -Po "(?<=market=\")[^\"]+" ${MONITORUPLOAD_LOCATION}/${config} | sort -u); do
            addToAffectedDirectories "${directory}"
        done
    fi
    if [[ $type =~ Brokersync ]]; then
        local BROKERSYNC_LOCATION="${BROKERSYNC_LOCATION:-${PUPPET_DIR}modules/brokersync/files/}";
        [ ! -f ${BROKERSYNC_LOCATION}/${config} ] && return
        for directory in $(sed -n "/destination>/,/<\/destination/p" ${BROKERSYNC_LOCATION}/${config} \
            | grep -Po "(?<=file:///smarts/data/)[^/]+" | sort -u); do
            addToAffectedDirectories "${directory}"
        done
    fi
    if [[ $type =~ KitchensyncServer ]]; then
        local KITCHENSYNC_MODULE_LOCATION=${KITCHENSYNC_MODULE_LOCATION:-modules/kitchensync/files/servers}
        local KITCHENSYNC_LOCATION=${KITCHENSYNC_LOCATION:-${PUPPET_DIR}${KITCHENSYNC_MODULE_LOCATION}}
        # Add back file extension
        config="${config}.properties"

        # Don't bother if the file is deleted locally - too much to parse through
        [ -f ${KITCHENSYNC_LOCATION}/${config} ] || continue

        # Get the full list of managed dirs on prod
        prod_dirs=$(git show remotes/origin/production:${KITCHENSYNC_MODULE_LOCATION}/${config} \
            | grep -Po "(?<=marketCode=|kitsyncDirName=)([a-z0-9A-Z_]+)$" | sort -u)
        # Get the full list of managed dirs on the branch
        branch_dirs=$(grep -Po "(?<=marketCode=|kitsyncDirName=)([a-z0-9A-Z_]+)$" ${KITCHENSYNC_LOCATION}/${config} | sort -u);
        # Get list of unique dirs
        changed_dirs=$(echo " ${prod_dirs} ${branch_dirs} " | tr ' ' '\n' | sort | uniq -u)

        for directory in "${changed_dirs}"; do
            addToAffectedDirectories "${directory}"
        done
    fi
}

# Check if the MC Change Requires Re-Caching or ReBenchmarking for Deployment Times
function checkReCacheBenchmark()
{
    local config=$1
    SMARTS_PATH=${SMARTS_PATH:-${PUPPET_DIR}modules/smarts/files}
    RESOURCE_DIR=${PUPPET_DIR}/tests/config-unit-tests/projects/market/resources

    change_keys=$(git diff origin...HEAD -U0 ${SMARTS_PATH}/${config} \
        | sed 's/#.*$//' | grep -P "^[+-][^=\s+-]+=" | sed -r 's/[+-]([^=]+)=.*/\1/' \
        | sort -u)

    local file="${config##*/}"
    local market="${file%.*}"
    for key in ${change_keys}; do
        if grep -qx "${key}" ${RESOURCE_DIR}/recache_properties; then
            if [[ ! " ${RECACHE_MARKETS[@]} " =~ " ${market} " ]]; then
                RECACHE_MARKETS+=("${market}")
            fi
        fi
        if grep -qx "${key}" ${RESOURCE_DIR}/rebench_properties; then
            if [[ ! " ${REBENCH_MARKETS[@]} " =~ " ${market} " ]]; then
                REBENCH_MARKETS+=("${market}")
            fi
        fi
    done
}

# Find all changes and then flter them into all available catgeories
function getAllChanges()
{
    # Added items
    git diff origin...HEAD --summary -M --diff-filter=A --name-status | awk '{print "|"$2"|Added|"}'
    #Removed Items
    git diff origin...HEAD --summary -M --diff-filter=D --name-status | awk '{print "|"$2"|Removed|"}'
    # Modified Items
    git diff origin...HEAD --summary -M --diff-filter=M --name-status | awk '{print "|"$2"|Updated|"}'
    # Renamed Items
    git diff origin...HEAD --summary -M --diff-filter=R --name-status | awk '{print "|"$3"|Renamed From: "$2"|"}'
    # Copied Items
    git diff origin...HEAD --summary -M --diff-filter=C --name-status | awk '{print "|"$3"|Copied From $2|"}'
    # Misc Items
    # B = Broken Type
    # U = Unmerged
    # X = Unknown (Unstable state)
    # T = Type changed i.e. regular file to symlink etc
    git diff origin...HEAD --summary -M --diff-filter=BUXT --name-status | awk '{print  "------------- THIS SHIT IS IN SOME BROKEN STATE -----------------"}'
}

#############################
# Header management
#############################

function printHeader()
{
    echo "||$1|| |"
}

function headerHandle()
{
    local module_type=$1
    shift;
    local header="$@"

    [[ "$type" == "$module_type" ]] && return;
    type=$module_type;

    [[ ! -z "$header" ]] && echo "||${header}|| |" && return

    echo "||${type}|| |"
}


categoriseDeploymentItem()
{
    local entry=$@
    #####
    ##Categorise the changes
    #######
    if [[ "${entry}" =~ .hiera.+ ]]; then
        if [[ "${entry}" =~ .hiera/node.+ ]]; then
            server=$(echo ${entry} | cut -d'/' -f3 | cut -d'|' -f1);
            addToAffectedServer "${server}"
        elif [[ "${entry}" =~ .hiera/os/(.+).yaml ]]; then
            AFFECTED_OS+=("${BASH_REMATCH[1]}")
        fi
        headerHandle "Hiera"
    elif [[ "${entry}" =~ .tests.+ ]]; then
        headerHandle "Tests" "Unit Test Updates"
    elif [[ "${entry}" =~ .modules/.+/spec/.+ ]]; then
        headerHandle "RSpec" "Rspec Unit Test"
    elif [[ "${entry}" =~ .modules/feedprocessor/files/configs/(.+/.+\.xml) ]]; then
        config_path="${BASH_REMATCH[1]}";
        addToAffectedMarket "${config_path%/*}"
        getServerFromFP "${config_path##*/}";
        headerHandle "Feedprocessor";
        getDirectory "${config_path}";
    elif [[ "${entry}" =~ .modules/brokersync/files/([a-z0-9-]+\/.+) ]]; then
        config_path="${BASH_REMATCH[1]}";
        addToAffectedServer "${config_path%/*}";
        headerHandle "Brokersync";
        getDirectory "${config_path}";
    elif [[ "${entry}" =~ .modules/kitchensync.+dataconfigs.+ ]]; then
        headerHandle "DataConfig" "Kitchensync - Data Configs"
    elif [[ "${entry}" =~ .modules/kitchensync.+servers/([a-z0-9-]+/[a-z0-9-]+)\.properties.+ ]]; then
        local config_path="${BASH_REMATCH[1]}"
        addToAffectedServer "${config_path%/*}" "${config_path##*/}";
        headerHandle "KitchensyncServer" "Kitchensync - Server Properties"
        getDirectory ${config_path}
    elif [[ "${entry}" =~ .modules/monitorupload/files/([a-z0-9-]+/.+\.xml) ]]; then
        config_path="${BASH_REMATCH[1]}";
        addToAffectedServer ${config_path%/*}
        headerHandle "Monitorupload"
        getDirectory "${config_path}";
    elif [[ "${entry}" =~ .modules/smarts/files/(.+/.+\.cfg) ]]; then
        local config_path=${BASH_REMATCH[1]}
        addToAffectedMarket ${config_path%/*}
        checkReCacheBenchmark ${config_path}
        headerHandle "MarketConfig" "Smarts"
    elif [[ "${entry}" =~ .modules/smarts/files/(.+)/.+ ]]; then
        local config_path=${BASH_REMATCH[1]}
        addToAffectedMarket ${config_path%/*}
        headerHandle "Smarts"
    elif [[ "${entry}" =~ .modules/feedmonitor.+ ]]; then
        headerHandle "Feedmonitor"
    elif [[ "${entry}" =~ .modules/favpolicy/files/policies/(.+)\.yaml ]]; then
        addToAffectedServer "${BASH_REMATCH[1]}";
        headerHandle "Favpolicy"
    elif [[ "${entry}" =~ .modules/.+/manifests/([_a-z0-9-]+)\.pp ]]; then
        headerHandle "PuppetCode" "Puppet Code"
    elif [[ "${entry}" =~ .modules/alerts/templates/.+ ]]; then
        headerHandle "AlertCron" "Alert Cronjobs"
    elif [[ "${entry}" =~ .modules/.+/templates/.+(erb|epp) ]]; then
        headerHandle "PuppetTemplates" "Puppet Templates"
    elif [[ "${entry}" =~ .modules/([^/]+)/.+ ]]; then
        headerHandle "${BASH_REMATCH[1]^}"
    fi

    if [[ ! " ${COMPONENTS[@]} " =~ " ${type} " ]]; then
        COMPONENTS+=("${type}");
    fi
    ## The Actual File Changes
    echo ${entry};
}

# Check if this is worth doing
git rev-parse --is-inside-work-tree 1>/dev/null 2>/dev/null || (echo -e "${Red}ERROR: Current directory not a git repository${NC}" && exit 2);
git diff-index --quiet --exit-code origin/production && echo -e "${Red}ERROR: No changes on branch ${NC}" && exit 2;

PUPPET_BRANCH=$(git rev-parse --abbrev-ref HEAD)

PASSWORD=""
read -s -p "Please provide password for JIRA query:" PASSWORD

PUPPET_PR_ID="$(getPullRequestID "${PUPPET_BRANCH}" "puppet")"
TEMPLATES_PR_ID="$(getPullRequestID "${PUPPET_BRANCH}" "templates")"



# Create Puppet PR if it doesn't exist
[ -z ${PUPPET_PR_ID} ] || createPullRequest "PUPPET" && PUPPET_PR_ID="$(getPullRequestID "${PUPPET_BRANCH}" "puppet")"

# Create Templates PR if there is a template and the PR doesn't exist
if [[ $(git -C ~/git/templates ls-remote --heads -q) =~ ${PUPPET_BRANCH} ]]; then
    [ -z ${TEMPLATES_PR_ID} ] || createPullRequest "TEMPLATES" && TEMPLATES_PR_ID="$(getPullRequestID "${PUPPET_BRANCH}" "templates")"
fi


echo "----------------------------------------------------------------------------------"

########################################
# Deployment Time/Dependency
########################################
echo "h4. Deployment Time and Dependency"
[[ ! -z ${RECACHE_MARKETS[@]} ]] && echo "*Re-Cache Markets:* ${RECACHE_MARKETS[*]}";
[[ ! -z ${REBENCH_MARKETS[@]} ]] && echo "*Re-Benchmarking required for Markets:* ${REBENCH_MARKETS[*]}";
echo ""

########################################
# Deployment Items
########################################
echo "h4. Deployment Items"
echo "*Branch:* [${PUPPET_BRANCH}|https://bitbucket.dev.smbc.nasdaqomx.com/projects/PUPPET/repos/puppet-ops/commits?until=refs/heads/${PUPPET_BRANCH}]"

[ -z ${PUPPET_PR_ID} ] || echo "*Pull Request:* [${PUPPET_PR_ID}|${PULLREQUEST_URL}/${PUPPET_PR_ID}]"

# This is to check if there is a related template branch
if [[ $(git -C ~/git/templates ls-remote --heads -q) =~ ${PUPPET_BRANCH} ]]; then
    echo "*Template Branch:* [${PUPPET_BRANCH}|https://bitbucket.dev.smbc.nasdaqomx.com/projects/SBMI/repos/templates/commits?until=refs/heads/${PUPPET_BRANCH}]"
    [ -z ${TEMPLATES_PR_ID} ] || echo "*Template Pull Request:* [${TEMPLATES_PR_ID}|${PULLREQUEST_URL}/${TEMPLATES_PR_ID}]"
fi

echo "||Config Names|| |"

for change in $(getAllChanges | sort); do
    categoriseDeploymentItem "$change"
done
echo ""

########################################
# The Important Information
########################################
echo "h4. Important Information"
IFS="|"; echo "*Components:* ${COMPONENTS[*]}";IFS=$' \t\n'
IFS=", ";
[[ ! -z ${AFFECTED_SERVERS[@]} ]] && echo "*Servers:* ${AFFECTED_SERVERS[*]}";
[[ ! -z ${AFFECTED_MARKETS[@]} ]] && echo "*Markets:* ${AFFECTED_MARKETS[*]^^}";
[[ ! -z ${AFFECTED_REGIONS[@]} ]] && echo "*Region(s):* ${AFFECTED_REGIONS[*]}";
[[ ! -z ${AFFECTED_OS[@]} ]] && echo "*Operating System(s):* ${AFFECTED_OS[*]}";
# If any markets need a re-cache or a re-benchmark
[[ ! -z ${RECACHE_MARKETS[@]} ]] && echo "*Re-Caching required for Markets:* ${RECACHE_MARKETS[*]}";
[[ ! -z ${REBENCH_MARKETS[@]} ]] && echo "*Re-Benchmarking required for Markets:* ${REBENCH_MARKETS[*]}";
# Only report directories if there are less than a certain amount - else it becomes a fuckfest
[[ ! -z ${AFFECTED_DIRECTORIES[@]} ]] && [[ ${#AFFECTED_DIRECTORIES[@]} -lt 20 ]] \
    && echo "*Directories:* ${AFFECTED_DIRECTORIES[*]}"
IFS=$' \t\n';
echo ""

########################################
# Pre-Conditions
########################################
echo "h4. Pre-conditions"
echo "* <<e.g. necessary market configs are installed>>"
echo ""

########################################
# Deployment Procedure
########################################
echo "h4. Deployment Procedure:"
if [ -z "${PUPPET_PR_ID}" ]; then
    echo "# Merge puppet branch to production"
else
    echo "# Merge puppet branch to production (#[${PUPPET_PR_ID}|$(getPullRequestURL "PUPPET" "")/${PUPPET_PR_ID}])"
fi
if [ -z "${TEMPLATES_PR_ID}" ]; then
    echo "# Merge template branch to production"
else
    echo "# Merge template branch to production (#[${TEMPLATES_PR_ID}|$(getPullRequestURL "TEMPLATES" "")/${TEMPLATES_PR_ID}])"
fi
echo ""

########################################
# Verification
########################################
echo "h4. Verification - Ops PLEASE complete these off"
for component in ${COMPONENTS[@]}; do
    if [[ $component =~ Favpolicy ]]; then
        echo "| Ensure that the favpolicy file is updated on the server | (/)/(x) |"
    fi
    if [[ $component =~ Feedprocessor ]]; then
        echo "| Ensure that there are no SEVERES in the feedprocessor logs | (/)/(x) |"
        echo "| Ensure that the next trading day track generates succesfully | (/)/(x) |"
    fi
    if [[ $component =~ DataConfig ]]; then
        echo "| Ensure that downstream feedprocessor configs don't kick off historical dates | (/)/(x) |"
        echo "| Ensure that the next trading day files sync succesfully | (/)/(x) |"
    fi
    if [[ $component =~ Monitorupload ]]; then
        echo "| Ensure files copy from source to destination next trade day | (/)/(x) |"
    fi
    if [[ $component =~ PuppetCode ]]; then
        echo "| Ensure there are no errors/issues with the puppet runs| (/)/(x) |"
    fi
    # Extra one just for any occassion to copy
    # or placeholder if none of the components above are matched
done
    echo "| | (/)/(x) |"
echo ""

########################################
# Rollback
########################################
echo "h4. Rollback Procedure"
echo -e "# Revert Puppet branch\nhttps://wiki.dev.smbc.nasdaqomx.com/confluence/display/INFRA/Puppet#Puppet-Rollingbackchanges"
