<div align="center">

<img src="assets/logo.svg" alt="shell-skill" width="104">

# shell-skill

**A cited, test-enforced guide to writing safe, correct shell** — Bash, Zsh, POSIX `sh`, and Nushell — for humans and AI coding agents.

[Why](#why-this-exists) · [Skills](#skills) · [Quick start](#quick-start) · [Example contract](#the-example-contract) · [Use with agents](#use-it-with-ai-coding-agents) · [Contributing](#contributing)

</div>

---

## The problem

AI coding assistants now write a large share of the world's shell — and a lot of
it is quietly wrong: unquoted expansions, missing `set -euo pipefail`, `[ ]`
where `[[ ]]` belongs, real errors swallowed by a stray `|| true`. It works on
the happy path and fails silently everywhere else. And the usual advice ("quote
your variables") is folklore — unenforced, uncited, easy to skip.

**shell-skill is the antidote.** It encodes the rules as cited references,
runnable examples that CI checks, and
[Agent Skills](https://code.claude.com/docs/en/plugins) you can load into Claude,
Codex, or Copilot — so the shell your tools (and you) produce is safe by default,
not by luck.

> [!IMPORTANT]
> This repository enforces its own advice. `*.good.sh` examples must run to
> exit 0 and pass `shellcheck` + `shfmt`; `*.bad.sh` examples must trigger the
> exact ShellCheck codes they claim. If the docs drift from reality, CI goes red.

## Why this exists

- **Enforced, not asserted.** The example contract is checked in CI, so the
  guidance cannot rot without breaking the build.
- **Portable by default.** Guidance calls out macOS Bash 3.2 and BSD-vs-GNU
  differences instead of assuming Linux + GNU coreutils — and CI runs the
  suite on both Linux and macOS, so that claim is checked, not just asserted.
- **Judgment, not just syntax.** It also covers
  [when *not* to use shell](reference/meta-guidance.md) — reach for Python or Go
  before a 300-line Bash script.
- **Agent-ready.** Ships `AGENTS.md`, `CLAUDE.md`, Copilot instructions, and an
  installable Claude Code plugin so the rules travel with your tools.

## Skills

| Skill | Covers | Reference | Examples |
|-------|--------|-----------|----------|
| [shell-standards](skills/shell-standards/SKILL.md) | strict mode, quoting, `[[ ]]`, arrays, traps, error handling | [reference](reference/shell-standards.md) | [examples](examples/standards/) |
| [shebang](skills/shebang/SKILL.md) | `#!/usr/bin/env`, `env -S` flags, absolute paths, dialect | [reference](reference/shebang.md) | [examples](examples/shebang/) |
| [streams](skills/streams/SKILL.md) | stdin/stdout/stderr, `>&2`, `read -r`, redirection order, here-docs | [reference](reference/streams.md) | [examples](examples/streams/) |
| [bash](skills/bash/SKILL.md) | error handling, macOS/BSD portability, arrays, temp files | [reference](reference/bash.md) | [examples](examples/bash/) |
| [zsh](skills/zsh/SKILL.md) | word-splitting, 1-indexed arrays, `emulate`, globbing | [reference](reference/zsh.md) | prose |
| [nushell](skills/nushell/SKILL.md) | structured data, config load order, parse-time `source` | [reference](reference/nushell.md) | [examples](examples/nushell/) |

> [!NOTE]
> ShellCheck and shfmt do not support zsh, so the zsh guidance is prose only —
> itself a reason to prefer Bash for portable, lintable scripts.

## Quick start

Install the toolchain (macOS):

```sh
brew install shellcheck shfmt nushell bats-core go-task lefthook
```

<details>
<summary>Linux (pinned versions)</summary>

Use the versions CI installs — see
[`tools/ci-install-linux.sh`](tools/ci-install-linux.sh), which fetches pinned
`shfmt`, `nushell`, and `task` binaries and installs `shellcheck` + `bats` from
apt.

</details>

Then:

```sh
task            # list every entrypoint
task ci         # fmt-check, lint, examples, nushell, nushell-demo, test
task hooks      # run every git hook across the repo (lefthook)
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

| Agent | Entry point |
|-------|-------------|
| Codex, Cursor, general | [`AGENTS.md`](AGENTS.md) |
| Claude Code | [`CLAUDE.md`](CLAUDE.md), or install the plugin (below) |
| GitHub Copilot | [`.github/copilot-instructions.md`](.github/copilot-instructions.md) |

Install the Claude Code plugin:

```
/plugin marketplace add posidoni/shell-skill
/plugin install shell-skill@shell-skill
```

## Repository map

| Path | What |
|------|------|
| `skills/` | Agent Skills (`SKILL.md` per domain) |
| `reference/` | in-depth references with citations |
| `examples/` | runnable good/bad pairs |
| `tools/`, `tests/` | verification scripts and the bats suite |
| `.github/workflows/` | CI (ShellCheck, shfmt, bats, Nushell, lefthook) |
| `.claude-plugin/` | plugin + marketplace manifests |
| `Taskfile.yml` | task runner entrypoints |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the toolchain, the example contract,
and the PR checklist. Please also read the [Code of Conduct](CODE_OF_CONDUCT.md).
Security reports: [SECURITY.md](SECURITY.md). Curious how this was actually
built — the research process, the enforcement discipline? See
[ENGINEERING.md](ENGINEERING.md).

## References

The repository layout follows established Agent-Skills projects:

- [anthropics/skills](https://github.com/anthropics/skills) — the official Agent
  Skills repo; `SKILL.md` frontmatter and progressive disclosure.
- [Agent Skills specification](https://agentskills.io) — the open standard.
- [netresearch/skill-repo-skill](https://github.com/netresearch/skill-repo-skill)
  — skill-repository layout, plugin packaging, and validation.

Related projects and curated indexes of Agent Skills:
[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills),
[hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code),
[travisvn/awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills),
[ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills),
[rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit),
[VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents).

### Shell references and inspiration

The guidance draws on — and is indebted to — these sources:

- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
  and the [ShellCheck wiki](https://www.shellcheck.net/wiki/) — the backbone of
  the rules and codes.
- [Greg's Wiki — BashFAQ & BashPitfalls](https://mywiki.wooledge.org/) — the
  definitive catalogue of shell gotchas.
- [dylanaraps/pure-bash-bible](https://github.com/dylanaraps/pure-bash-bible) —
  pure-bash alternatives to external commands.
- [anordal/shellharden](https://github.com/anordal/shellharden) — a safety
  auto-corrector and its precise "what you don't need to quote" rules.
- [koalaman/shellcheck](https://github.com/koalaman/shellcheck) — one page per
  diagnostic; the model for machine-checkable rules.
- [romkatv/zsh-bench](https://github.com/romkatv/zsh-bench) &
  [Powerlevel10k](https://github.com/romkatv/powerlevel10k) — the zsh
  no-subprocess performance discipline.
- [The Nushell Book](https://www.nushell.sh/book/) — the Nushell chapters.
- Shebang mechanics: [`execve(2)`](https://man7.org/linux/man-pages/man2/execve.2.html)
  and the merged Linux doc fix by [@alurm](https://github.com/alurm).

## License

[MIT](LICENSE) © 2026 Mikhail Kuznetsov ([@posidoni](https://github.com/posidoni))

---

<div align="center">
<sub>Safe shell, for humans and the agents that write it.</sub>
</div>
