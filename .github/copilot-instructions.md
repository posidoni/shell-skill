# GitHub Copilot instructions

This repository teaches safe, correct shell. When you suggest or edit code here,
follow these rules (the full rationale is in
[`reference/shell-standards.md`](../reference/shell-standards.md) and the skills
under [`skills/`](../skills/)).

## Bash

- Begin scripts with `set -euo pipefail`.
- Quote every expansion: `"$var"`, `"$(cmd)"`. Reference optional vars as
  `"${VAR:-}"` so `set -u` does not abort.
- Use `[[ ... ]]`, not `[ ... ]`; `$(...)`, not backticks; `read -r`, not bare
  `read`.
- Declare `local` first, then assign, so a failing command substitution is not
  masked.
- Use arrays for argument lists and expand them quoted: `"${arr[@]}"`.
- Clean up with `trap '...' EXIT`; `return` from helpers, reserve `exit` for
  `main`.

## Examples

- `*.good.sh` must run to exit 0 with no arguments and pass
  `shellcheck --severity=warning` and `shfmt`.
- `*.bad.sh` must be safe to run and carry an `# expect-shellcheck:` directive.
- Nushell `*.nu` must pass `nu --ide-check`.
- Tracked YAML-like files (`*.yml`, `*.yaml`, `*.cff`) must start with a
  `yaml-language-server` JSON Schema modeline.

## Verification

Run `task ci` and `task hooks` before proposing a change; never introduce code
that fails them. Use Conventional Commits, and never add personal data or
secrets.
