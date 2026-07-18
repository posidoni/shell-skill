<div align="center">

<img src="assets/logo.svg" alt="Shell Skill Kit" width="104">

# Shell Skill Kit

**Small, test-enforced shell rules for AI coding agents.**

Bash, Zsh, POSIX `sh`, Nushell, shebangs, and streams, packaged as portable
Agent Skills plus Claude Code and Codex metadata.

[Skills](#skills) | [Install](#install) | [Agent Surfaces](#agent-surfaces) | [Quality Gates](#quality-gates) | [Registry](REGISTRY.md)

</div>

---

## What It Is

Shell Skill Kit is a lightweight rule pack for one risky place in AI coding:
generated shell.

It is deliberately not a framework. The repo ships four things:

- short `SKILL.md` files that agents can load on demand;
- cited references for the reasoning behind each rule;
- runnable good/bad examples that CI checks;
- provider metadata for Codex, ChatGPT, Claude Code, Copilot, Serena, and other
  skill-aware tools.

The design contract is simple: **tiny skill bodies, deep references, executable
claims**. If a shell rule cannot be cited or tested, it stays out.

## Why It Exists

AI assistants often produce shell that works once and fails quietly later:
unquoted expansions, wrong dialects, swallowed errors, stdout polluted with
diagnostics, or Bash code hiding under `#!/bin/sh`.

Shell Skill Kit makes those failure modes harder to ship. `*.good.sh` examples
must run and lint cleanly. `*.bad.sh` examples must trigger the exact ShellCheck
codes they claim. Nushell examples must parse with `nu --ide-check`. When docs
and reality drift, the build goes red.

## Skills

| Skill | Use it for | Reference | Examples |
|-------|------------|-----------|----------|
| [shell-standards](skills/shell-standards/SKILL.md) | strict mode, quoting, arrays, traps, `printf`, `[[ ]]` | [reference](reference/shell-standards.md) | [examples](examples/standards/) |
| [bash](skills/bash/SKILL.md) | Bash error handling, arrays, macOS/BSD portability | [reference](reference/bash.md) | [examples](examples/bash/) |
| [posix-sh](skills/posix-sh/SKILL.md) | real `/bin/sh`, dash, no arrays, no bashisms | [reference](reference/posix-sh.md) | [examples](examples/posix-sh/) |
| [zsh](skills/zsh/SKILL.md) | zsh functions, options, globbing, no-fork performance | [reference](reference/zsh.md) | prose |
| [nushell](skills/nushell/SKILL.md) | structured pipelines, parse-time config, typed commands | [reference](reference/nushell.md) | [examples](examples/nushell/) |
| [shebang](skills/shebang/SKILL.md) | `env`, `env -S`, interpreter paths, dialect choice | [reference](reference/shebang.md) | [examples](examples/shebang/) |
| [streams](skills/streams/SKILL.md) | stdin/stdout/stderr, redirection order, here-docs | [reference](reference/streams.md) | [examples](examples/streams/) |

ShellCheck and shfmt do not support zsh, so zsh guidance is prose plus
`zsh -n` syntax checking. For portable, lintable scripts, prefer Bash.

## Install

Claude Code plugin:

```text
/plugin marketplace add posidoni/shell-skill
/plugin install shell-skill@shell-skill
```

Portable skill clients:

```sh
git clone https://github.com/posidoni/shell-skill
ln -s "$PWD/shell-skill/skills/bash" "$YOUR_SKILLS_DIR/bash"
ln -s "$PWD/shell-skill/skills/shell-standards" "$YOUR_SKILLS_DIR/shell-standards"
```

Local development toolchain on macOS:

```sh
brew install shellcheck shfmt nushell bats-core go-task lefthook
task ci
task hooks
```

Linux CI installs pinned versions through
[tools/ci-install-linux.sh](tools/ci-install-linux.sh).

## Agent Surfaces

| Surface | Entry point |
|---------|-------------|
| Codex / ChatGPT Cowork | [.codex-plugin/plugin.json](.codex-plugin/plugin.json), [.agents/skills/](.agents/skills/), [.codex/config.toml](.codex/config.toml), [CHATGPT.md](CHATGPT.md) |
| Claude Code | [CLAUDE.md](CLAUDE.md), [.claude-plugin/plugin.json](.claude-plugin/plugin.json), [agents/shell-reviewer.md](agents/shell-reviewer.md) |
| GitHub Copilot | [.github/copilot-instructions.md](.github/copilot-instructions.md) |
| Serena | [.serena/project.yml](.serena/project.yml), [.serena/memories/](.serena/memories/) |
| Generic agents and crawlers | [AGENTS.md](AGENTS.md), [llms.txt](llms.txt), `skills/*/SKILL.md` |

See [REGISTRY.md](REGISTRY.md) for directory listings, ecosystem notes, and
copy-ready submission text.

## Quality Gates

```sh
task --list          # discover entrypoints
task ci             # core quality gate
task hooks          # lefthook pre-commit mirror across the repo
task ai-integrations # Codex, ChatGPT, Serena, plugin, and skill metadata
```

`task ci` runs formatting, shell linting, example checks, Nushell parsing, YAML
schema-modeline checks, AI integration checks, and the bats suite.

## Repository Map

| Path | Purpose |
|------|---------|
| `skills/` | portable Agent Skills |
| `reference/` | cited rule explanations |
| `examples/` | runnable good/bad contracts |
| `tools/`, `tests/` | verification scripts and bats tests |
| `.agents/`, `.codex-plugin/`, `.claude-plugin/` | AI provider packaging |
| `.serena/` | portable Serena project setup |
| `schemas/` | project-owned JSON Schemas |
| `REGISTRY.md` | listing drafts and discovery notes |

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) for the example contract and PR checklist.
Read [AGENTS.md](AGENTS.md) before agent-assisted edits. Security reports go
through [SECURITY.md](SECURITY.md).

## License

[MIT](LICENSE) (c) 2026 Mikhail Kuznetsov ([@posidoni](https://github.com/posidoni))

<div align="center">
<sub>Safe shell for humans and the agents that write it.</sub>
</div>
