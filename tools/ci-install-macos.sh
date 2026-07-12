#!/usr/bin/env bash
#
# ci-install-macos.sh — install the shell toolchain on the macOS CI runner via
# Homebrew (preinstalled on GitHub-hosted macOS runners).
#
# Unlike ci-install-linux.sh's pinned release binaries, this tracks whatever
# version Homebrew currently ships — a deliberate tradeoff. This job exists as
# a portability signal (does the repo agree with itself on both Linux and
# macOS, where Bash, shfmt, and ShellCheck genuinely behave differently — see
# reference/bash.md), not for exact-version reproducibility.
set -euo pipefail

printf '%s\n' "::group::brew packages"
brew install shellcheck shfmt nushell bats-core go-task lefthook
printf '%s\n' "::endgroup::"

printf '%s\n' "Installed toolchain:"
shellcheck --version
shfmt --version
nu --version
bats --version
task --version
lefthook version
