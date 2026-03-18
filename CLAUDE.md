# CLAUDE.md — Postgres/Docker Accelerator

This file provides context for AI assistants (Claude Code and others) working in this repository.

## Project Purpose

This is a **minimal, focused accelerator** for spinning up a local PostgreSQL + pgAdmin development environment using Docker Compose. The scope is intentionally limited to these two services. Do not add additional services (Redis, other databases, etc.) unless explicitly requested.

## Key Files

| File | Purpose |
| --- | --- |
| `start.sh` | Main script: prunes Docker, starts containers, polls for pgAdmin readiness, opens browser |
| `stop.sh` | Stops and removes containers (data in volumes persists) |
| `reset_env_variables.sh` | Unsets all project environment variables so Docker Compose defaults take effect |
| `docker-compose.postgres.yml` | Defines the `postgres` and `pgAdmin` services, volumes, and network |
| `.env` | Local overrides (git-ignored — do not commit) |
| `.env-sample` | Template for `.env` — copy this to get started |
| `.env-none` | Empty stub used when no `.env` file is present |

## Getting Started

```sh
cp .env-sample .env   # optional: customize versions/ports/credentials
./start.sh            # starts containers and opens pgAdmin in the browser
./stop.sh             # stops containers (data persists in Docker volumes)
```

## Environment Variables

All variables have defaults built into `docker-compose.postgres.yml`. Override any of them in `.env` or by exporting them in your shell.

### PostgreSQL

| Variable | Default | Description |
| --- | --- | --- |
| `PG_VERSION` | `18.3` | Postgres image version (Alpine-based) |
| `PG_CONTAINER` | `pg-docker` | Container name |
| `PG_PORT` | `5432` | Host port mapped to Postgres |
| `PG_USER` | `postgres` | Database username |
| `PG_PASS` | `docker` | Database password |

### pgAdmin

| Variable | Default | Description |
| --- | --- | --- |
| `PGA_VERSION` | `latest` | pgAdmin image version |
| `PGA_CONTAINER` | `pg-admin` | Container name |
| `PGA_PORT` | `8010` | Host port for the pgAdmin web UI |
| `PGA_USER` | `mail@mail.com` | pgAdmin login email |
| `PGA_PASS` | `pass` | pgAdmin login password |

### Network

| Variable | Default | Description |
| --- | --- | --- |
| `PG_NETWORK` | `postgres` | Docker network shared by both containers |
| `DOT_ENV_FILE` | `.env` | Path to the env file passed to Docker Compose |

> These defaults are fine for local development. Change credentials before any deployment.

## start.sh Flags

| Flag | Description |
| --- | --- |
| `-b` / `--build` | Rebuild Docker images before starting |
| `-r` / `--reset_env` | Source `reset_env_variables.sh` to unset all env vars before starting |

## Linting

Both shell scripts and Markdown files are linted. Always ensure changes pass lint before committing.

### Shell — ShellCheck

All `.sh` files must pass ShellCheck. The `.shellcheckrc` disables three rules project-wide:

- `SC1091` — not following sourced files (used in `reset_env_variables.sh` sourcing)
- `SC2153` — possible variable name misspelling (false positives in this codebase)
- `SC2317` — unreachable commands (false positive in trap/signal handlers)

Run locally with the ShellCheck VS Code extension (`timonwong.shellcheck`) or the CLI.

### Markdown — markdownlint

Markdown is linted with `markdownlint-cli2`. Config is in `.markdownlint-cli2.jsonc`:

- Max line length: 240
- Allowed inline HTML: `<a>`, `<img>`, `<p>`
- `CLAUDE.md` and `.github/copilot-instructions.md` are excluded from linting

Run manually:

```sh
markdownlint-cli2 '**/*.md'
```

The `markdownlint-cli2` version is pinned in `.tool-versions` (managed with `asdf`).

## Script Conventions

When modifying or adding shell scripts, follow the conventions established in `start.sh`:

- Wrap logic in a named function (e.g., `function start()`) called at the end of the file
- Use lowercase local variables inside functions
- Use the color variables for all output: `blue` (info), `green` (success), `yellow` (warning/action), `red` (error/destructive)
- Always reset color with `${nc}` after colored output
- Use `echo -e` for colored output; use `>&2 echo -e` for warnings and errors
- Nested functions (e.g., helpers, progress, signal handlers) belong inside the outer function
- Scripts must be ShellCheck-compliant (see Linting above)

## Common Tasks

### Changing Postgres or pgAdmin versions

Edit `.env` (or `.env-sample` if updating the template default):

```sh
PG_VERSION=16.2
PGA_VERSION=8.0
```

Then restart with a rebuild: `./start.sh -b`

### Resetting to defaults

```sh
./start.sh -r
```

This unsets all env vars so Docker Compose falls back to its built-in defaults.

### pgAdmin won't open / startup times out

`start.sh` polls `localhost:$PGA_PORT` up to 35 times (1-second intervals). If it times out:

1. Check that Docker Desktop is running
2. Run `docker compose -f docker-compose.postgres.yml logs` to inspect container output
3. Check for port conflicts on `5432` or `8010` (or your custom ports)
4. Try `./start.sh -b` to force a clean rebuild

### Connecting an external app to the Postgres container

Use the Docker network name (default: `postgres`) to connect other containers on the same host. The internal hostname is the container name (default: `pg-docker`), port `5432`.

For host-based connections (e.g., from a local app not in Docker), use `localhost` and `PG_PORT` (default: `5432`).

### Port conflicts

Override the conflicting port in `.env`:

```sh
PG_PORT=5433
PGA_PORT=8011
```
