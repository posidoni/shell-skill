# Task Completion

- Before handing back any coding/release change, run `task ci` from repo root.
- Before committing/opening PRs, also run `task hooks`.
- For AI metadata changes, run `task ai-integrations`.
- For plugin packaging changes, run the active Codex `plugin-creator` validator through `uv run --with PyYAML python <validator> .` when available.
- For skill frontmatter/body changes, run the active Codex `skill-creator` validator through `uv run --with PyYAML python <validator> <skill-dir>` when available.
- If tests fail, fix the repo; do not weaken the good/bad example contract or remove the schema gate to get green.
- After Serena onboarding/memory edits, the user can sanity-check references with `serena memories check` from repo root.
