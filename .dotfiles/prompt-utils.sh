#-------------------------------------------------------------
# Shell Prompt:
#-------------------------------------------------------------
# Current Format: [TIME USER@HOST PWD] >
# TIME:
#    GREEN     == machine load is low
#    Orange    == machine load is medium
#    RED       == machine load is high
#    ALERT     == machine load is very high
# USER:
#    CYAN      == normal user
#    Orange    == SU to user
#    RED       == root
# HOST:
#    CYAN      == local session
#    GREEN     == secured remote connection (via ssh)
#    RED       == unsecured remote connection
# PWD:
#    GREEN     == more than 10% free disk space
#    Orange    == less than 10% free disk space
#    ALERT     == less than 5% free disk space
#    RED       == current user does not have write privileges
#    CYAN      == current filesystem is size zero (like /proc)
# ?:
#    White     == no background or suspended jobs in this shell
#    CYAN      == at least one background job in this shell
#    Orange    == at least one suspended job in this shell
#
#    Command is added to the history file each time you hit enter,
#    so it's available to all shells (using 'history -a').


# Test connection type:
if [ -n "${SSH_CONNECTION}" ]; then
    CNX=${GREEN}        # Connected on remote machine, via ssh (good).
elif [[ "${DISPLAY%%:0*}" != "" ]]; then
    CNX=${ALERT}        # Connected on remote machine, not via ssh (bad).
else
    CNX=${CYAN}        # Connected on local machine.
fi

# Test user type:
if [[ ${USER} == "root" ]]; then
    SU=${RED}           # User is root.
elif [[ ${USER} != $(logname) ]]; then
    SU=${RED_BRIGHT}          # User is not login user.
else
    SU=${CYAN}         # User is normal (well ... most of us are).
fi

NCPU=$(grep -c 'processor' /proc/cpuinfo)    # Number of CPUs
SLOAD=$(( 100*${NCPU} ))        # Small load
MLOAD=$(( 200*${NCPU} ))        # Medium load
XLOAD=$(( 400*${NCPU} ))        # Xlarge load

# Returns system load as percentage, i.e., '40' rather than '0.40)'.
function load()
{
    local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
    # System load of the current host.
    echo $((10#$SYSLOAD))       # Convert to decimal.
}

# Returns a color indicating system load.
function load_colour()
{
    local SYSLOAD=$(load)
    if [ ${SYSLOAD} -gt ${XLOAD} ]; then
        echo -en ${RED_BRIGHT} ${WHITE_BRIGHT}
    elif [ ${SYSLOAD} -gt ${MLOAD} ]; then
        echo -en ${RED} ${WHITE}
    elif [ ${SYSLOAD} -gt ${SLOAD} ]; then
        echo -en ${BLACK} ${RED}
    else
        echo -en ${BLACK} ${GREEN}
    fi
}
# Returns a color according to free disk space in $PWD.
function disk_color()
{
    if [ ! -w "${PWD}" ] ; then
        # No 'write' privilege in the current directory.
        :
    elif [ -s "${PWD}" ] ; then
        local used=$(command df -P "$PWD" |
                   awk 'END {print $5} {sub(/%/,"")}')
        if [ ${used} -gt 95 ]; then
            echo -en ${RED_BRIGHT} ${WHITE_BRIGHT}           # Disk almost full (>95%).
        elif [ ${used} -gt 90 ]; then
            echo -en ${RED}            # Free disk space almost gone.
        else
            echo -en ${WHITE_BRIGHT}           # Free disk space is ok.
        fi
    else
        echo -en ${CYAN}
        # Current directory is size '0' (like /proc, /sys etc).
    fi
}

# Returns a color according to running/suspended jobs.
function job_color()
{
    if [ $(jobs -s | wc -l) -gt "0" ]; then
        echo -en ${RED_BRIGHT}
    elif [ $(jobs -r | wc -l) -gt "0" ] ; then
        echo -en ${CYAN_BRIGHT}
    fi
}

# Returns git directory and colour depending on if git branch is dirty or not
function git_color()
{
    export GIT_PS1_SHOWCOLORHINTS=1;
    export GIT_PS1_SHOWDIRTYSTATE=1
    if output=$(git status --porcelain 2>/dev/null) && [ -z "$output" ]; then
        echo -en "$(__git_ps1)"
    else
        echo -en "${RED_BRIGHT}$(__git_ps1)${NC}"
    fi
}
