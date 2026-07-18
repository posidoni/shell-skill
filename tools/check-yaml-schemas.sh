#!/usr/bin/env bash
set -euo pipefail

status=0

while IFS= read -r file; do
  if [[ ! -f "$file" ]]; then
    continue
  fi

  first_line=$(sed -n '1p' "$file")
  if [[ ! $first_line =~ ^#\ yaml-language-server:\ \$schema= ]]; then
    printf 'missing first-line YAML schema comment: %s\n' "$file" >&2
    status=1
  fi
done < <(git ls-files --cached --others --exclude-standard '*.yml' '*.yaml' '*.cff')

exit "$status"
