#!/bin/bash

cat <<'SHELLSCRIPT' > "${1:-a.sh}"
#!/bin/sh
usage() {
  cat <<HELP
  $(basename $0) -- {one sentence description}

SYNOPSIS:
  $(basename $0) [-h|--help]
  $(basename $0) [--verbose]

Usage:

HELP
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

SHELLSCRIPT

chmod +x "$1"
