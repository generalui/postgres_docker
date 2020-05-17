# postgres_docker

Scripts to readily create and run Postgres in docker. Also scripts to build pgAdmin in docker for accessing the Postgres server.

- ## `create_db.sh`

  This creates a docker image for a postgres database. It maps a local directory to the container so that data may persist across container restarts. If the local location doesn't already exist, it creates it. It only creates the container if the docker container is not already running.

  There are default values for the Postgres docker image name, the Postgres data directory path, the port that Postgres uses, the Postgres username, and the Postgres password. These may be overridden by setting the following environment variables:

  - `PG_DOCKER_IMAGE`\
    The Postgres docker image name. (The default is `pg-docker`)

  - `PG_DATA_DIR`\
    The Postgres data directory. (The default is `~/docker/volumes/postgres`)

  - `PG_PORT`\
    The port used by Postgres. (The default is `5432`)

  - `PG_USER`\
    The Postgres username. (The default is `postgres`. This should be fine for development, but PLEASE use best practices and change for any deployment.)

  - `PG_PASS`\
    The Postgres password. (The default is `docker`. This should be fine for development, but PLEASE use best practices and change for any deployment.)

  Even if the environment variables are set, flags may be used to pass arguments to the script that will override the enviroment variables and defaults. The possible flags are:

  - `-i`\
    The docker image name.

  - `-d`\
    The postgres data directory.

  - `-p`\
    The port used by Postgres.

  - `-u`\
    The Postgres username.

  - `-w`\
    The Postgres password.

  Example usage:

  ```bash
  ./create_db.sh -i pg_image_name -d /path/to/data -p 4321 -u username -w secretPass
  ```

- ## `start_pg_admin.sh`

  This creates a docker image for [pgAdmin](https://www.pgadmin.org/). It maps a local directory to the container so that data may persist across container restarts. If the local location doesn't already exist, it creates it. It only creates the container if the docker container is not already running.

  Once pgAdmin is started, it will open in the default browser. pgAdmin allows easy access to the database for examination and verification.

  There are default values for the pgAdmin docker image name, the Postgres docker image name, the port that pgAdmin uses, the alias that connects Postgres (current default alias is "localhost" -> "postgres"), the pgAdmin username, and the pgAdmin password. These may be overridden by setting the following environment variables:

  - `PGA_DOCKER_IMAGE`\
    The pgAdmin docker image name. (The default is `pg-admin`)

  - `PG_DOCKER_IMAGE`\
    The Postgres docker image name. (The default is `pg-docker`)

  - `PGA_DATA_DIR`\
    The pgAdmin data directory. (The default is `~/docker/volumes/pgadmin`)

  - `PG_DOCKER_ALIAS`\
    The alias for Postgres (Postgres is running in its docker on localhost. This tells pgAdmin to alias to localhost). (The default is `postgres`)

  - `PGA_PORT`\
    The port used by pgAdmin. (The default is `8010`)

  - `PGA_USER`\
    The pgAdmin username. (The default is `mail@mail.com`. This should be fine for development, but PLEASE use best practices and change for any deployment.)

  - `PGA_PASS`\
    The pgAdmin password. (The default is `pass`. This should be fine for development, but PLEASE use best practices and change for any deployment.)

  Even if the environment variables are set, flags may be used to pass arguments to the script that will override the enviroment variables and defaults. The possible flags are:

  - `-a`\
    The pgAdmin docker image name.

  - `-g`\
    The pgAdmin data directory.

  - `-i`\
    The Postgres docker image name.

  - `-n`\
    The alias for Postgres (Postgres is running in its docker on localhost. This tells pgAdmin to alias to localhost).

  - `-p`\
    The port used by pgAdmin.

  - `-u`\
    The pgAdmin username.

  - `-w`\
    The pgAdmin password.

  Example usage:

  ```bash
  ./start_pg_admin.sh -a pga_image_name -g /some/path/for/pgadmin/data -i pg_image_name -n postgres -p 4321 -u username -w secretPass
  ```

- ## `start_database_with_pg_admin.sh`

  This is a simple helper script that calls `create_db.sh` and `start_pg_admin.sh` back to back to save keystrokes!

  There are default values for the pgAdmin docker image name, the Postgres docker image name, the port that pgAdmin uses, the alias that connects Postgres (current default alias is "localhost" -> "postgres"), the pgAdmin username, the pgAdmin password, the Postgres data directory path, the port that Postgres uses, the Postgres username, and the Postgres password. These may be overridden by setting the following environment variables (they are the same as are applied to the above scripts directly):

  - `PGA_DOCKER_IMAGE`\
    The pgAdmin docker image name. (The default is `pg-admin`)

  - `PG_DOCKER_IMAGE`\
    The Postgres docker image name. (The default is `pg-docker`)

  - `PG_DOCKER_ALIAS`\
    The alias for Postgres (Postgres is running in its docker on localhost. This tells pgAdmin to alias to localhost). (The default is `postgres`)

  - `PGA_PORT`\
    The port used by pgAdmin. (The default is `8010`)

  - `PGA_USER`\
    The pgAdmin username. (The default is `mail@mail.com`. This should be fine for development, but PLEASE use best practices and change for any deployment.)

  - `PGA_PASS`\
    The pgAdmin password. (The default is `pass`. This should be fine for development, but PLEASE use best practices and change for any deployment.)

  - `PG_DATA_DIR`\
    The Postgres data directory. (The default is `~/docker/volumes/postgres`)

  - `PGADATA_DIR`\
    The pgAdmin data directory. (The default is `~/docker/volumes/pgadmin`)

  - `PG_PORT`\
    The port used by Postgres. (The default is `5432`)

  - `PG_USER`\
    The Postgres username. (The default is `postgres`. This should be fine for development, but PLEASE use best practices and change for any deployment.)

  - `PG_PASS`\
    The Postgres password. (The default is `docker`. This should be fine for development, but PLEASE use best practices and change for any deployment.)

  Even if the environment variables are set, flags may be used to pass arguments to the script that will override the enviroment variables and defaults. The possible flags are:

  - `-a`\
    The pgAdmin docker image name.

  - `-d`\
    The postgres data directory.

  - `-e`\
    The pgAdmin username.

  - `-g`\
    The pgAdmin data directory.

  - `-i`\
    The Postgres docker image name.

  - `-n`\
    The alias for Postgres (Postgres is running in its docker on localhost. This tells pgAdmin to alias to localhost).

  - `-p`\
    The port used by Postgres.

  - `-r`\
    The port used by pgAdmin.

  - `-s`\
    The pgAdmin password.

  - `-u`\
    The Postgres username.

  - `-w`\
    The Postgres password.

  Example usage:

  ```bash
  ./start_database_with_pg_admin.sh -a pga_image_name -d /some/path/for/postgres/data -e pga_username -g /some/path/for/pgadmin/data -i pg_image_name -n postgres -p 4321 -r 4334 -s pga_SecretPass -u pg_username -w pgSecretPass
  ```
