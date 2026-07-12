# shell-skill

A cited, test-enforced guide to writing **safe, correct shell** — Bash, Zsh,
POSIX `sh`, and Nushell — for humans and AI coding agents.

[![CI](https://github.com/posidoni/shell-skill/actions/workflows/ci.yml/badge.svg)](https://github.com/posidoni/shell-skill/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Most shell advice is folklore. This repository turns it into something you can
*check*: every rule has a rationale and a citation, every "do this" ships as a
runnable example that must pass in CI, and every "not this" is a safe example
whose ShellCheck code is asserted. The same content is packaged as
[Agent Skills](https://code.claude.com/docs/en/plugins) so an AI assistant can
load it on demand.

## Why this exists

- **Enforced, not asserted.** `*.good.sh` examples must run to exit 0 and pass
  `shellcheck` + `shfmt`; `*.bad.sh` examples must trigger the exact ShellCheck
  codes they claim. If the docs drift from reality, CI goes red.
- **Portable by default.** Guidance calls out macOS Bash 3.2 and BSD-vs-GNU
  differences instead of assuming Linux + GNU coreutils.
- **Agent-ready.** Ships `AGENTS.md`, `CLAUDE.md`, Copilot instructions, and an
  installable Claude Code plugin so the rules travel with your tools.

## Skills

| Skill | Covers | Reference | Examples |
|-------|--------|-----------|----------|
| [shell-standards](skills/shell-standards/SKILL.md) | strict mode, quoting, `[[ ]]`, arrays, traps, error handling | [reference](reference/shell-standards.md) | [examples](examples/standards/) |
| [bash](skills/bash/SKILL.md) | error handling, macOS/BSD portability, arrays, temp files | [reference](reference/bash.md) | [examples](examples/bash/) |
| [zsh](skills/zsh/SKILL.md) | word-splitting, 1-indexed arrays, `emulate`, globbing | [reference](reference/zsh.md) | prose only\* |
| [nushell](skills/nushell/SKILL.md) | structured data, config load order, parse-time `source` | [reference](reference/nushell.md) | [examples](examples/nushell/) |

\* ShellCheck and shfmt don't support zsh, so zsh guidance is prose — itself a
reason to prefer Bash for portable, lintable scripts.

## Quick start

Install the toolchain (macOS):

```sh
brew install shellcheck shfmt nushell bats-core go-task pre-commit
```

On Linux, use the pinned versions in
[`tools/ci-install-linux.sh`](tools/ci-install-linux.sh). Then:

```sh
task            # list every entrypoint
task ci         # fmt-check, lint, examples, nushell, nushell-demo, test
task hooks      # run pre-commit across the repo
```

This project uses [Task](https://taskfile.dev), not Make — a single
cross-platform binary with plain-YAML, self-documenting tasks. See
[CONTRIBUTING.md](CONTRIBUTING.md) for the rationale.

## The example contract

Examples live in `examples/<domain>/` as paired files:

- **`NN-slug.good.sh`** — the correct pattern; self-contained, no arguments,
  exits 0, clean under `shellcheck --severity=warning` and `shfmt`.
- **`NN-slug.bad.sh`** — a safe-to-run anti-pattern carrying one directive:
  `# expect-shellcheck: SC####` (codes ShellCheck must report) or
  `# expect-shellcheck: none` (a style-guide-only pitfall).

Nushell examples are `*.nu`, verified with `nu --ide-check`.

## Use it with AI coding agents

- **Codex / Cursor / general:** [`AGENTS.md`](AGENTS.md)
- **Claude Code:** [`CLAUDE.md`](CLAUDE.md), or install the plugin:

  ```
  /plugin marketplace add posidoni/shell-skill
  /plugin install shell-skill@shell-skill
  ```

- **GitHub Copilot:** [`.github/copilot-instructions.md`](.github/copilot-instructions.md)

## Repository map

| Path | What |
|------|------|
| `skills/` | Agent Skills (`SKILL.md` per domain) |
| `reference/` | in-depth references with citations |
| `examples/` | runnable good/bad pairs |
| `tools/`, `tests/` | verification scripts and the bats suite |
| `.github/workflows/` | CI (ShellCheck, shfmt, bats, Nushell, pre-commit) |
| `.claude-plugin/` | plugin + marketplace manifests |
| `Taskfile.yml` | task runner entrypoints |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the toolchain, the example contract,
and the PR checklist. Please also read the [Code of Conduct](CODE_OF_CONDUCT.md).
Security reports: [SECURITY.md](SECURITY.md).

## References

The repository layout follows established Agent-Skills projects:

- [anthropics/skills](https://github.com/anthropics/skills) — the official Agent
  Skills repo; `SKILL.md` frontmatter and progressive disclosure.
- [Agent Skills specification](https://agentskills.io) — the open standard.
- [netresearch/skill-repo-skill](https://github.com/netresearch/skill-repo-skill)
  — skill-repository layout, plugin packaging, and validation.

Related projects and curated indexes of Agent Skills, worth a look:
[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills),
[hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code),
[travisvn/awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills),
[ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills),
[rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit),
[VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents),
[VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills).

Standards cite the
[Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
and [ShellCheck](https://www.shellcheck.net/wiki/).

## License

[MIT](LICENSE) © 2026 Mikhail Kuznetsov ([@posidoni](https://github.com/posidoni))
