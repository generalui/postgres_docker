# Code Quality Workflow

## What it does

Lints Markdown files and shell scripts on every pull request to `main`. Also runnable manually via `workflow_dispatch`.

## When it runs

- Pull requests to `main` (opened, reopened, or synchronized) when any of the following paths change:
  - `**/*.md`
  - `**/.markdownlint*`
  - `*.sh`
  - `.github/workflows/code-quality.yml`
- Manual trigger via the GitHub Actions UI

## Markdown linting

**Tool:** [`DavidAnson/markdownlint-cli2-action`](https://github.com/DavidAnson/markdownlint-cli2-action)

**Config file:** `.markdownlint-cli2.jsonc` (max line length 240, allowed inline HTML, excludes `CLAUDE.md` and `.github/copilot-instructions.md`)

**Run locally:**

```sh
markdownlint-cli2 '**/*.md'
```

## Shell script linting

**Tool:** [`reviewdog/action-shellcheck`](https://github.com/reviewdog/action-shellcheck) — posts inline PR review comments via `github-pr-review` reporter.

**Run locally:**

```sh
shellcheck start.sh stop.sh reset_env_variables.sh
```

**`.shellcheckrc` suppressions** (project-wide):

| Rule | Reason |
| --- | --- |
| `SC1091` | Not following sourced files (`reset_env_variables.sh`) |
| `SC2153` | False positives on variable name misspelling |
| `SC2317` | False positive on unreachable commands in trap/signal handlers |

## Adding new checks

1. Add a "Get changed files" step using `tj-actions/changed-files@v47` scoped to the relevant paths.
2. Add a "Should lint X" step that writes the `any_changed` output to `$GITHUB_OUTPUT`.
3. Add the lint step gated on `if: steps.should_lint_x.outputs.run == 'true'`.
4. Update the paths filter under `on.pull_request.paths` to include the new file patterns.
