#!/bin/bash

YELLOW="\033[1;33m"
GREEN="\033[0;32m"
# No Color
NC='\033[0m'

# The local project directory (assumes this file is stll in a child folder of the project).
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd ../ && pwd )"
>&2 echo -e "${GREEN}Current dir - ${DIR}${NC}"

# If environment variables are set, use them. If not, use the defaults.
db_data_dir="${PG_DATA_DIR:-$HOME/docker/volumes/postgres}"
docker_image="${PG_DOCKER_IMAGE:-pg-docker}"
db_port="${PG_PORT:-5432}"
db_user="${PG_USER:-postgres}"
db_pw="${PG_PASS:-docker}"

# If flags are passed, use them to override the environment variables or defaults.
while getopts d:i:p:u:w: flag; do
    case ${flag} in
        d) db_data_dir=${OPTARG};;
        i) docker_image=${OPTARG};;
        p) db_port=${OPTARG};;
        u) db_user=${OPTARG};;
        w) db_pw=${OPTARG};;
    esac
done

>&2 echo -e "${GREEN}Postgres docker image - ${docker_image}${NC}"
>&2 echo -e "${GREEN}Postgres data dir - ${db_data_dir}${NC}"
>&2 echo -e "${GREEN}Postgres port - ${db_port}${NC}"

If $db_data_dir doesn't exist create it.
if [ ! -d "${db_data_dir}" ]; then
    >&2 echo -e "${GREEN}Creating '${db_data_dir}' for data.${NC}"
    mkdir -p ${db_data_dir}
fi

# Ensure the docker image with the supported version of PostgreSQL has been downloaded.
docker pull postgres:11.5

# Ensure the docker container isn't already in the docker processes.
if [ ! "$(docker ps -q -f name=$docker_image)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=$docker_image)" ]; then
        # Cleanup
        docker rm $docker_image
    fi
    # Run the container
    docker run --rm --name $docker_image -e POSTGRES_PASSWORD=$db_pw -d -p $db_port:$db_port -v /$db_data_dir:/var/lib/postgresql/data postgres:11.5
fi

>&2 echo -e "${YELLOW}Postgres: starting - please be patient${NC}"
until docker exec $docker_image psql -q -U $db_user  2> /dev/null; do
    sleep 1
done

>&2 echo -e "${GREEN}Postgres: up${NC}"
