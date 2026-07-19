# Contributing

Thanks for your interest in improving **Shell Skill Kit**. This repository teaches
safe, correct shell through rules, runnable examples, and AI-agent skills. Every
contribution is expected to hold that same bar: correct, safe, portable, and
verified by the toolchain before it lands.

## Toolchain

You need six tools. Hosted CI installs them on Ubuntu; macOS developers can use
the Homebrew command below for the same local gate.

| Tool | Purpose |
|------|---------|
| [ShellCheck](https://www.shellcheck.net/) | static analysis for shell |
| [shfmt](https://github.com/mvdan/sh) | formatting (config in `.editorconfig`) |
| [Nushell](https://www.nushell.sh/) (`nu`) | static-checking `*.nu` examples |
| [bats](https://github.com/bats-core/bats-core) | behavioural tests |
| [Task](https://taskfile.dev) | task runner (the project entrypoint) |
| [Lefthook](https://lefthook.dev) | git hooks that mirror CI (a single Go binary) |

**macOS (Homebrew):**

```sh
brew install shellcheck shfmt nushell bats-core go-task lefthook
```

**Linux:** the pinned versions CI installs are in
[`tools/ci-install-linux.sh`](tools/ci-install-linux.sh); run it or copy the
commands.

Hosted CI runs one lean Ubuntu quality gate plus the full hook mirror. macOS
portability still matters: run the Homebrew toolchain locally before touching
Darwin-sensitive examples or reference text. The helper remains in
[`tools/ci-install-macos.sh`](tools/ci-install-macos.sh) because Bash, shfmt, and
ShellCheck can differ across macOS and Linux; we just do not spend hosted macOS
minutes on every PR.

Then install the git hooks once:

```sh
lefthook install
```

## The task runner

This project uses **Task**, not Make. Run `task` (or `task --list`) to see every
entrypoint. The important ones:

```sh
task fmt        # format all shell scripts in place (shfmt -w)
task ci         # core quality gate: fmt-check, lint, examples, nushell, nushell-demo, yaml-schemas, ai-integrations, test
task hooks      # run every git hook across the repo (lefthook)
task yaml-schemas # verify tracked YAML-like files declare a JSON schema
task ai-integrations # verify Codex/ChatGPT/plugin discovery surfaces
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
2. `task hooks` is green (`lefthook run pre-commit --all-files`).
3. New example scripts are executable (`chmod +x`) and paired.
4. Commits follow [Conventional Commits](https://www.conventionalcommits.org/)
   (`feat:`, `fix:`, `docs:`, `test:`, `chore:`, `build:`, `ci:`).
5. No personal data, secrets, or machine-specific paths anywhere.
6. Every tracked YAML-like file (`*.yml`, `*.yaml`, `*.cff`) has a
   `yaml-language-server` JSON Schema modeline.
7. `task ai-integrations` is green after changing skills, plugin manifests,
   `.agents/`, `.codex/`, `CHATGPT.md`, or `llms.txt`.

## Reporting problems

Open an issue for a bug or a suggestion. For anything security-sensitive, follow
[SECURITY.md](SECURITY.md) instead of filing a public issue.
