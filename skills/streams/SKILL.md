---
name: streams
description: >-
  Correct use of stdin, stdout, and stderr — send diagnostics to stderr and data
  to stdout, signal failure via the exit status, read input with while IFS= read
  -r, put 2>&1 after the file redirection, and use here-docs/here-strings. Use
  when a script produces output, reads input, or redirects, or when a pipe is
  polluted by error text.
---

# Streams

fd 0 is stdin, fd 1 is stdout (data), fd 2 is stderr (diagnostics). Depth and
citations in [`reference/streams.md`](../../reference/streams.md); runnable pairs
in [`examples/streams/`](../../examples/streams/).

## Rules at a glance

| Rule | Why | Code |
|------|-----|------|
| Diagnostics and prompts to stderr (`>&2`); data to stdout | keeps stdout pipeable and parseable | review-only |
| Signal failure with a non-zero exit, not just a message | callers test the exit status | — |
| Read lines with `while IFS= read -r line` | preserves whitespace and backslashes | — |
| Don't loop over `$(cat file)` | it word-splits and globs | `SC2013` |
| `cmd >file 2>&1`, not `cmd 2>&1 >file` | `2>&1` copies stdout's target at that moment | `SC2069` |
| Quote the delimiter (`<<'EOF'`) to stop expansion | literal here-doc | — |
| Never read and write the same file in one pipeline | the target is truncated first | — |
| `$(...)` strips trailing newlines | guard with a sentinel when they matter | — |

## Note

ShellCheck catches `SC2013` and `SC2069`, but **not** a diagnostic sent to stdout
instead of stderr — that one is enforced by review. A green lint does not mean
the streams are right.
