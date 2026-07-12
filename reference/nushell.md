# Nushell

[Nushell](https://www.nushell.sh/) is not a POSIX shell — it is a shell built
around **structured data**. Commands pass typed values (records, tables, lists),
not raw text, so most `sed`/`awk`/`cut` munging disappears. This changes how you
write and, especially, how you configure it.

## Structured data first

Prefer built-in structured operations over text parsing:

```nu
ls | where size > 1mb | sort-by modified | select name size
```

`ls` yields a table; `where`/`sort-by`/`select` operate on columns. Reach for
`from json`/`from csv`/`to json` at the boundaries instead of hand-parsing.

## Configuration load order (the #1 startup pitfall)

Nushell evaluates two files at startup, **in this order**:

1. **`env.nu`** — evaluated fully first. Put environment setup and any file
   *generation* here.
2. **`config.nu`** — parsed and evaluated second.

The trap: **`source` and `use` need a *parse-time* literal path.** Nushell
resolves them while *parsing* `config.nu`, before any runtime code in that file
runs. So this still aborts startup even though the path is guarded:

```nu
# config.nu — DOES NOT WORK if generated.nu is missing at parse time
if ('generated.nu' | path exists) { source generated.nu }
```

A runtime `if` cannot rescue a parse-time `source`; you get
`nu::parser::sourced_file_not_found` and the shell fails to start.

**The fix:** generate the file in `env.nu` (which is fully evaluated *before*
`config.nu` is parsed), so the literal path already exists by the time
`config.nu` is parsed:

```nu
# env.nu — runs first, so the file exists before config.nu is parsed
let target = ($nu.default-config-dir | path join generated.nu)
if not ($target | path exists) {
  "$env.GENERATED = 'yes'\n" | save --force $target
}
```

This exact bug and fix are demonstrated, hermetically and at runtime, in
[`tests/nushell-startup-demo.sh`](../tests/nushell-startup-demo.sh).

## Launch modes

Behaviour differs by how Nushell is started, which matters when debugging config:

| Mode | Loads env.nu/config.nu? |
|------|-------------------------|
| Login shell | yes, plus `login.nu` |
| Interactive (`nu`) | yes |
| Command string (`nu -c '...'`) | only with `--env-config`/`--config` |
| Script (`nu script.nu`) | no user config by default |
| `nu --ide-check` / `--lsp` | parse/type check only, no execution |

## Optional cell paths

Accessing a missing column is an error by default. Use the optional form to get
`null` instead:

```nu
$record | get -o maybe_missing     # null if absent, no error
$record.maybe_missing?             # same, cell-path form
```

## Testing

Static-check every `*.nu` with `nu --ide-check`, which reports parse and type
errors as JSON without running the script. This repo's `task nushell`
(`tools/check-nushell.sh`) fails on any `"severity":"Error"`.

See [`skills/nushell`](../skills/nushell/) and the parse-clean fragments in
[`examples/nushell/`](../examples/nushell/).
