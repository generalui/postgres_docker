#!/bin/bash

function reset_env_variables(){
  # Defined some useful colors for echo outputs.
  # Use Green for a successful action.
  green="\033[0;32m"
  # No Color (used to stop or reset a color).
  nc='\033[0m'

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

  echo -e "${green}* Environment variables unset.${nc}"
}

reset_env_variables
