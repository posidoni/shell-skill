# CHATGPT.md

ChatGPT and Codex companion instructions for this repository. The canonical
project contract remains [AGENTS.md](AGENTS.md); read it first.

## What to load

- Use `.codex-plugin/plugin.json` when packaging this repo as a Codex plugin.
- Use `.agents/skills/*` for Codex repo-scope discovery in trusted checkouts;
  these entries are symlinks to the canonical `skills/` folders.
- Use `.codex/config.toml` for durable project defaults. It currently enables
  multi-agent work only; sandbox, approval, and credentials stay user-local.
- Use `skills/*/SKILL.md` as portable Agent Skills. The `agents/openai.yaml`
  files add ChatGPT/Codex UI metadata only; they do not replace `SKILL.md`.
- Use `reference/*.md` only when a task needs the cited rationale behind a rule.

## How to work here

- Keep skill bodies short and operational. Put depth in `reference/`.
- Preserve the good/bad example contract from `CONTRIBUTING.md`.
- Run `task ci` before handing back release work.
- Run `task hooks` before commits or pull requests.
- Run `task ai-integrations` after changing AI metadata or repo-scoped skills.
- Keep local tool state out of the release package.

## Release packaging

- Update both `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json` for
  versioned releases.
- Keep `README.md`, `CHANGELOG.md`, `CITATION.cff`, and registry notes in sync
  with the public release name: Shell Skill Kit.
