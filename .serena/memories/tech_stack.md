# Tech Stack

- Primary content: Markdown skill/docs, shell examples (`*.sh`), Nushell examples (`*.nu`), JSON plugin manifests, YAML config.
- Task runner: Taskfile v3 (`Taskfile.yml`), local command entrypoint is `task`.
- Shell quality: ShellCheck, shfmt, bats-core; `.shellcheckrc` enables all optional checks, CI lint uses warning severity.
- Nushell quality: `nu --ide-check` for `*.nu`; runtime startup-order pitfall is tested through `tests/nushell-startup-demo.sh`.
- Serena LSPs: Bash, Markdown, and JSON only; YAML/TOML are intentionally validated by repository gates rather than Serena LSPs until the wrappers stop logging client-configuration errors.
- Hook runner: Lefthook (`lefthook.yml`) mirrors local pre-commit checks; hosted CI runs one lean Ubuntu job with `task ci` plus `task hooks`.
- Pinned CI installer: `tools/ci-install-linux.sh` owns Linux shfmt/nu/task/lefthook pins; `tools/ci-install-macos.sh` is kept for local Darwin parity, not hosted CI.
- Project-owned schemas: `schemas/openai-skill-metadata.schema.json`, `schemas/codex-plugin.schema.json`, and `schemas/serena-project.schema.json`; external schema modelines cover Taskfile, Lefthook, GitHub Actions, Dependabot, GitHub issue config, and CFF.
