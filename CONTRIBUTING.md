# Contributing

Thanks for your interest in improving **shell-skill**. This repository teaches
safe, correct shell through rules, runnable examples, and AI-agent skills. Every
contribution is expected to hold that same bar: correct, safe, portable, and
verified by the toolchain before it lands.

## Toolchain

You need six tools. They are the same ones CI uses.

| Tool | Purpose |
|------|---------|
| [ShellCheck](https://www.shellcheck.net/) | static analysis for shell |
| [shfmt](https://github.com/mvdan/sh) | formatting (config in `.editorconfig`) |
| [Nushell](https://www.nushell.sh/) (`nu`) | static-checking `*.nu` examples |
| [bats](https://github.com/bats-core/bats-core) | behavioural tests |
| [Task](https://taskfile.dev) | task runner (the project entrypoint) |
| [pre-commit](https://pre-commit.com/) | git hooks that mirror CI |

**macOS (Homebrew):**

```sh
brew install shellcheck shfmt nushell bats-core go-task pre-commit
```

**Linux:** the pinned versions CI installs are in
[`tools/ci-install-linux.sh`](tools/ci-install-linux.sh); run it or copy the
commands.

Then install the git hooks once:

```sh
pre-commit install
```

## The task runner

This project uses **Task**, not Make. Run `task` (or `task --list`) to see every
entrypoint. The important ones:

```sh
task fmt        # format all shell scripts in place (shfmt -w)
task ci         # everything CI runs: fmt-check, lint, examples, nushell, nushell-demo, test
task hooks      # run every pre-commit hook across the repo
```

Why Task over Make? Task is a single, statically-linked Go binary that behaves
identically on Linux and macOS (GNU Make and BSD Make do not), uses plain YAML
with no tab-versus-space recipe trap, is self-documenting through `task --list`,
and drops the `.PHONY` and `$$`-escaping bookkeeping that Makefiles accumulate.
See <https://taskfile.dev>.

## The example contract

Examples live in `examples/<domain>/` as **paired** files plus a per-domain
`README.md`:

- **`NN-slug.good.sh`** — the correct pattern. It must be self-contained, take no
  arguments, run to completion with **exit 0**, and be clean under
  `shellcheck --severity=warning` and `shfmt`. Use `mktemp` + a `trap` for any
  filesystem work. The behavioural suite (`tests/examples.bats`) runs every
  `*.good.sh`.
- **`NN-slug.bad.sh`** — the anti-pattern, and it must be **safe to run** (it
  demonstrates incorrectness, never danger). It carries exactly one directive:
  - `# expect-shellcheck: SC2086 SC2250` — ShellCheck codes that MUST be
    reported, or
  - `# expect-shellcheck: none` — a style-guide-only pitfall ShellCheck cannot
    catch.

  `tools/check-bad-examples.sh` turns "does ShellCheck catch it?" into a tested
  claim. Note that `shfmt` rewrites some anti-patterns automatically (e.g. legacy
  backticks → `$(...)`), so those pitfalls live in prose, not in a `*.bad.sh`.

Nushell examples are `*.nu` and must pass `nu --ide-check` cleanly; demonstrate
runtime good/bad behaviour in the file or its README, not via the linter.

## Before you open a pull request

1. `task ci` is green.
2. `task hooks` is green (`pre-commit run --all-files`).
3. New example scripts are executable (`chmod +x`) and paired.
4. Commits follow [Conventional Commits](https://www.conventionalcommits.org/)
   (`feat:`, `fix:`, `docs:`, `test:`, `chore:`, `build:`, `ci:`).
5. No personal data, secrets, or machine-specific paths anywhere.

## Reporting problems

Open an issue for a bug or a suggestion. For anything security-sensitive, follow
[SECURITY.md](SECURITY.md) instead of filing a public issue.
