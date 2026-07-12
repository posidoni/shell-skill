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

## Workflow

```sh
task --list      # discover every entrypoint
task fmt         # format shell scripts (shfmt -w)
task ci          # fmt-check, lint, examples, nushell, nushell-demo, test
task hooks       # pre-commit run --all-files
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
