# Codex Repo Skills

This directory exposes the repository's portable `skills/` folders as
repo-scoped Codex skills.

OpenAI's Codex skill discovery scans `$REPO_ROOT/.agents/skills`. The real
skill sources remain in `../skills`; entries here are symlinks so Claude Code,
Codex, and generic Agent Skills clients share the same `SKILL.md` files.

When adding a skill:

1. Create `skills/<name>/SKILL.md`.
2. Create `.agents/skills/<name> -> ../../skills/<name>`.
3. Add `skills/<name>/agents/openai.yaml`.
4. Run `task ai-integrations`.
