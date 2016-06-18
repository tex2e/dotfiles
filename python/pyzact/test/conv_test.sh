#!/bin/bash

SCRIPT="./conv"

function gdiff {
  local REG=`tput op`
  local GRP=`tput setaf 6`
  local ADD=`tput setaf 2`
  local REM=`tput setaf 1`

  local NL=$'\n'
  local GRP_LABEL="${GRP}@@ %df,%dn +%dF,%dN @@${REG}"

  local UNCH_GRP_FMT=''

  if [[ "${1}" == '@full' ]]; then
    UNCH_GRP_FMT="${GRP_LABEL}${NL}%="
    shift
  fi

  diff \
    --new-line-format="${ADD}+%L${REG}" \
    --old-line-format="${REM}-%L${REG}" \
    --unchanged-line-format=" %L${REG}" \
    --new-group-format="${GRP_LABEL}${NL}%>" \
    --old-group-format="${GRP_LABEL}${NL}%<" \
    --changed-group-format="${GRP_LABEL}${NL}%<%>" \
    --unchanged-group-format="${UNCH_GRP_FMT}" \
      "${@}" | less -FXR
}


cmd="seq 10 | $SCRIPT 2"
expect="\
1 2
2 3
3 4
4 5
5 6
6 7
7 8
8 9
9 10"
actual=$(eval $cmd)

echo "> $cmd"
gdiff <(echo "$expect") <(echo "$actual")


cmd="yes | awk '\$0=NR' | $SCRIPT 3 | head -5"
expect="\
1 2 3
2 3 4
3 4 5
4 5 6
5 6 7"
actual=$(eval $cmd)

echo "> $cmd"
gdiff <(echo "$expect") <(echo "$actual")
