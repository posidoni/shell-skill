#!/usr/bin/env bash
#
# check-nushell.sh — static-check every Nushell script with `nu --ide-check`.
#
# `nu --ide-check N FILE` always exits 0 and emits diagnostics as JSON lines.
# We fail if any diagnostic has "severity":"Error" (parse or type errors).
# Runnable good/bad *behaviour* is demonstrated in the scripts themselves and in
# tests/nushell-startup-demo.sh — the static gate only proves they parse.
set -euo pipefail

root=$(git rev-parse --show-toplevel)
cd "$root"

if ! command -v nu > /dev/null 2>&1; then
  echo "check-nushell: 'nu' not found on PATH" >&2
  exit 127
fi

mapfile -t files < <(git ls-files -co --exclude-standard -- '*.nu')

if [[ ${#files[@]} -eq 0 ]]; then
  echo "check-nushell: no *.nu files found"
  exit 0
fi

fail=0
for f in "${files[@]}"; do
  out=$(nu --ide-check 100 "$f" 2>&1 || true)
  if grep -q '"severity":"Error"' <<< "$out"; then
    echo "FAIL $f:" >&2
    printf '%s\n' "$out" >&2
    fail=1
  else
    echo "OK   $f"
  fi
done

exit "$fail"
