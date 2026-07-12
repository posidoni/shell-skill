---
name: zsh
description: >-
  Zsh scripting and performance practices — emulate -L zsh, safety options, no
  automatic word-splitting, 1-indexed arrays, subprocess-free idioms ($TTY not
  $(tty), ${f:h}/${f:t} not dirname/basename), zsh/parameter existence checks,
  and glob qualifiers. Use when writing zsh functions, scripts, or a fast
  interactive config, or when a zsh script behaves differently from bash.
---

# Zsh

Depth and citations in [`reference/zsh.md`](../../reference/zsh.md). Two framing
facts: ShellCheck and shfmt do not support zsh (syntax-check with `zsh -n`), and
zsh's edge is doing work **without forking a subprocess**.

## Robust scripting

| Rule | Why |
|------|-----|
| `emulate -L zsh` in functions, `emulate -LR zsh` in scripts | reset options; a caller's `setopt` can't change your behaviour |
| `setopt err_return` (not `errexit` in sourced code), `no_unset`, `pipefail`, `warn_create_global` | fail fast without killing the shell; catch leaked globals |
| No auto word-splitting; split with `${=v}` / `${(s:X:)v}` / `${(f)v}` | unquoted `$var` stays one word (unlike Bash) |
| Arrays are 1-indexed: `$arr[1]`, `$#arr`, `arr+=(x)`, `"${(@)arr}"` | `${arr[0]}` is the wrong element |
| Quote for re-parse with `${(q)v}`; indirect with `${(P)name}` | safe `eval`/`ssh`; no `${!name}` |
| `zparseopts -D -E -F` | robust option parsing |

## Performance (romkatv): never fork in a hot path

| Rule | Why |
|------|-----|
| `$TTY`, never `$(tty)` | fork cost, and `$(tty)` reads fd 0 — wrong under redirected stdin / instant prompt; `$TTY` is the shell's controlling terminal |
| `${f:h}` / `${f:t}` / `${f:r}` / `${f:e}` / `${f:A}` not `dirname`/`basename`/`realpath` | in-process string ops, no fork |
| `$EPOCHREALTIME` / `$EPOCHSECONDS` not `$(date)` | `zmodload zsh/datetime` |
| `${${(%):-%x}:A:h}` for a script's own dir; `${(%):-%N}` / `$funcstack` | no `readlink` fork |
| `(( $+commands[x] ))` via `zsh/parameter` | existence check with no `command -v` fork |
| `[[ ]]` / `(( ))` not `[ ]`/`test`/`expr`; `$(<file)` not `$(cat file)` | keywords/builtins, no fork |
| glob qualifiers `(.)`/`(N)`/`(om)` + `**` not `find`/`ls` | in-process, robust on odd filenames |

## Verify

`zsh -n script.zsh` for syntax; there is no ShellCheck for zsh. For anything that
must be linted and portable, write Bash instead.
