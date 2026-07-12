# Engineering notes

How this repository was actually built — for anyone curious about the process,
not just the output.

## Enforcement-first, not asserted

The organizing idea is that shell advice is usually folklore: unenforced, easy
to skip, quietly drifting from reality. Every rule here ships as a runnable
example CI checks on every push:

- `*.good.sh` must run to exit 0 with no arguments and pass
  `shellcheck --severity=warning` and `shfmt`.
- `*.bad.sh` must be safe to run and must trigger the exact ShellCheck code it
  declares — [`tools/check-bad-examples.sh`](tools/check-bad-examples.sh) turns
  "does the linter actually catch this?" into a tested claim instead of an
  assertion.
- `*.nu` must pass `nu --ide-check` cleanly.

If a rule and the code disagree, the build goes red. See
[CONTRIBUTING.md](CONTRIBUTING.md#the-example-contract) for the full contract.

## Built with multi-agent research, not memory

Several domains needed depth beyond what a single pass could responsibly
assert — the correctness bar here is "cite it or don't write it." Rather than
writing from recall, this repo's content was produced by dispatching parallel
research agents against primary sources, each required to cite a URL and
paraphrase rather than copy:

- The Nushell parse-time/runtime model and its config load order came from a
  fan-out over the official [Nushell Book](https://www.nushell.sh/book/) and
  release notes.
- The zsh performance section — including *why* `$TTY` is correct and
  `$(tty)` is not (fork cost, and `tty(1)` inspecting fd 0 rather than the
  shell's controlling terminal) — came from a targeted pass over
  [romkatv](https://github.com/romkatv)'s `zsh-bench` and `Powerlevel10k`.
- The shebang mechanics (the kernel's single-argument rule behind `env -S`,
  the `BINPRM_BUF_SIZE` truncation limit) came from `execve(2)` and the GNU
  `env` manual, plus a merged Linux kernel documentation fix by
  [@alurm](https://github.com/alurm).
- The `printf`-over-`echo` and stream-handling rules came from a research pass
  that also caught the repo's *own* tooling using `echo` — which was then
  rewritten to `printf` throughout, so the rule and the practice agree.

Every one of these went through an adversarial review pass (technical
accuracy, docs quality, publish-safety) before being committed — one finding
from that pass corrected an overclaim in the standards reference about which
ShellCheck severity actually enforces which rule.

## Iterative, checkpointed, never committed red

The repo was developed incrementally: each change is scoped to one concern,
verified locally (`task ci` and `task hooks` both green) before it is
committed, and pushed only once proven. Nothing here was committed on faith
that CI would catch it later — CI is the backstop, not the first check.

## Transparent about how it was made

Every commit keeps its `Co-Authored-By: Claude` trailer, by choice, rather
than being scrubbed for appearance — an accurate record beats a flattering
one. The scope, structure, and every publish decision were the maintainer's
calls throughout, including a hard boundary the agent respected without
exception: it could prepare, verify, and stage everything, but the decision to
make the repository public was never its call to make.

## Result

Six enforced skill domains, a CI-checked example contract, cross-platform
verification (Linux and macOS), and a written history where the claims and the
mechanism that checks them live in the same repository.
