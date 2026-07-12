#!/usr/bin/env bash
#
# format-check.sh — assert every shell script is shfmt-formatted.
#
# shfmt reads its options from .editorconfig. `.bats` files are excluded because
# their `@test` syntax is not valid POSIX/Bash and shfmt cannot parse it.
# `*.bad.sh` files are excluded too: the anti-pattern they demonstrate is
# sometimes invalid syntax under its own declared dialect (e.g. bash array
# syntax under a `#!/bin/sh` shebang, which shfmt cannot parse in POSIX mode).
# The example contract in CONTRIBUTING.md only requires `*.good.sh` to be
# shfmt-clean, matching lint-shell.sh's existing `*.bad.sh` exclusion.
set -euo pipefail

root=$(git rev-parse --show-toplevel)
cd "$root"

mapfile -t files < <(
  git ls-files -co --exclude-standard -- '*.sh' '*.bash' | grep -v -e '\.bad\.sh$' || true
)

if [[ ${#files[@]} -eq 0 ]]; then
  printf '%s\n' "format-check: no shell files found"
  exit 0
fi

# `shfmt -l` lists files that would change; empty output means all are clean.
unformatted=$(shfmt -l -- "${files[@]}")

if [[ -n "$unformatted" ]]; then
  printf '%s\n' "format-check: FAILED — these files are not shfmt-formatted:" >&2
  printf '  %s\n' "$unformatted" >&2
  printf '%s\n' "Run 'task fmt' to fix." >&2
  exit 1
fi

printf '%s\n' "format-check: OK (${#files[@]} files)"
