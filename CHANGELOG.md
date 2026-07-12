# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project aims to
follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.1.0] - 2026-07-13

Initial public release.

### Added

- Six skill domains, each with a cited reference, a `SKILL.md`, and runnable
  good/bad examples: **shell-standards**, **shebang**, **streams**, **bash**,
  **zsh**, **nushell** — plus a **meta-guidance** reference on when not to use
  shell.
- A CI-enforced example contract: every `*.good.sh` runs to exit 0 and passes
  ShellCheck + shfmt; every `*.bad.sh` triggers the ShellCheck code it declares;
  every `*.nu` passes `nu --ide-check`.
- [Task](https://taskfile.dev) as the entrypoint and
  [Lefthook](https://lefthook.dev) for git hooks — a fully static, Python-free
  toolchain.
- An installable Claude Code plugin (`.claude-plugin/`) exposing all six skills.
- Agent integrations: `AGENTS.md`, `CLAUDE.md`, and GitHub Copilot instructions.
- Community health files: `README`, `CONTRIBUTING`, `SECURITY`,
  `CODE_OF_CONDUCT`, issue/PR templates, and Dependabot.

[Unreleased]: https://github.com/posidoni/shell-skill/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/posidoni/shell-skill/releases/tag/v0.1.0
