#!/bin/bash

# Defined some useful colors for echo outputs.
# Use BLUE for informational.
BLUE="\033[1;34m"
# Use Green for a successful action.
GREEN="\033[0;32m"
# Use YELLOW for warning informational and initiating actions.
YELLOW="\033[1;33m"
# No Color (used to stop or reset a color).
NC='\033[0m'

# The project directory.
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
>&2 echo -e "${BLUE}Current project dir - ${PROJECT_DIR}${NC}"

# .env loading in the shell
DOT_ENV=.env
DOT_ENV_FILE=${PROJECT_DIR}/${DOT_ENV}
function dotenv() {
    if [ -f "${DOT_ENV_FILE}" ]
    then
        set -a
        [ -f ${DOT_ENV_FILE} ] && . ${DOT_ENV_FILE}
        set +a
        >&2 echo -e "${GREEN}* Override environment variables set from the ${DOT_ENV} file.${NC}"
        >&2 echo -e "${GREEN}* DOT_ENV_FILE set to ${DOT_ENV_FILE}${NC}"
    else
        DOT_ENV_FILE=${PROJECT_DIR}/.env-none
        >&2 echo -e "${YELLOW}Not using a ${DOT_ENV} file${NC}"
    fi
}
# Run dotenv
dotenv

# If environment variables are set, use them. If not, use the defaults.
# Only need defaults for `DOT_ENV_FILE` and `FLASK_RUN_PORT` as they are used in the scripts.
# All other defaults are set in the `docker-compose.yml` file.
export DOT_ENV_FILE=${DOT_ENV_FILE:-}
export PG_VERSION=${PG_VERSION:-12.4}
export PG_CONTAINER=${PG_CONTAINER:-pg-docker}
export PG_NETWORK=${PG_NETWORK:-postgres}
export PGA_CONTAINER=${PGA_CONTAINER:-pg-admin}
export PG_USER=${PG_USER:-postgres}
export PGA_USER=${PGA_USER:-mail@mail.com}
export PG_PASS=${PG_PASS:-docker}
export PGA_PASS=${PGA_PASS:-pass}
export PG_PORT=${PG_PORT:-5432}
export PGA_PORT=${PGA_PORT:-8010}
