# postgres_docker

A script to readily create and run [Postgres](https://www.postgresql.org/) in [Docker](docker.com). This also builds [pgAdmin](pgadmin.org) in docker for accessing the Postgres server.

## Requirments

  - [Docker Desktop](https://www.docker.com/products/docker-desktop)

## Environment variables

  There are default values for the **Postgres** docker container name, the port that Postgres uses, the Postgres username, and the Postgres password. These may be overridden by setting the following environment variables:

  - `PG_VERSION`\
    The version of Postgres. (The default is `12.3`)

  - `PG_CONTAINER`\
    The Postgres docker container name. (The default is `pg-docker`)

  - `PG_PORT`\
    The port used by Postgres. (The default is `5432`)

  - `PG_USER`\
    The Postgres username. (The default is `postgres`. This should be fine for development, but PLEASE use best practices and change for any deployment.)

  - `PG_PASS`\
    The Postgres password. (The default is `docker`. This should be fine for development, but PLEASE use best practices and change for any deployment.)

  There are default values for the **pgAdmin** docker container, the port that pgAdmin uses, the pgAdmin username, and the pgAdmin password. These may be overridden by setting the following environment variables:

  - `PGA_CONTAINER`\
    The pgAdmin docker image name. (The default is `pg-admin`)

  - `PGA_PORT`\
    The port used by pgAdmin. (The default is `8010`)

  - `PGA_USER`\
    The pgAdmin username. (The default is `mail@mail.com`. This should be fine for development, but PLEASE use best practices and change for any deployment.)

  - `PGA_PASS`\
    The pgAdmin password. (The default is `pass`. This should be fine for development, but PLEASE use best practices and change for any deployment.)

  Once created these containers may be accessed via a network. The default network i called `postgres`. This may be overridden by setting the following environment variable:

  - `PG_NETWORK`\
    The network the containers can be reached on. (The default is `postgres`)

  A `.env` file may be placed in the same folder as this script to set environment variables. An example of the content of the `.env` may look like:

  ```.env
  PG_NETWORK=my_different_network

  PGA_PORT=4242
  ```

## `start.sh`

  This creates docker containers for a postgres database and pgAdmin. The data persists across container restarts, it is stored in Docker.

  Running this script without overridding any variables ([see above](#environment-variables)) should work just fine for a development environment.

  Example usage:

  To start the containers, simply call:

  ```bash
  ./start.sh
  ```

  If a rebuild is desired, pass the "build" flag, `--build` or simply `-b`:

  ```bash
  ./start.sh --build
  ```

  or simply

  ```bash
  ./start.sh -b
  ```

## `stop.sh`

  This script will stop the containers. They can be restarted with the `start.sh` script and the data will persist.

  Example usage:

  ```bash
  ./stop.sh
  ```
