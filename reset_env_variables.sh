#!/bin/bash

# Defined some useful colors for echo outputs.
# Use Green for a successful action.
GREEN="\033[0;32m"
# No Color (used to stop or reset a color).
NC='\033[0m'

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

echo -e "${GREEN}* Environment variables unset.${NC}"
