#!/bin/bash

YELLOW="\033[1;33m"
GREEN="\033[0;32m"
# No Color
NC='\033[0m'

# If environment variables are set, use them. If not, use the defaults.
pga_docker_image="${PGA_DOCKER_IMAGE:-pg-admin}"
pg_docker_image="${PG_DOCKER_IMAGE:-pg-docker}"
pga_data_dir="${PGA_DATA_DIR:-$HOME/docker/volumes/pgadmin}"
pga_port="${PGA_PORT:-8010}"
pg_docker_alias="${PG_DOCKER_ALIAS:-postgres}"
pga_user="${PGA_USER:-pass}"
pga_pw="${PGA_PASS:-mail@mail.com}"

# If flags are passed, use them to override the environment variables or defaults.
while getopts a:g:i:p:n:u:w: flag; do
    case ${flag} in
        a) pga_docker_image=${OPTARG};;
        g) pga_data_dir=${OPTARG};;
        i) pg_docker_image=${OPTARG};;
        p) pga_port=${OPTARG};;
        n) pg_docker_alias=${OPTARG};;
        u) pga_user=${OPTARG};;
        w) pga_pw=${OPTARG};;
    esac
done

>&2 echo -e "${GREEN}pgAdmin docker image - ${pga_docker_image}${NC}"
>&2 echo -e "${GREEN}Postgres docker image - ${pg_docker_image}${NC}"
>&2 echo -e "${GREEN}Postgres docker alias - ${pg_docker_alias}${NC}"
>&2 echo -e "${GREEN}pgAdmin port - ${pga_port}${NC}"

# If $pga_data_dir doesn't exist create it.
if [ ! -d "${pga_data_dir}" ]; then
    >&2 echo -e "${GREEN}Creating '${pga_data_dir}' for pgAdmin data to persist.${NC}"
    mkdir -p ${pga_data_dir}
fi
>&2 echo -e "${GREEN}pgAdmin data directory - ${pga_data_dir}${NC}"

# Ensure the docker image with the supported version of PostgreSQL has been downloaded.
docker pull dpage/pgadmin4

# Ensure the docker container isn't already in the docker processes.
if [ ! "$(docker ps -q -f name=${pga_docker_image})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${pga_docker_image})" ]; then
        # Cleanup
        docker rm ${pga_docker_image}
    fi
    # Run the container
    docker run --rm --name ${pga_docker_image} -e PGADMIN_DEFAULT_EMAIL=${pga_user} -e PGADMIN_DEFAULT_PASSWORD=${pga_pw} -d -p ${pga_port}:80 --link ${pg_docker_image}:${pg_docker_alias} -v /${pg_data_dir}:/var/lib/pgadmin dpage/pgadmin4
fi
>&2 echo -e "${GREEN}pgAdmin docker container (${pga_docker_image}) running.${NC}"

check_status() {
    status_code=$(curl --write-out %{http_code} --silent --output /dev/null localhost:${pga_port})
    if [[ ${iterator} -lt 15 && ${status_code} -eq 200 || ${status_code} -eq 302 ]]
    then
        >&2 echo -e "${GREEN}pgAdmin is Up at localhost:${pga_port}${NC}"
        open http://localhost:${pga_port}
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
