# Linting and Formatting

## Requirements

- [Markdownlint](https://open-vsx.org/extension/DavidAnson/vscode-markdownlint) `DavidAnson.vscode-markdownlint`

  - Markdownlint must be installed as an extension (extension id: `DavidAnson.vscode-markdownlint`) for local markdown linting to work within VS Code or Cursor on save.
  - Or run in directly using [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2).
  - `markdownlint-cli2` is included in the asdf tool versions file.
    See <https://github.com/paulo-ferraz-oliveira/asdf-markdownlint-cli2>.

    ```sh
    markdownlint-cli2 '**/*.md'
    ```

## Configuration

MarkdownLint uses [`.markdownlint-cli2.jsonc`](../..markdownlint-cli2.jsonc) to configure the markdown linting rules and to ignore linting for specific files and paths.
See <https://github.com/DavidAnson/markdownlint-cli2/tree/main?tab=readme-ov-file#markdownlint-cli2jsonc>

## Continuous Integration

Linting is automatically run in CI/CD via the [Code Quality workflow](../.github/workflows/code-quality.yml) on pull requests to `main`.
For detailed information about the CI linting process, see the [Test Workflow Documentation](../.github/workflows/CODE_QUALITY.md).
