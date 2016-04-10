#!/bin/sh

function scriptname_help {
  cat <<HELP
  $(basename $0) -- {one sentence description}

SYNOPSIS:
  $(basename $0) [-h|--help]
  $(basename $0) [--verbose]

Usage:

HELP
}

function scriptname_version {
  echo "Script Name Version 1.0.0 (20xx-01-01)"
  echo "Copyright (C) $(date +%Y) TeX2e."
}

function warn {
  # color:yellow
  echo -e "\033[33mWarning:\033[m" "$*"
}

function error {
  # color:red
  echo -e "\033[31mError:\033[m" "$*"
}

function success {
  # color:green
  printf " \033[32m✔ \033[m%s\n" "$*"
}

function fail {
  # color:red
  printf " \003[31m✘ \033[m%s\n" "$*"
}

function include {
  for file in $@; do
    test -f "$file" && source "$file"
  done
}

SUBCOMMAND=""
ARGS=()
while [ $# -gt 0 ]
do
  case "$1" in
  --help)
    scriptname_help
    exit 0
    ;;
  --version|-v)
    scriptname_version
    exit 0
    ;;
  *)
    if [ -z "$SUBCOMMAND" ]; then
      SUBCOMMAND="$1"
    else
      ARGS+=( "$1" )
    fi
    shift
    ;;
  esac
done

if [[ "$SUBCOMMAND" = "" ]]; then
  scriptname_help
  exit 0
fi

# invoke_subcommand <subcommand> <args...>
#
# invoke function which is composed of scriptname_subcommandname
function invoke_subcommand {
  local SUBCOMMAND="${@:1:1}"
  local ARGS=( "${@:2}" )
  local ACTION="scriptname_${SUBCOMMAND:-help}"
  if type "$ACTION" &>/dev/null; then
    "$ACTION" "${ARGS[@]}"
  else
    echo "unknown command: $SUBCOMMAND"
    exit 1
  fi
}

invoke_subcommand "$SUBCOMMAND" "${ARGS[@]}"
