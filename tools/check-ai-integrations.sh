#!/usr/bin/env bash
set -euo pipefail

status=0

fail() {
  printf 'ai-integrations: %s\n' "$1" >&2
  status=1
}

require_file() {
  if [[ ! -f $1 ]]; then
    fail "missing file: $1"
  fi
}

require_dir() {
  if [[ ! -d $1 ]]; then
    fail "missing directory: $1"
  fi
}

require_file ".codex-plugin/plugin.json"
require_file ".claude-plugin/plugin.json"
require_file ".codex/config.toml"
require_file ".serena/project.yml"
require_file "CHATGPT.md"
require_file "llms.txt"
require_file "schemas/codex-plugin.schema.json"
require_file "schemas/openai-skill-metadata.schema.json"
require_file "schemas/serena-project.schema.json"
require_dir ".agents/skills"

if [[ -d .codex-plugin ]]; then
  while IFS= read -r extra_file; do
    fail ".codex-plugin must contain only plugin.json, found: $extra_file"
  done < <(find .codex-plugin -mindepth 1 -maxdepth 1 ! -name plugin.json -print)
fi

nu -c '
let p = open ".codex-plugin/plugin.json"
for key in [name version description author interface skills] {
  if (($p | get -o $key) == null) {
    error make {msg: $"missing .codex-plugin/plugin.json field: ($key)"}
  }
}
if $p.skills != "./skills/" {
  error make {msg: ".codex-plugin/plugin.json skills must be ./skills/"}
}
let i = $p.interface
for key in [displayName shortDescription longDescription developerName category capabilities defaultPrompt] {
  if (($i | get -o $key) == null) {
    error make {msg: $"missing .codex-plugin/plugin.json interface field: ($key)"}
  }
}
if (($i.capabilities | length) == 0) {
  error make {msg: ".codex-plugin/plugin.json interface.capabilities must not be empty"}
}
if (($i.defaultPrompt | describe) != "list<string>") {
  error make {msg: ".codex-plugin/plugin.json interface.defaultPrompt must be an array of strings"}
}
if (($i.defaultPrompt | length) == 0) or (($i.defaultPrompt | length) > 3) {
  error make {msg: ".codex-plugin/plugin.json interface.defaultPrompt must contain 1-3 prompts"}
}
for prompt in $i.defaultPrompt {
  if (($prompt | str trim | is-empty) or (($prompt | str length) > 128)) {
    error make {msg: ".codex-plugin/plugin.json interface.defaultPrompt entries must be non-empty and <= 128 characters"}
  }
}
' || fail "invalid Codex plugin manifest shape"

nu -c '
let c = open ".codex/config.toml"
if (($c | get -o features.multi_agent) != true) {
  error make {msg: ".codex/config.toml must set features.multi_agent = true"}
}
' || fail "invalid Codex project config"

nu -c '
let s = open ".serena/project.yml"
for key in [project_name languages encoding ignore_all_files_in_gitignore ls_workspace_folders read_only] {
  if (($s | get -o $key) == null) {
    error make {msg: $"missing .serena/project.yml field: ($key)"}
  }
}
for lang in [bash markdown json] {
  if not ($lang in $s.languages) {
    error make {msg: $"missing Serena language: ($lang)"}
  }
}
for lang in $s.languages {
  if not ($lang in [bash markdown json]) {
    error make {msg: $"unsupported noisy Serena language in this repo: ($lang)"}
  }
}
if $s.project_name != "shell-skill" {
  error make {msg: ".serena/project.yml project_name must be shell-skill"}
}
if $s.ignore_all_files_in_gitignore != true {
  error make {msg: ".serena/project.yml must respect gitignore"}
}
' || fail "invalid Serena project config"

while IFS= read -r skill_md; do
  skill_dir=${skill_md%/SKILL.md}
  skill_name=$(awk '
    $0 == "---" { fence++; next }
    fence == 1 && $1 == "name:" {
      sub(/^name:[[:space:]]*/, "", $0)
      gsub(/^["'\'']|["'\'']$/, "", $0)
      print $0
      exit
    }
  ' "$skill_md")

  if [[ -z $skill_name ]]; then
    fail "missing name frontmatter: $skill_md"
    continue
  fi

  if [[ $skill_name != "${skill_dir##*/}" ]]; then
    fail "$skill_md name must match directory (${skill_dir##*/})"
  fi

  openai_yaml="$skill_dir/agents/openai.yaml"
  require_file "$openai_yaml"

  repo_skill=".agents/skills/$skill_name"
  if [[ ! -L $repo_skill ]]; then
    fail "missing Codex repo-scope skill symlink: $repo_skill"
    continue
  fi

  if [[ $(readlink "$repo_skill") != "../../skills/$skill_name" ]]; then
    fail "$repo_skill must point to ../../skills/$skill_name"
  fi

  if [[ ! -d $repo_skill ]]; then
    fail "$repo_skill does not resolve to a skill directory"
  fi
done < <(find skills -mindepth 2 -maxdepth 2 -name SKILL.md -print | sort)

while IFS= read -r repo_skill; do
  skill_name=${repo_skill##*/}
  if [[ ! -d "skills/$skill_name" ]]; then
    fail "stale Codex repo-scope skill entry: $repo_skill"
  fi
done < <(find .agents/skills -mindepth 1 -maxdepth 1 -print | sort)

exit "$status"
