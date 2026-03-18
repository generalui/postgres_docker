#!/bin/bash

function start() {
    # Defined some useful colors for echo outputs.
    # Use blue for informational.
    blue="\033[1;34m"
    # Use Green for a successful action.
    green="\033[0;32m"
    # Use yellow for warning informational and initiating actions.
    yellow="\033[1;33m"
    # Use red for error informational and extreme actions.
    red="\033[1;31m"
    # No Color (used to stop or reset a color).
    nc='\033[0m'

    # The project directory.
    project_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    echo -e "${blue}Current project dir - ${project_dir}${nc}"

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
        echo -e "${blue}Build requested${nc}"
        build=true
    fi

    # If the `-r or --reset_env` flag is passed, set reset to true.
    if has_param '-r' "$@" || has_param '--reset_env' "$@"
    then
        echo -e "${blue}Reset environment variables requested${nc}"
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
        >&2 echo -e "${red} => CTRL+C received, exiting${nc}"
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
        >&2 echo -e "${yellow}Can't find the browser.${nc}"
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
    pga_port='8010'

    dot_env=.env
    dot_env_file=${project_dir}/${dot_env}
    # Set variables from the .env file
    function set_variables() {
        if [ -f "${dot_env_file}" ]
        then
            local var
            var=$(grep 'pga_port' "$dot_env_file" | xargs)
            IFS="=" read -ra VAR <<< "$var"
            pga_port=${var[1]:=$pga_port}
        else
            dot_env_file=${project_dir}/.env-none
            >&2 echo -e "${yellow}Not using a ${dot_env} file${nc}"
        fi
    }

    # Pings the server up to 35 times to see if it is available yet.
    function check_status() {
        local max_num_tries=35
        local status_code
        status_code=$(curl --write-out %{http_code} --silent --output /dev/null localhost:"${pga_port}")
        if [[ ${iterator} -lt ${max_num_tries} && ${status_code} -eq 200 || ${status_code} -eq 302 ]]
        then
            # Stop the progress indicator.
            kill $progress_pid
            wait $progress_pid 2>/dev/null
            # Cursor visible again.
            tput cnorm
            echo -e "${green}pgAdmin is Up at localhost:${pga_port}${nc}"
            url=http://localhost:${pga_port}
            open_url
        elif [[ ${iterator} -eq ${max_num_tries} ]]
        then
            # Stop the progress indicator.
            kill $progress_pid
            wait $progress_pid 2>/dev/null
            # Cursor visible again.
            tput cnorm
            >&2 echo -e "${yellow}Did not work. Perhaps the server is taking a long time to start?${nc}"
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
    echo -e "${yellow}* Checking if pgAdmin is Up at localhost:${pga_port}${nc} ..."
    progress &
    # Set the progress indicator's PID to a variable.
    progress_pid=$!
    # This is a trap for CTRL+C
    trap ctrl_c INT
    # Check the status
    iterator=0
    check_status
}

start "$@"
