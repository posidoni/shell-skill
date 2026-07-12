#!/usr/bin/env bash
#
# ci-install-linux.sh — install the shell toolchain on a Debian/Ubuntu CI
# runner: shellcheck + bats from apt, and pinned shfmt + Nushell binaries.
# Versions come from the environment with defaults that match local dev.
set -euo pipefail

shfmt_version="${SHFMT_VERSION:-v3.13.1}"
nu_version="${NU_VERSION:-0.114.1}"
task_version="${TASK_VERSION:-v3.52.0}"
arch="x86_64"

echo "::group::apt packages (shellcheck, bats)"
sudo apt-get update -qq
sudo apt-get install -y --no-install-recommends shellcheck bats
echo "::endgroup::"

echo "::group::shfmt ${shfmt_version}"
sudo curl -fsSL \
  "https://github.com/mvdan/sh/releases/download/${shfmt_version}/shfmt_${shfmt_version}_linux_amd64" \
  -o /usr/local/bin/shfmt
sudo chmod +x /usr/local/bin/shfmt
echo "::endgroup::"

echo "::group::nushell ${nu_version}"
tarball="nu-${nu_version}-${arch}-unknown-linux-gnu.tar.gz"
tmp=$(mktemp -d)
curl -fsSL \
  "https://github.com/nushell/nushell/releases/download/${nu_version}/${tarball}" \
  -o "${tmp}/nu.tar.gz"
tar -xzf "${tmp}/nu.tar.gz" -C "${tmp}" --strip-components=1
sudo install "${tmp}/nu" /usr/local/bin/nu
rm -rf "${tmp}"
echo "::endgroup::"

echo "::group::task ${task_version}"
tmp=$(mktemp -d)
curl -fsSL \
  "https://github.com/go-task/task/releases/download/${task_version}/task_linux_amd64.tar.gz" \
  -o "${tmp}/task.tar.gz"
tar -xzf "${tmp}/task.tar.gz" -C "${tmp}" task
sudo install "${tmp}/task" /usr/local/bin/task
rm -rf "${tmp}"
echo "::endgroup::"

echo "Installed toolchain:"
shellcheck --version
shfmt --version
nu --version
bats --version
task --version
