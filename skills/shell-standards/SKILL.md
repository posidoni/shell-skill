---
name: shell-standards
description: >-
  Baseline rules for safe, correct Bash — strict mode, quoting, [[ ]] over [ ],
  $(...) over backticks, declare/assign separation, arrays, return-vs-exit, and
  trap-based cleanup. Use when writing, reviewing, or debugging any Bash script,
  or when deciding how to handle quoting, word-splitting, exit codes, or cleanup.
---

# Shell standards

The non-negotiable baseline for writing Bash that does not silently corrupt data
or hide failures. Every rule is explained in depth, with citations, in
[`reference/shell-standards.md`](../../reference/shell-standards.md); the rules
that carry a ShellCheck code also have a runnable good/bad pair in
[`examples/standards/`](../../examples/standards/).

## Rules at a glance

| # | Rule | Why | Enforced by |
|---|------|-----|-------------|
| 1 | `set -euo pipefail` at the top | Fail fast; unset vars and broken pipes become errors | style guide |
| 2 | Quote every expansion: `"$var"`, `"$(cmd)"` | Prevents word-splitting and globbing | `SC2086` |
| 3 | `read -r`, never bare `read` | Bare `read` mangles backslashes | `SC2162` |
| 4 | Declare `local`, then assign | `local x="$(cmd)"` hides the command's exit status | `SC2155` |
| 5 | Arrays for lists; expand `"${arr[@]}"` | A string can't hold an element with spaces | `SC2206` |
| 6 | `[[ ... ]]`, not `[ ... ]` | `[[ ]]` doesn't split or glob its operands | `SC2292` |
| 7 | `return` from helpers, `exit` only in `main` | `exit` kills the caller's shell when sourced | style guide |
| 8 | `trap '...' EXIT` for cleanup | Releases temp files on every exit path | style guide |

## How to use

- **Writing a script?** Start from rule 1, quote everything (rule 2), and reach
  for arrays (rule 5) the moment you have a list of arguments.
- **Reviewing a script?** Run `shellcheck` at its **default** severity (this
  repo's `.shellcheckrc` sets `enable=all`); the SC codes above map directly to
  these rules. CI lints at `--severity=warning`, which catches the
  higher-severity codes but filters out `SC2086`/`SC2162` (info) and `SC2292`
  (style) — so review locally at the default level to see them all.
- **Formatting?** `shfmt` (configured in `.editorconfig`) enforces layout — it
  even rewrites legacy backticks to `$(...)` for you, which is why there is no
  runnable backticks example here.

See also: [`skills/bash`](../bash/), [`skills/zsh`](../zsh/), and
[`skills/nushell`](../nushell/) for shell-specific guidance.
