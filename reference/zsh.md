# Zsh

Zsh is an excellent *interactive* shell, but scripting it is not "Bash with a
different prompt." The differences below bite hardest, and — importantly —
**ShellCheck and shfmt do not support zsh** (they target sh/bash/dash/ksh). That
is why this domain is prose only: a `*.good.sh` here would be run and linted as
Bash. For scripts that must be linted and portable, prefer Bash; reserve zsh for
interactive config and zsh-only features.

If you do write a zsh script, syntax-check it with `zsh -n script.zsh` and pin
behaviour with `emulate -LR zsh` (below).

## Word splitting: the big one

Bash word-splits unquoted parameter expansions; **zsh does not.** This is the
single most common cross-shell surprise.

```zsh
files="a b c"
for f in $files; do print $f; done   # zsh: ONE iteration ("a b c")
                                      # bash: THREE iterations
```

Quote anyway for clarity, and when you *want* splitting in zsh, be explicit:
`${(s: :)files}` or `${=files}`. This cuts both ways: code that relies on Bash
splitting breaks in zsh, and code written for zsh breaks when run with `sh`.

## Arrays are 1-indexed

```zsh
arr=(x y z)
print $arr[1]     # zsh: x     (bash ${arr[1]} would be y)
print ${#arr}     # 3
```

## Pin behaviour in functions with `emulate`

Options set by the user's `.zshrc` (`setopt`) leak into functions you ship. Make
a function hermetic:

```zsh
my_func() {
  emulate -LR zsh    # reset options to zsh defaults for this function only
  setopt local_options err_return
  # ...
}
```

## Subprocess-free existence checks

The `zsh/parameter` module exposes associative arrays that avoid forking a
`command -v` subshell — handy in hot paths and completion code:

```zsh
zmodload zsh/parameter
(( $+commands[git] ))     # is `git` on PATH?
(( $+functions[my_func] ))
(( $+aliases[ll] ))
```

## Globbing

Zsh globbing is powerful and enabled by default: `**/*.txt` recurses,
and glob qualifiers refine matches — e.g. `*(.)` for regular files only, and
`*(N)` (`null_glob`) to expand to nothing instead of erroring when there is no
match (the zsh answer to Bash's `shopt -s nullglob`).

## Further reading

- Zsh manual: <https://zsh.sourceforge.io/Doc/>
- `man zshexpn` (expansion), `man zshoptions` (options).

See [`skills/zsh`](../skills/zsh/) for the summary.
