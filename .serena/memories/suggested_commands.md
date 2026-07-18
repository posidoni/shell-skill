# Suggested Commands

- Discover commands: `task --list`.
- Format shell scripts: `task fmt`.
- Full local/CI quality gate: `task ci`.
- Pre-commit mirror across repo: `task hooks`.
- YAML schema modeline gate: `task yaml-schemas`.
- AI integration metadata gate: `task ai-integrations`.
- Individual gates: `task fmt-check`, `task lint`, `task examples`, `task nushell`, `task nushell-demo`, `task test`.
- Validate Codex plugin manifest after editing `.codex-plugin/plugin.json`: run the active Codex `plugin-creator` validator through `uv run --with PyYAML python <validator> .` when available.
- Validate skill frontmatter after editing `skills/*/SKILL.md`: run the active Codex `skill-creator` validator through `uv run --with PyYAML python <validator> skills/<skill>` when available.
- Darwin note: local shell tool paths are Homebrew-friendly; avoid GNU-only assumptions in examples unless explicitly guarded.
