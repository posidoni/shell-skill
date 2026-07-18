# Conventions

- Keep public branding as Shell Skill Kit; keep technical id/package/repo name `shell-skill`.
- Skill frontmatter stays minimal: only `name` and `description` unless intentionally adopting a broader Agent Skills spec field. Descriptions carry trigger logic; bodies carry procedure.
- Keep `SKILL.md` concise and operational; put detailed rationale/citations in `reference/`; avoid duplicate long explanations in skills.
- Example contract: `*.good.sh` self-contained/no args/exits 0/clean under ShellCheck + shfmt; `*.bad.sh` safe-to-run with exactly one `# expect-shellcheck:` directive; Nushell examples parse cleanly with `nu --ide-check`.
- Shell examples must be safe and portable; use `mktemp` + `trap` for filesystem work; no secrets, personal data, or machine-specific paths.
- Tracked YAML-like files (`*.yml`, `*.yaml`, `*.cff`) must start with `# yaml-language-server: $schema=...` and pass `task yaml-schemas`.
- Keep Codex repo-scope skill discovery as symlinks in `.agents/skills/* -> ../../skills/*`; never duplicate skill bodies there.
- Keep developer search lightweight by ignoring `.agents/skills/**` in `.rgignore` and `.fdignore`; canonical skill content lives under `skills/`.
- Keep Serena portable config/memories tracked, but leave `.serena/cache`, `.serena/logs`, and `.serena/project.local.yml` ignored. Serena LSPs are limited to Bash, Markdown, and JSON because current YAML/TOML wrappers pass health-check but log client-configuration errors.
- Keep GitHub automation lean: one hosted Ubuntu quality gate running `task ci` and `task hooks`; do not add scanner/release/macOS workflows unless the maintainer explicitly opts in.
