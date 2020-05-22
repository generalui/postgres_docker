#!/bin/bash

# Set the environment variables.
source ./set_env_variables.sh

# Stop the docker container.
docker-compose -f docker-compose.postgres.yml down