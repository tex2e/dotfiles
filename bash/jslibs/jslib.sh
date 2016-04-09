#!/bin/bash
# js library downloading tool

export JSLIB_DIR="$HOME/.dotfiles/bash/jslibs"
export JSLIB_SETTINGS_YAML="$JSLIB_DIR/settings.yaml"

function require {
  for file in $@; do
    test -f "$file" && source "$file"
  done
}

require "$JSLIB_DIR/cmd/*.sh"

# --- parse arguments ---

SUBCOMMAND=""
INITIAL_ARGS=( "$@" )
ARGS=()
while [ $# -gt 0 ]
do
  case "$1" in
  --help)
    jslib-help
    exit 0
    ;;
  --version|-v)
    jslib-version
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

# invoke-subcommand <subcommand> <args...>
#
# execute function "jslib-$SUBCOMMAND"
# error if subcommand function is not found
function invoke-subcommand {
  local SUBCOMMAND="${@:1:1}"
  local ARGS=( "${@:2}" )
  local ACTION="jslib-${SUBCOMMAND:-help}"
  if type "$ACTION" &>/dev/null; then
    "$ACTION" "${ARGS[@]}"
  else
    echo "unknown command: $SUBCOMMAND"
    exit 1
  fi
}

invoke-subcommand "$SUBCOMMAND" "${ARGS[@]}"
