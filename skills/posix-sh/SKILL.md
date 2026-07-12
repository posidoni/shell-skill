---
name: posix-sh
description: >-
  POSIX sh portability — no local, no arrays, [ ] not [[ ]], set -eu without
  pipefail, and other bashisms that break under a real /bin/sh (dash on
  Debian/Ubuntu, most container base images, curl | sh installers). Use when
  a script's shebang is #!/bin/sh, when targeting a minimal or non-bash
  runtime, or when ShellCheck reports an SC3xxx code.
---

# POSIX sh

Builds on [`skills/shell-standards`](../shell-standards/). Depth and
citations in [`reference/posix-sh.md`](../../reference/posix-sh.md); runnable
pairs in [`examples/posix-sh/`](../../examples/posix-sh/).

## Key points

| Topic | Do | Avoid |
|-------|----|-------|
| Strict mode | `set -eu` | `set -o pipefail` (not POSIX) |
| Function-local state | capture via `$( )`, which already subshells | `local` (`SC3043`) |
| Lists | `set -- ...` / `"$@"` | `arr=(...)` (`SC3030`/`SC3054`) |
| Conditionals | `[ "$x" = y ]` | `[[ $x == y ]]` (`SC3010`/`SC3014`) |
| Sourcing | `. ./lib.sh` | `source ./lib.sh` (`SC3046`) |
| Functions | `name() { ...; }` | `function name { ...; }` (`SC3045`) |

## Why this matters

`/bin/sh` is `dash` on Debian/Ubuntu, not `bash` — and most container base
images, install scripts (`curl | sh`), and anything with a literal
`#!/bin/sh` shebang run under a real POSIX shell with none of Bash's
extensions. Code that only ran under `bash` in development can fail — or
silently misbehave — the first time it runs as `/bin/sh`.

## Verify

`shellcheck` infers the POSIX dialect automatically from a `#!/bin/sh`
shebang (`SC3xxx` codes only fire there). `task ci` runs both ShellCheck and
`shfmt` over [`examples/posix-sh/`](../../examples/posix-sh/); note that
`*.bad.sh` files there are excluded from the shfmt gate because some
anti-patterns (arrays) are invalid POSIX syntax, not just bad style — shfmt
cannot parse them in POSIX mode at all.
