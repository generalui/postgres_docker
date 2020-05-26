#!/bin/bash

# Set the environment variables.
source ./set_env_variables.sh

build=false

# If the `-b` flag is passed, set build to true.
while getopts b: flag; do
    case ${flag} in
        b) build=true;;
    esac
done

if [ "${build}" = true ]
then
    # Build and start the container.
    docker-compose -f docker-compose.postgres.yml up -d --build
else
    # Start the container.
    docker-compose -f docker-compose.postgres.yml up -d
fi

check_status() {
    status_code=$(curl --write-out %{http_code} --silent --output /dev/null localhost:${PGA_PORT})
    if [[ ${iterator} -lt 15 && ${status_code} -eq 200 || ${status_code} -eq 302 ]]
    then
        >&2 echo -e "${GREEN}pgAdmin is Up at localhost:${PGA_PORT}${NC}"
        open http://localhost:${PGA_PORT}
    elif [[ ${iterator} -eq 15 ]]
    then
        >&2 echo -e "${YELLOW}Did not work :(${NC}"
    else
        sleep 1
        ((iterator++))
        check_status
    fi
}

>&2 echo -e "${GREEN}Starting pgAdmin${NC}"

iterator=0
check_status