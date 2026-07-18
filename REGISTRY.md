# Registry And Discovery

Shell Skill Kit is prepared for skill clients, plugin clients, and crawler-style
discovery without requiring a heavyweight runtime.

## Published Surfaces

| Surface | Files |
|---------|-------|
| Portable Agent Skills | `skills/*/SKILL.md` |
| Codex repo-scope skills | `.agents/skills/*` symlinks |
| Codex / ChatGPT plugin | `.codex-plugin/plugin.json` |
| Claude Code plugin | `.claude-plugin/plugin.json` |
| ChatGPT / Codex handoff | `CHATGPT.md`, `llms.txt`, `skills/*/agents/openai.yaml` |
| Serena project context | `.serena/project.yml`, `.serena/memories/*.md` |
| GitHub Copilot | `.github/copilot-instructions.md` |

## Listing Drafts

AgenticSkills:

```text
Skill Name: Shell Skill Kit
GitHub Repository URL: https://github.com/posidoni/shell-skill
Category: Code Quality & Testing
Short Description: Test-enforced shell rules for AI agents: Bash, Zsh, POSIX sh, Nushell, shebangs, streams, and examples.
Tags: shell, bash, zsh, posix-sh, nushell, shellcheck, shfmt, agent-skills, codex, claude-code, ai-coding
Author Name: Mikhail Kuznetsov
Website or Twitter: https://github.com/posidoni
Email: maintainer email required at submission time
```

Awesome Codex Plugins:

```md
- [Shell Skill Kit](https://github.com/posidoni/shell-skill) - Test-enforced Agent Skills for safe Bash, Zsh, POSIX sh, Nushell, shebangs, streams, and generated-script review. Ships portable `SKILL.md` folders plus Codex and Claude Code plugin metadata.
```

Live submission still needs the maintainer's explicit action. Keep hosted CI
lean unless a target registry requires a scanner gate for a listing PR.

## Compatibility Notes

- Keep the public product name **Shell Skill Kit**.
- Keep the stable technical id **shell-skill** for repository, plugin, and
  package references.
- Keep `SKILL.md` frontmatter minimal and portable; provider-specific UI metadata
  belongs in companion files such as `agents/openai.yaml`.
- Keep `.codex-plugin/` to `plugin.json` only. The actual skills stay in the
  top-level `skills/` directory and are referenced from the manifest.
- Keep `.agents/skills/*` as symlinks to `../../skills/*`; do not duplicate skill
  bodies for Codex repo-scope discovery.
- Keep Serena language servers limited to Bash, Markdown, and JSON until the YAML
  and TOML wrappers stop logging noisy client-configuration errors. YAML, TOML,
  and Nushell are covered by repository gates instead.

## Ecosystem References

- [Agent Skills specification](https://agentskills.io/specification)
- [AgenticSkills](https://agenticskills.io/)
- [Awesome Codex Plugins](https://github.com/hashgraph-online/awesome-codex-plugins)
- [anthropics/skills](https://github.com/anthropics/skills)
- [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)
- [travisvn/awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills)
- [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)
- [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)
