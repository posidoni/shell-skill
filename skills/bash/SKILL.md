---
name: bash
description: >-
  Bash-specific practices beyond the shared standards — error handling (pipefail,
  trap ERR), macOS/BSD-vs-GNU portability, arrays and mapfile, and safe temp
  files. Use when writing or reviewing Bash scripts that must be robust and
  portable, or when a script behaves differently on macOS than on Linux.
---

# Bash

Builds on [`skills/shell-standards`](../shell-standards/). Depth and citations in
[`reference/bash.md`](../../reference/bash.md); runnable pairs in
[`examples/bash/`](../../examples/bash/).

## Key points

| Topic | Do | Avoid |
|-------|----|-------|
| Arrays | `mapfile -t arr < file` | `arr=($(cat file))` (`SC2207`) |
| Array expansion | `"${arr[@]}"` | bare `$arr` = first element only (`SC2128`) |
| Forwarding args | `"$@"` | unquoted `$@` (`SC2068`) |
| Errors | `trap ... ERR`, explicit checks | `\|\| true` masking |
| Portability | assert `BASH_VERSINFO`; temp-file `sed` | assuming GNU coreutils / Bash 4 |

## Portability

macOS ships Bash 3.2 and BSD userland. `mapfile`, `readarray`, and
`declare -A` are Bash 4+; `sed -i` and `readlink -f` differ from GNU. If you rely
on Bash 4 features, assert the version early and exit with a clear message. See
`reference/bash.md` for the full compatibility table.

## Verify

`task ci` runs `shellcheck --severity=warning` and the bats suite over these
examples. The SC codes in the table map one-to-one to the anti-patterns.
