# Bash

Bash-specific guidance beyond the cross-cutting rules in
[`shell-standards.md`](shell-standards.md): error handling, portability, arrays,
and safe temp files. Snippets cite the
[Bash reference manual](https://www.gnu.org/software/bash/manual/bash.html) and
[ShellCheck](https://www.shellcheck.net/) codes.

## Error handling beyond `set -e`

`set -euo pipefail` is the floor. Two additions earn their keep:

- **`trap ... ERR`** to report *where* a script died:

  ```bash
  trap 'echo "failed at line $LINENO" >&2' ERR
  ```

- **Explicit checks** for the failures `set -e` deliberately ignores — a command
  in an `if`, a `&&`/`||` chain, or the left side of a pipe (mitigated by
  `pipefail`). Do not paper over these with `|| true`.

## Portability: macOS and BSD vs GNU

Scripts that "work on my machine" often assume GNU coreutils. macOS ships **Bash
3.2** (2007) and **BSD** userland. Guard against both:

| Concern | GNU (Linux) | BSD (macOS) | Portable approach |
|---------|-------------|-------------|-------------------|
| In-place sed | `sed -i` | `sed -i ''` | write to a temp file, then `mv` |
| Canonical path | `readlink -f` | (absent) | a small `cd`/`pwd` helper, or `realpath` if present |
| Associative arrays | `declare -A` (Bash 4+) | not in 3.2 | avoid, or require Bash 4 explicitly |
| `mapfile`/`readarray` | Bash 4+ | not in 3.2 | `while IFS= read -r` loop for 3.2 |

If you require Bash 4+, assert it early and fail with a clear message rather than
misbehaving:

```bash
if ((BASH_VERSINFO[0] < 4)); then
  echo "This script needs Bash 4+ (found $BASH_VERSION)." >&2
  exit 1
fi
```

## Arrays

- Build lists as arrays; expand quoted: `"${arr[@]}"`. A bare `$arr` is only the
  **first** element (`SC2128`).
- Read lines with `mapfile -t arr < file`, not `arr=($(cat file))`, which
  word-splits and globs (`SC2207`).
- Forward a script's own arguments verbatim with `"$@"` (`SC2068` flags the
  unquoted form).

See the runnable pairs in [`examples/bash/`](../examples/bash/).

## Safe temp files

Create with `mktemp`, remove with an `EXIT` trap set immediately afterward. Keep
the variable at script scope so the trap can still see it after a function
returns:

```bash
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
```

## Testing

This repo verifies every `*.good.sh` with [bats](https://github.com/bats-core/bats-core)
(`tests/examples.bats`). For your own scripts, bats keeps behavioural tests close
to the code; run them in CI alongside `shellcheck` and `shfmt`.
