# CLAUDE.md

Project instructions for [Claude Code](https://claude.com/claude-code). This
project follows **[AGENTS.md](AGENTS.md)** — read it first; everything there
applies here too.

## Claude-specific notes

- The directories under `skills/` are **Agent Skills** — each is a `SKILL.md`
  with `name` + `description` frontmatter and instructions. Claude loads a
  skill's full body only when its description matches the task (progressive
  disclosure), so keep descriptions precise.
- The repo is packaged as an installable Claude Code plugin; see
  [`.claude-plugin/`](.claude-plugin/). It also ships Codex metadata in
  [`.codex-plugin/`](.codex-plugin/) and ChatGPT notes in [CHATGPT.md](CHATGPT.md).
  You can also point Claude at `skills/` directly.
- Use the skills here — `shell-standards`, `bash`, `zsh`, `nushell` — whenever
  you write, review, or debug shell in this repository.

## Before you finish

- `task ci` and `task hooks` must be green. Never commit red.
- Conventional Commits; no personal data or secrets in tracked files.
