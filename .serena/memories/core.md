# Core

- Public product name: Shell Skill Kit; package/repo/plugin id remains `shell-skill`.
- Purpose: cited, test-enforced Agent Skills for safe shell generation/review across Bash, Zsh, POSIX `sh`, Nushell, shebangs, and streams.
- Source map: `skills/<domain>/SKILL.md` are portable skill entrypoints; `reference/*.md` holds cited depth; `examples/<domain>/` holds runnable good/bad pairs; `tools/` + `tests/` enforce the contract.
- Agent packaging: Claude Code manifest in `.claude-plugin/plugin.json`; Codex manifest in `.codex-plugin/plugin.json`; repo-scope Codex discovery in `.agents/skills`; trusted Codex defaults in `.codex/config.toml`; ChatGPT/Codex notes in `CHATGPT.md`; crawler index in `llms.txt`; OpenAI UI metadata in `skills/*/agents/openai.yaml`.
- Registry prep: `REGISTRY.md` explains discovery surfaces; `registry/agenticskills-submission.md` and `registry/awesome-codex-plugins-listing.md` are copy-ready drafts; live submission still needs maintainer email / opt-in scanner gate.
- Integration gate: `task ai-integrations` validates Codex, ChatGPT, Serena, plugin, and repo-scope skill discovery surfaces.
- Read `mem:tech_stack` for tools and pins, `mem:conventions` for editing rules, and `mem:task_completion` for the done gate.
