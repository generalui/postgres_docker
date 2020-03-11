#!/bin/bash

# If environment variables are set, use them. If not, use the defaults.
pga_docker_image="${PGA_DOCKER_IMAGE:-pg-admin}"
pg_data_dir="${PG_DATA_DIR:-$HOME/docker/volumes/postgres}"
pga_user="${PGA_USER:-mail@mail.com}"
pg_docker_image="${PG_DOCKER_IMAGE:-pg-docker}"
pg_docker_alias="${PG_DOCKER_ALIAS:-postgres}"
pg_port="${PG_PORT:-5432}"
pga_port="${PGA_PORT:-8010}"
pga_pw="${PGA_PASS:-pass}"
pg_user="${PG_USER:-postgres}"
pg_pw="${PG_PASS:-docker}"

# If flags are passed, use them to override the environment variables or defaults.
while getopts a:d:e:i:n:p:r:s:u:w: flag; do
    case ${flag} in
        a) pga_docker_image=${OPTARG};;
        d) pg_data_dir=${OPTARG};;
        e) pga_user=${OPTARG};;
        i) pg_docker_image=${OPTARG};;
        n) pg_docker_alias=${OPTARG};;
        p) pg_port=${OPTARG};;
        r) pga_port=${OPTARG};;
        s) pga_pw=${OPTARG};;
        u) pg_user=${OPTARG};;
        w) pg_pw=${OPTARG};;
    esac
done

# Start the PostgreSQL server
./create_db.sh -i ${pg_docker_image} -d ${pg_data_dir} -p ${pg_port} -u ${pg_user} -w ${pg_pw}

# Start the pgAdmin container
./start_pg_admin.sh -a ${pga_docker_image} -i ${pg_docker_image} -n ${pg_docker_alias} -p ${pga_port} -u ${pga_user} -w ${pga_pw}