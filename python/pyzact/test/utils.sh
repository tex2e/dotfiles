#!/bin/bash

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
