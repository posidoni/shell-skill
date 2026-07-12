#!/bin/sh
#
# BAD: [[ ]] is a bash/ksh/zsh keyword, undefined in POSIX sh; so is '=='.
# expect-shellcheck: SC3010 SC3014
answer=yes
if [[ $answer == yes ]]; then
  printf 'proceeding\n'
fi
