# POSIX sh examples

Runnable good/bad pairs for [`reference/posix-sh.md`](../../reference/posix-sh.md).
The contract is the same as [`examples/standards/`](../standards/README.md):
`*.good.sh` runs to exit 0 with no arguments and is linter-clean; `*.bad.sh` is
safe to run and declares the ShellCheck code(s) it triggers.

Every file uses `#!/bin/sh`. ShellCheck and shfmt both infer the POSIX dialect
from that shebang automatically. `*.bad.sh` files here demonstrate bashisms
that are not just bad style but invalid POSIX syntax — arrays, for instance —
so they are excluded from the shfmt formatting gate the same way every
`*.bad.sh` is already excluded from `tools/lint-shell.sh`
(see `tools/format-check.sh`).

| Pair | Good shows | Bad shows | Code |
|------|-----------|-----------|------|
| `01-no-local` | capture a result via `$(...)`, no leak | `local` (undefined in POSIX sh) | `SC3043` |
| `02-positional-params-not-arrays` | `set -- ...` / `"$@"` as the list | `arr=(...)` (no array type in POSIX sh) | `SC3030`/`SC3054` |
| `03-test-not-double-bracket` | `[ "$x" = y ]` | `[[ $x == y ]]` (undefined in POSIX sh) | `SC3010`/`SC3014` |

## Run them

```sh
# One good example:
sh examples/posix-sh/01-no-local.good.sh

# The whole contract (behaviour + linters):
task ci
```
