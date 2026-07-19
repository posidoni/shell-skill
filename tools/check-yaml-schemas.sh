#!/usr/bin/env bash
set -euo pipefail

status=0

# Regex lives in a variable and is expanded UNQUOTED in [[ =~ ]] (SC2076).
# Escaping the spaces and the $ inline also works, but it is unreadable and a
# future edit silently turns the pattern into something else.
schema_pattern='^# yaml-language-server: \$schema='

while IFS= read -r file; do
  if [[ ! -f "$file" ]]; then
    continue
  fi

  # `read` builtin rather than `sed -n 1p`: one fork per file, and this loop
  # runs over every tracked YAML file in the repo.
  # `|| :` because read exits non-zero on a last line with no trailing newline.
  first_line=""
  read -r first_line < "$file" || :
  if [[ ! $first_line =~ $schema_pattern ]]; then
    printf 'missing first-line YAML schema comment: %s\n' "$file" >&2
    status=1
  fi
done < <(git ls-files --cached --others --exclude-standard '*.yml' '*.yaml' '*.cff')

exit "$status"
