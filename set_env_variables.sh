#!/bin/bash

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
# No Color
NC='\033[0m'

# The project directory.
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
>&2 echo -e "${GREEN}Current project dir - ${PROJECT_DIR}${NC}"

# .env loading in the shell
DOT_ENV_FILE=${PROJECT_DIR}/.env
dotenv() {
    if [ -f "${DOT_ENV_FILE}" ]
    then
        set -a
        [ -f ${DOT_ENV_FILE} ] && . ${DOT_ENV_FILE}
        set +a
    else
        >&2 echo -e "${YELLOW}No .env file found${NC}"
    fi
}
# Run dotenv
dotenv

# If environment variables are set, use them. If not, use the defaults.
export PG_NETWORK=${PG_NETWORK:-postgres}
export PG_CONTAINER=${PG_CONTAINER:-pg-docker}
export PGA_CONTAINER=${PGA_CONTAINER:-pg-admin}
export PG_USER=${PG_USER:-postgres}
export PGA_USER=${PGA_USER:-mail@mail.com}
export PG_PASS=${PG_PASS:-docker}
export PGA_PASS=${PGA_PASS:-pass}
export PG_PORT=${PG_PORT:-5432}
export PGA_PORT=${PGA_PORT:-8010}
