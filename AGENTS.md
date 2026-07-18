# AGENTS.md

Guidance for AI coding agents — OpenAI Codex, GitHub Copilot, Claude Code,
Cursor, and any other tool that reads an `AGENTS.md`. Humans should start with
[README.md](README.md) and [CONTRIBUTING.md](CONTRIBUTING.md).

## What this repository is

`shell-skill` teaches safe, correct shell (Bash, Zsh, POSIX `sh`) and Nushell
through cited rules, runnable good/bad examples, and loadable agent skills.

## Golden rules

1. **Never leave the tree red.** `task ci` and `task hooks` must pass before you
   commit.
2. **Every shell/Nushell snippet must be correct *and* safe.** A broken or unsafe
   example is a critical bug — this repo's whole purpose is to be trustworthy.
3. **No personal data, secrets, or machine-specific paths** in any tracked file.
   Use `$HOME`/`~` generically.
4. **Local-only by default:** do not `git push`, change remotes, or alter
   repository visibility unless the human explicitly asks.
5. **YAML is schema-backed:** every tracked `*.yml`, `*.yaml`, and
   `CITATION.cff` starts with a `yaml-language-server` JSON Schema modeline.

## Workflow

```sh
task --list      # discover every entrypoint
task fmt         # format shell scripts (shfmt -w)
task ci          # fmt-check, lint, examples, nushell, nushell-demo, yaml-schemas, ai-integrations, test
task hooks       # lefthook run pre-commit --all-files
task yaml-schemas # ensure YAML-like files declare JSON Schemas
task ai-integrations # validate Codex/ChatGPT/Serena discovery
```

## The example contract

Examples live in `examples/<domain>/` as paired files plus a per-domain README:

- `NN-slug.good.sh` — correct pattern; self-contained, no args, exits 0, clean
  under `shellcheck --severity=warning` and `shfmt`. Use `mktemp` + `trap`.
- `NN-slug.bad.sh` — safe-to-run anti-pattern with one directive:
  `# expect-shellcheck: SC####` (codes ShellCheck must report) or
  `# expect-shellcheck: none` (a style-guide-only pitfall).

Nushell examples are `*.nu` and must pass `nu --ide-check`.

## Conventions

- [Conventional Commits](https://www.conventionalcommits.org/)
  (`feat:`/`fix:`/`docs:`/`test:`/`chore:`/`build:`/`ci:`).
- Keep `SKILL.md` files short; put depth in `reference/`.
- Match the existing rationale-first tone; no filler.

## Map

| Path | What |
|------|------|
| `skills/<domain>/SKILL.md` | agent-facing skills (frontmatter + instructions) |
| `reference/*.md` | in-depth references with citations |
| `examples/<domain>/` | runnable good/bad pairs |
| `tools/`, `tests/` | verification scripts and the bats suite |
| `Taskfile.yml` | task runner entrypoints |
| `.agents/skills/` | Codex repo-scope skill symlinks to `skills/` |
| `.codex/config.toml` | trusted Codex project defaults |
| `.serena/project.yml`, `.serena/memories/` | portable Serena project setup |
| `.codex-plugin/`, `.claude-plugin/` | Codex and Claude Code plugin manifests |
| `CHATGPT.md`, `llms.txt` | ChatGPT/Codex handoff and crawler-friendly index |
| `schemas/`, `registry/` | JSON Schemas and directory submission drafts |
