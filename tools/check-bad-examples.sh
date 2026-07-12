#!/usr/bin/env bash
#
# check-bad-examples.sh — verify that every `*.bad.sh` anti-pattern is
# documented and, where applicable, actually detected by ShellCheck.
#
# Contract: each `*.bad.sh` MUST contain exactly one directive line:
#
#     # expect-shellcheck: SC2086 SC2250     -> those codes MUST be reported
#     # expect-shellcheck: none               -> not ShellCheck-detectable
#                                                (a style-guide-only pitfall)
#
# This turns "does ShellCheck catch it?" into an explicit, tested claim for
# every anti-pattern in the repository.
set -euo pipefail

root=$(git rev-parse --show-toplevel)
cd "$root"

mapfile -t bad < <(git ls-files -co --exclude-standard -- '*.bad.sh')

if [[ ${#bad[@]} -eq 0 ]]; then
  echo "check-bad-examples: no *.bad.sh files found"
  exit 0
fi

fail=0
for f in "${bad[@]}"; do
  directive=$(grep -m1 -E '^# expect-shellcheck:' "$f" || true)
  if [[ -z "$directive" ]]; then
    echo "FAIL $f: missing '# expect-shellcheck:' directive" >&2
    fail=1
    continue
  fi

  read -r -a want <<< "${directive#*expect-shellcheck:}"

  # Capture ShellCheck output regardless of its exit status.
  out=$(shellcheck --severity=warning --format=gcc -- "$f" 2>&1 || true)

  if [[ "${want[0]:-}" == "none" ]]; then
    echo "OK   $f: documented style-guide-only pitfall (no ShellCheck code)"
    continue
  fi

  if [[ -z "$out" ]]; then
    echo "FAIL $f: expected ShellCheck to report ${want[*]}, but output was clean" >&2
    fail=1
    continue
  fi

  missing=()
  for code in "${want[@]}"; do
    grep -q -- "$code" <<< "$out" || missing+=("$code")
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "FAIL $f: ShellCheck did not report ${missing[*]}" >&2
    printf '%s\n' "$out" >&2
    fail=1
    continue
  fi

  echo "OK   $f: ShellCheck reported ${want[*]}"
done

exit "$fail"
