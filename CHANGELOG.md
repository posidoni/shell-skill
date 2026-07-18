# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project aims to
follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Changed

- Tightened the README into a lighter product overview and moved registry and
  ecosystem details into `REGISTRY.md`.
- Hid `.agents/skills` symlink duplicates from `rg` and `fd` searches while
  keeping Codex repo-scope discovery intact.
- Rebuilt the social preview around the Shell Skill Kit name and added the SVG
  source asset.

## [0.2.0] - 2026-07-18

### Added

- Codex plugin manifest at `.codex-plugin/plugin.json`, with public UI metadata
  for Shell Skill Kit.
- ChatGPT/Codex companion instructions in `CHATGPT.md`, crawler-friendly
  discovery in `llms.txt`, and `agents/openai.yaml` metadata for every skill.
- Codex repo-scope skill symlinks in `.agents/skills/`, trusted Codex defaults
  in `.codex/config.toml`, and portable Serena setup in `.serena/`.
- Registry submission drafts for AgenticSkills and Awesome Codex Plugins.
- JSON Schema modelines for tracked YAML-like files plus `task yaml-schemas` and
  `task ai-integrations` gates that enforce the agent metadata contract.

### Changed

- Repositioned the project publicly as **Shell Skill Kit** while keeping the
  package/repo name `shell-skill`.
- Simplified hosted GitHub Actions to one Ubuntu quality gate that runs
  `task ci` plus the hook mirror; macOS verification remains documented as a
  local maintainer check.
- Updated Claude plugin metadata, citation metadata, README, contributing docs,
  and agent instructions for the 0.2.0 release.

### Removed

- Automatic GitHub release workflow; releases are now cut manually from tags.

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

[Unreleased]: https://github.com/posidoni/shell-skill/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/posidoni/shell-skill/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/posidoni/shell-skill/releases/tag/v0.1.0
