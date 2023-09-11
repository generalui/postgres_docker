#!/bin/bash

# Defined some useful colors for echo outputs.
# Use BLUE for informational.
BLUE="\033[1;34m"
# Use Green for a successful action.
GREEN="\033[0;32m"
# Use YELLOW for warning informational and initiating actions.
YELLOW="\033[1;33m"
# Use RED for error informational and extreme actions.
RED="\033[1;31m"
# No Color (used to stop or reset a color).
NC='\033[0m'

# The project directory.
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo -e "${BLUE}Current project dir - ${PROJECT_DIR}${NC}"

# By default, set these variables to false.
build=false
reset=false

# Checks if a specific param has been passed to the script.
has_param() {
    local term="$1"
    shift
    for arg; do
        if [[ $arg == "$term" ]]; then
            return 0
        fi
    done
    return 1
}

# If the `-b or --build` flag is passed, set build to true.
if has_param '-b' "$@" || has_param '--build' "$@"
then
    echo -e "${BLUE}Build requested${NC}"
    build=true
fi

# If the `-r or --reset_env` flag is passed, set reset to true.
if has_param '-r' "$@" || has_param '--reset_env' "$@"
then
    echo -e "${BLUE}Reset environement variables requested${NC}"
    reset=true
fi

if [ "${reset}" = true ]
then
    # Reset the environment variables.
    source ./reset_env_variables.sh
fi

docker system prune --force

if [ "${build}" = true ]
then
    # Build and start the container.
    docker compose -f docker-compose.postgres.yml up -d --build
else
    # Start the container.
    docker compose -f docker-compose.postgres.yml up -d
fi

# If CTRL+C is pressed, ensure the progress background PID is stopped too.
function ctrl_c() {
    >&2 echo -e "${RED} => CTRL+C received, exiting${NC}"
    # Stop the progress indicator.
    kill $progress_pid
    wait $progress_pid 2>/dev/null
    # Cursor visible again.
    tput cnorm
    exit
}

function open_url() {
    [[ -x $BROWSER ]] && exec "$BROWSER" "$url"
    path=$(which xdg-open || which gnome-open || which open || which start) && exec "$path" "$url"
    >&2 echo -e "${YELLOW}Can't find the browser.${NC}"
}

# Creates a animated progress (a cursor growing taller and shorter)
function progress() {
    # Make sure to use non-unicode character type locale. (That way it works for any locale as long as the font supports the characters).
    local LC_CTYPE=C
    local char="▁▂▃▄▅▆▇█▇▆▅▄▃▂▁"
    local charwidth=3
    local i=0
    # Cursor invisible
    tput civis
    while sleep 0.1; do
        i=$(((i + $charwidth) % ${#char}))
        printf "%s" "${char:$i:$charwidth}"
        echo -en "\033[1D"
    done
}

# Defaults
PGA_PORT='8010'

DOT_ENV=.env
DOT_ENV_FILE=${PROJECT_DIR}/${DOT_ENV}
# Set variables from the .env file
function set_variables() {
    if [ -f "${DOT_ENV_FILE}" ]
    then
        local VAR=$(grep 'PGA_PORT' "$DOT_ENV_FILE" | xargs)
        IFS="=" read -ra VAR <<< "$VAR"
        PGA_PORT=${VAR[1]:=$PGA_PORT}
    else
        DOT_ENV_FILE=${PROJECT_DIR}/.env-none
        >&2 echo -e "${YELLOW}Not using a ${DOT_ENV} file${NC}"
    fi
}

# Pings the server up to 35 times to see if it is available yet.
function check_status() {
    local max_num_tries=35
    local status_code=$(curl --write-out %{http_code} --silent --output /dev/null localhost:${PGA_PORT})
    if [[ ${iterator} -lt ${max_num_tries} && ${status_code} -eq 200 || ${status_code} -eq 302 ]]
    then
        # Stop the progress indicator.
        kill $progress_pid
        wait $progress_pid 2>/dev/null
        # Cursor visible again.
        tput cnorm
        echo -e "${GREEN}pgAdmin is Up at localhost:${PGA_PORT}${NC}"
        url=http://localhost:${PGA_PORT}
        open_url
    elif [[ ${iterator} -eq ${max_num_tries} ]]
    then
        # Stop the progress indicator.
        kill $progress_pid
        wait $progress_pid 2>/dev/null
        # Cursor visible again.
        tput cnorm
        >&2 echo -e "${YELLOW}Did not work. Perhaps the server is taking a long time to start?${NC}"
    else
        echo -en "${chars:$iterator:1}" "\r"
        sleep 1
        ((iterator++))
        check_status
    fi
}

# Run set_variables
set_variables
# Start the progress indicator.
echo -e "${YELLOW}* Checking if pgAdmin is Up at localhost:${PGA_PORT}${NC} ..."
progress &
# Set the progress indicator's PID to a variable.
progress_pid=$!
# This is a trap for CTRL+C
trap ctrl_c INT
# Check the status
iterator=0
check_status
