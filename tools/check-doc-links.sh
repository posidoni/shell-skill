#!/usr/bin/env bash
#
# check-doc-links.sh — every relative Markdown link must resolve.
#
# Why this exists: collapsing seven skills into one router (#18) deleted
# skills/{nushell,shebang,streams,zsh}/ but left four reference/*.md files
# linking to them. Every other gate stayed green -- lint, tests, examples,
# schemas, ai-integrations -- because none of them reads a link. In a repo
# whose product IS its documentation, a dangling link is a defect.
#
# Only relative targets are checked. External URLs are deliberately not
# fetched: that needs network, is slow, and turns someone else's outage into
# a red build.
#
# One grep+sed per file is a deliberate choice over a single clever pass. A
# rewrite that hoisted both out of the loop to avoid the subprocesses silently
# mangled its own field splitting and reported every link as broken. Two
# subprocesses per markdown file is cheap; a checker that lies is not.
set -euo pipefail

status=0
checked=0

while IFS= read -r file; do
  dir=$(dirname "${file}")

  while IFS= read -r target; do
    [[ -z ${target} ]] && continue
    case "${target}" in
      http://* | https://* | mailto:* | '#'*) continue ;;
      *) ;;
    esac

    target=${target%%#*}
    [[ -z ${target} ]] && continue

    checked=$((checked + 1))
    if [[ ! -e "${dir}/${target}" ]]; then
      printf 'broken link: %s -> %s\n' "${file}" "${target}" >&2
      status=1
    fi
    # `[text](target)` with no spaces or parens inside the target, which is
    # what every link in this repo looks like.
  done < <(grep -o '\[[^][]*\]([^() ]*)' "${file}" | sed 's/.*(\(.*\))/\1/')
done < <(git ls-files '*.md')

if [[ ${status} -eq 0 ]]; then
  printf 'doc-links: OK (%s relative links resolve)\n' "${checked}"
fi

exit "${status}"
