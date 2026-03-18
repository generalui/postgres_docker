# Linting and Formatting

## Requirements

- [Markdownlint](https://open-vsx.org/extension/DavidAnson/vscode-markdownlint) `DavidAnson.vscode-markdownlint`

  - Markdownlint must be installed as an extension (extension id: `DavidAnson.vscode-markdownlint`) for local markdown linting to work within VS Code or Cursor on save.
  - Or run in directly using [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2).
  - `markdownlint-cli2` is included in the asdf [`.tool-versions`](../.tool-versions) file.
    See <https://github.com/paulo-ferraz-oliveira/asdf-markdownlint-cli2>.

    ```sh
    markdownlint-cli2 '**/*.md'
    ```

- [ShellCheck](https://github.com/koalaman/shellcheck) `timonwong.shellcheck`

  - ShellCheck must be installed as an extension (extension id: `timonwong.shellcheck`) for local shell script linting to work within VS Code or Cursor on save.
  - Or run it directly using the [ShellCheck CLI](https://github.com/koalaman/shellcheck#installing).
  - `shellcheck` is included in the asdf [`.tool-versions`](../.tool-versions) file.

    ```sh
    shellcheck *.sh
    ```

## Configuration

### Markdown

MarkdownLint uses [`.markdownlint-cli2.jsonc`](../..markdownlint-cli2.jsonc) to configure the markdown linting rules and to ignore linting for specific files and paths.
See <https://github.com/DavidAnson/markdownlint-cli2/tree/main?tab=readme-ov-file#markdownlint-cli2jsonc>

### Shell

ShellCheck uses [`.shellcheckrc`](../.shellcheckrc) to configure linting rules.
The following rules are disabled project-wide:

| Rule | Reason |
| --- | --- |
| `SC1091` | Suppresses "not following" warnings for sourced files (e.g. `reset_env_variables.sh`) |
| `SC2153` | Suppresses false-positive variable name misspelling warnings |
| `SC2317` | Suppresses unreachable-command false positives in trap/signal handlers |

`external-sources=true` is also set to allow ShellCheck to follow sourced files when they are available.

See <https://github.com/koalaman/shellcheck/wiki/Checks>

## Continuous Integration

Linting is automatically run in CI/CD via the [Code Quality workflow](../.github/workflows/code-quality.yml) on pull requests to `main`.
For detailed information about the CI linting process, see the [Test Workflow Documentation](../.github/workflows/CODE_QUALITY.md).
