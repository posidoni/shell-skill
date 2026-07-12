---
name: shebang
description: >-
  How to write correct, portable shebang (#!) lines — prefer /usr/bin/env,
  pass interpreter flags with env -S, keep the path absolute and the line short,
  and match the dialect. Use when creating any executable script, choosing
  between /usr/bin/env bash and /bin/bash, or diagnosing a "bad interpreter"
  error.
---

# Shebang

The `#!` line picks a script's interpreter. Depth, mechanism, and citations in
[`reference/shebang.md`](../../reference/shebang.md); runnable pairs in
[`examples/shebang/`](../../examples/shebang/).

## Rules at a glance

| Rule | Good | Bad | Caught by |
|------|------|-----|-----------|
| Prefer `env` for portable version | `#!/usr/bin/env bash` | `#!/bin/bash` | judgment |
| Pass flags with `env -S` | `#!/usr/bin/env -S bash -euo pipefail` | `#!/usr/bin/env bash -euo pipefail` | `SC2096` |
| Absolute interpreter path | `#!/usr/bin/env python3` | `#!bin/python3` | `SC2239` |
| `#!` first, LF endings, no BOM | `#!…` on line 1 | `#…`, CRLF, blank line | `SC1113`/`SC1017`/`SC1128` |
| Executable scripts need a shebang | present | missing | `SC2148` |
| Keep the line < 127 bytes | short | long `env -S` chains | kernel (silent truncation) |
| Pin absolute path when privileged | `#!/bin/sh` | `#!/usr/bin/env` (PATH-hijackable) | judgment |
| Match the dialect you write | `#!/usr/bin/env bash` + bashisms | `#!/bin/sh` + `[[ ]]` | runtime (dash) |

## Why the kernel forces these

The interpreter path is used verbatim (no `PATH` search, so it must be absolute),
everything after it is a **single** argument (hence `env -S` for flags), and the
line is length-limited and **silently truncated** past the kernel's buffer. See
the reference for `execve(2)` details.

## Do not

Polyglot/self-re-exec headers, `${ORIGIN}/`-relative shebangs, arbitrary programs
as interpreters, and relying on setuid — all fragile or non-standard.
