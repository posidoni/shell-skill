# Security Policy

## Scope

This repository teaches safe shell. Its examples are written to be **safe to
run**: `*.good.sh` files are hermetic (they use `mktemp` and clean up after
themselves), and `*.bad.sh` files demonstrate incorrectness, never destructive
behaviour. The most relevant "vulnerability" here is therefore a **wrong or
unsafe example** — a `*.good.sh` that is not actually safe, or a `*.bad.sh` that
could damage a system when run. Reports of those are very welcome.

## Supported versions

Development is trunk-based; the `main` branch is the supported version. Fixes
land on `main`.

## Reporting a vulnerability

Please do **not** open a public issue for a security-sensitive report.

Use GitHub's private vulnerability reporting: go to the repository's **Security**
tab → **Report a vulnerability**. This opens a private advisory visible only to
the maintainer.

Include: the file or command involved, what happens, and how to reproduce it.
You can expect an initial response within a few days.
