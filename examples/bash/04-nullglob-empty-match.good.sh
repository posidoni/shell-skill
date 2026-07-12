#!/usr/bin/env bash
#
# GOOD: nullglob expands an unmatched pattern to zero words, so an empty
# directory produces no phantom filename.
set -euo pipefail

main() (
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT
  cd "$tmp"

  shopt -s nullglob
  files=(*.txt)
  printf 'matched %s file(s)\n' "${#files[@]}"
)

main "$@"
