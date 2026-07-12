---
name: zsh
description: >-
  Zsh scripting differences from Bash — no automatic word-splitting, 1-indexed
  arrays, emulate -LR zsh for hermetic functions, subprocess-free existence
  checks via zsh/parameter, and glob qualifiers. Use when writing or reviewing
  zsh, or when a script behaves differently under zsh than bash.
---

# Zsh

Depth in [`reference/zsh.md`](../../reference/zsh.md). Zsh is a great interactive
shell but a different scripting language from Bash.

## Key points

- **No auto word-splitting:** unquoted `$var` stays one word in zsh (it splits in
  Bash). This is the most common cross-shell bug. Split explicitly with
  `${=var}` or `${(s: :)var}`.
- **Arrays are 1-indexed:** `$arr[1]` is the first element.
- **`emulate -LR zsh`** at the top of a function resets options so a user's
  `setopt` cannot change its behaviour.
- **Existence checks without a subshell:** `zmodload zsh/parameter` then
  `(( $+commands[git] ))`.
- **Globbing:** `**` recurses; qualifiers like `*(.)` and `*(N)` refine matches.

## Tooling caveat

**ShellCheck and shfmt do not support zsh.** Syntax-check with `zsh -n`. For
anything that must be linted, formatted, and portable, write Bash instead and
keep zsh for interactive config. This is why this repo has no runnable zsh
example files — they could not pass the Bash-oriented example contract.
