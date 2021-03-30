#!/bin/bash

# Defined some useful colors for echo outputs.
# Use Green for a successful action.
GREEN="\033[0;32m"
# No Color (used to stop or reset a color).
NC='\033[0m'

# The project directory.
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Unset any previously set environment variables.
unset DOT_ENV_FILE
unset PG_VERSION
unset PG_CONTAINER
unset PG_NETWORK
unset PGA_CONTAINER
unset PG_USER
unset PGA_USER
unset PG_PASS
unset PGA_PASS
unset PG_PORT
unset PGA_PORT

>&2 echo -e "${GREEN}* Environment variables unset.${NC}"

# Set the environment variables.
source ${PROJECT_DIR}/set_env_variables.sh