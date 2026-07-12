---
name: nushell
description: >-
  Nushell practices — structured-data pipelines over text munging, the
  env.nu/config.nu load order and the parse-time-vs-runtime `source` pitfall,
  launch modes, and optional cell paths. Use when writing Nushell scripts or
  config, or when Nushell fails to start with a sourced-file or parser error.
---

# Nushell

Nushell passes typed, structured values (records, tables, lists), not text.
Depth and citations in [`reference/nushell.md`](../../reference/nushell.md);
parse-clean fragments in [`examples/nushell/`](../../examples/nushell/); a
runtime demo of the startup pitfall in
[`tests/nushell-startup-demo.sh`](../../tests/nushell-startup-demo.sh).

## Key points

- **Structured over text:** `ls | where size > 1mb | select name size`, not
  `ls -l | awk`. Use `from json`/`to json` at boundaries.
- **Startup order:** `env.nu` is evaluated fully *before* `config.nu` is parsed.
- **`source`/`use` are parse-time:** their path must exist when `config.nu` is
  *parsed*. A runtime `if (... | path exists)` guard does **not** help. Generate
  the file in `env.nu` instead.
- **Optional cell paths:** `$rec | get -o col` or `$rec.col?` yields `null`
  instead of erroring on a missing column.

## Verify

`task nushell` runs `nu --ide-check` on every `*.nu` and fails on any parse or
type error. Because a failing script cannot be committed, demonstrate *bad*
runtime behaviour in prose or a hermetic bash demo, not in a `*.nu` file.
