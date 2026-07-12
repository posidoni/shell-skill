---
name: nushell
description: >-
  Nushell practices — the parse-time-vs-runtime model, structured data over text,
  immutability (let/mut/const), typed custom commands and def --env, expression
  control flow, config/env and modules, error handling, external commands with ^
  and complete, and version-pinning. Use when writing Nushell scripts or config,
  or when Nushell fails to start or a script breaks after a version upgrade.
---

# Nushell

Nushell passes typed, structured values (records, tables, lists), not text.
Depth and citations in [`reference/nushell.md`](../../reference/nushell.md);
parse-clean fragments in [`examples/nushell/`](../../examples/nushell/); a runtime
demo of the startup pitfall in
[`tests/nushell-startup-demo.sh`](../../tests/nushell-startup-demo.sh).

## Rules at a glance

| Rule | Why |
|------|-----|
| Parse the whole file, then run it | no `eval`; runtime cannot change what was parsed |
| `source`/`use`/`overlay use` need a **parse-time `const`** path | resolved before any `let`/`$env` exists |
| A runtime `if (path exists)` can't guard a `source` | path is resolved at parse time regardless |
| Structured data, not text: `get`/`where`/`select` | pipelines carry typed values, no word-splitting |
| Write with `save`, not `>` | `>` is the greater-than operator |
| Prefer `let`; `mut` only to reassign; `const` for parse time | immutability enables parallel/streaming |
| Type command params; declare `in -> out` signatures | checked at parse time, self-documenting |
| `def --env` when a command must change env or `cd` | `$env` is block-scoped otherwise |
| `if`/`match` are expressions; iterate with `each`/`where` | return values; far faster than `for`/`while` |
| `^cmd` for externals + `\| complete` for exit code | quote args yourself; branch on real status |
| `try`/`catch`, `error make`, optional `get -o`/`?` + `default` | recover instead of aborting |
| Pin/declare the target Nushell version | 0.x ships breaking changes every ~6 weeks |

## Verify

`task nushell` runs `nu --ide-check` on every `*.nu` and fails on any parse or
type error. A failing script cannot be committed, so demonstrate *bad* runtime
behaviour in prose or a hermetic bash demo, not in a `*.nu` file.
