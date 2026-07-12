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
or hide failures. Each rule links to a runnable good/bad pair in
[`examples/standards/`](../../examples/standards/) and is explained in depth,
with citations, in [`reference/shell-standards.md`](../../reference/shell-standards.md).

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
- **Reviewing a script?** Run `shellcheck --severity=warning`; the SC codes above
  map directly to these rules. This repo's own config (`.shellcheckrc`) turns on
  `enable=all` for the strictest local feedback.
- **Formatting?** `shfmt` (configured in `.editorconfig`) enforces layout — it
  even rewrites legacy backticks to `$(...)` for you, which is why there is no
  runnable backticks example here.

See also: [`skills/bash`](../bash/), [`skills/zsh`](../zsh/), and
[`skills/nushell`](../nushell/) for shell-specific guidance.
