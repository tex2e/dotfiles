#!/bin/bash

function SCRIPTNAME_help {
  cat <<HELP
Usage: $(basename $0) [-h|--help]
HELP
}

function SCRIPTNAME_version {
  echo "Script Name Version 1.0.0 (20xx-01-01)"
  echo "Copyright (C) $(date +%Y) TeX2e."
}

function warn {
  echo -e "\033[33mWarning:\033[m" "$*"
}
function error {
  echo -e "\033[31mError:\033[m" "$*"
}
function success {
  printf " \033[32m✔ \033[m%s\n" "$*"
}
function fail {
  printf " \003[31m✘ \033[m%s\n" "$*"
}

function include {
  for file in $@; do
    test -f "$file" && source "$file"
  done
}

SUBCOMMAND=""
ARGS=()
while [[ $# -gt 0 ]]
do
  case "$1" in
  --help)
    SCRIPTNAME_help
    exit 0
    ;;
  --version|-v)
    SCRIPTNAME_version
    exit 0
    ;;
  *)
    if [[ -z "$SUBCOMMAND" ]]; then
      SUBCOMMAND="$1"
    else
      ARGS+=( "$1" )
    fi
    shift
    ;;
  esac
done

if [[ "$SUBCOMMAND" = "" ]]; then
  SCRIPTNAME_help
  exit 0
fi

# invoke_subcommand <subcommand> <args...>
# invoke function named SCRIPTNAME_subcommand
function invoke_subcommand {
  local SUBCOMMAND="${@:1:1}"
  local ARGS=( "${@:2}" )
  local ACTION="SCRIPTNAME_${SUBCOMMAND:-help}"
  if type "$ACTION" &>/dev/null; then
    "$ACTION" "${ARGS[@]}"
  else
    error "unknown command: $SUBCOMMAND"
    exit 1
  fi
}

invoke_subcommand "$SUBCOMMAND" "${ARGS[@]}"
