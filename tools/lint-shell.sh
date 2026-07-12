#!/usr/bin/env bash
#
# lint-shell.sh — ShellCheck every shell script that is meant to be clean.
#
# `*.bad.sh` files are intentional anti-patterns and are excluded here; they are
# validated separately by tools/check-bad-examples.sh.
set -euo pipefail

root=$(git rev-parse --show-toplevel)
cd "$root"

mapfile -t files < <(
  git ls-files -co --exclude-standard -- '*.sh' '*.bash' | grep -v -e '\.bad\.sh$' || true
)

if [[ ${#files[@]} -eq 0 ]]; then
  printf '%s\n' "lint-shell: no shell files found"
  exit 0
fi

printf '%s\n' "lint-shell: shellcheck --severity=warning on ${#files[@]} files"
shellcheck --severity=warning -- "${files[@]}"
printf '%s\n' "lint-shell: OK"
