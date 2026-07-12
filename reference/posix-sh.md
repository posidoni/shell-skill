# POSIX sh

Guidance for scripts that must run under the POSIX
[Shell Command Language](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
(`/bin/sh`), not Bash. This matters more often than it looks: on Debian and
Ubuntu `/bin/sh` is `dash`, not `bash`; most container base images, install
scripts (`curl | sh`), and `#!/bin/sh` shebangs run under a strict POSIX
shell with none of Bash's extensions. A script that only ever ran under
`bash` during development can fail — or silently do the wrong thing — the
first time it runs as `/bin/sh`.

Builds on [`shell-standards.md`](shell-standards.md): quoting, `set -e`, and
avoiding `|| true` all still apply. This page covers where POSIX sh
*diverges* from Bash. Snippets cite [ShellCheck](https://www.shellcheck.net/)
codes from the `SC3xxx` range, which fire specifically when linting with
`--shell=sh` (ShellCheck infers this automatically from a `#!/bin/sh`
shebang).

## Strict mode has one less flag

`set -o pipefail` is a Bash/ksh/zsh extension — POSIX sh (including `dash`)
does not have it. POSIX-portable strict mode is:

```sh
#!/bin/sh
set -eu
```

Without `pipefail`, a pipeline's exit status is only its last stage's. If a
failure in an earlier stage matters, check it explicitly instead of relying
on the pipeline as a whole:

```sh
# a failure in `producer` is invisible here — only consumer's exit status counts
producer | consumer

# check what you need to check
producer > tmp.out || { printf 'producer failed\n' >&2; exit 1; }
consumer < tmp.out
```

## No `local` — `SC3043`

`local` is not in POSIX; it is a widely-supported extension (`dash`, `ash`,
most `ksh` variants, and `bash --posix` all accept it), but a strictly
conforming `/bin/sh` is not guaranteed to. The portable way to keep a
function's working variables from leaking into the caller is to run the
function inside a subshell and communicate through its output — which
command substitution already does for you:

```sh
# bad — SC3043
double() {
  local n
  n=$1
  echo $((n * 2))
}

# good — the $( ) subshell already isolates `n`; no leak, no `local` needed
double() {
  n=$1
  echo $((n * 2))
}
result=$(double 21)
```

See [`examples/posix-sh/01-no-local`](../examples/posix-sh/01-no-local.good.sh).

## No arrays — `SC3030`/`SC3054`

POSIX sh has no array type, indexed or associative. `arr=(a b c)` and
`${arr[0]}` are both bash/ksh/zsh-only syntax. The positional parameters
(`$@`, `set -- ...`) are the POSIX-portable stand-in for an unindexed list:

```sh
# bad — SC3030 (declaration), SC3054 (reference)
fruits=(apple "ripe banana" cherry)
printf '%s\n' "${fruits[0]}"

# good — set -- rebuilds the positional parameters; "$@" preserves each word
set -- apple "ripe banana" cherry
for fruit in "$@"; do
  printf '%s\n' "$fruit"
done
```

This does mean you only get *one* list per scope (there is only one `$@`).
For genuinely multiple lists, a common POSIX-safe pattern is a
newline-delimited string read with `IFS`, or — if the data is structured
enough to need real arrays — reconsider whether the script should be POSIX
sh at all (see [`meta-guidance.md`](meta-guidance.md)).

See [`examples/posix-sh/02-positional-params-not-arrays`](../examples/posix-sh/02-positional-params-not-arrays.good.sh).

## `[ ]`, never `[[ ]]` — `SC3010`/`SC3014`

`[[ ]]` is a bash/ksh/zsh keyword. POSIX sh only has `[ ]` (the `test`
command). Its operands still split and glob like any other command's, so
quoting matters *more* here, not less — and POSIX `[ ]` only has a single
`=` for string equality, not `==`:

```sh
# bad — SC3010 ([[ ]] undefined), SC3014 (== undefined)
if [[ $answer == yes ]]; then

# good
if [ "$answer" = yes ]; then
```

See [`examples/posix-sh/03-test-not-double-bracket`](../examples/posix-sh/03-test-not-double-bracket.good.sh).

## Other common bashisms to know

Not every bashism has a runnable pair here, but ShellCheck's `--shell=sh`
catches all of these too:

- **`source file` → `. file`** — `source` is a bash/zsh alias for the POSIX
  `.` builtin ([`SC3046`](https://www.shellcheck.net/wiki/SC3046)).
- **`function name { ... }` → `name() { ... }`** — the `function` keyword is
  a bash/ksh/zsh extension; POSIX only defines the `name()` form
  ([`SC3045`](https://www.shellcheck.net/wiki/SC3045)).
- **`echo -e`/`echo -n`** — POSIX `echo`'s flag and backslash handling is
  unspecified and varies by shell; use `printf` (see
  [`shell-standards.md`](shell-standards.md#12-print-with-printf-not-echo--sc2028sc2059),
  which already covers this for Bash too).
- **`$RANDOM`, `((...))` arithmetic, `+=`** — all bash/ksh/zsh extensions;
  POSIX arithmetic is `$((...))` (which *is* portable) without the bare
  `((...))` command form.

## Verify

```sh
shellcheck --shell=sh script.sh   # inferred automatically from #!/bin/sh
shfmt -d script.sh                # also infers the dialect from the shebang
```

`task ci` runs both across [`examples/posix-sh/`](../examples/posix-sh/); the
`*.bad.sh` files there are excluded from the shfmt gate specifically because
some of these anti-patterns (arrays) are not just bad style but invalid
POSIX syntax that shfmt cannot parse in POSIX mode — see
`tools/format-check.sh`.

## Sources

- [POSIX.1-2017, Shell Command Language](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
  — the normative spec.
- [ShellCheck wiki, `SC3xxx` series](https://www.shellcheck.net/wiki/) —
  one page per POSIX-portability diagnostic.
- [Greg's Wiki — Bashism](https://mywiki.wooledge.org/Bashism) — a curated
  catalogue of bash-only constructs that break under real `/bin/sh`.

See `skills/posix-sh/SKILL.md` for the agent-facing summary and
`examples/posix-sh/` for a runnable good/bad pair per rule with a ShellCheck
code.
