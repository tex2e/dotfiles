#!/bin/bash
#:readme:
#
# ## jslib(1) -- javascript library install tool via shell script
#
# [code](jslibs/jslib.sh)
#
# ### SYNOPSIS
#
#     jslib install <library>
#
# ### Usage
#
# `jslib` downloads a specified javascript library.
#
#     > jslib install jquery
#     install to path/to/dir/jquery-2.2.1.min.js
#
# if current directory has `js/lib/` or `javascript/lib/` directory, downloads to there.
#
#     > tree
#     .
#     └── javascript/
#         └── lib/
#
#     > jslib install jquery
#     install to path/to/dir/javascript/lib/jquery-2.2.1.min.js
#
# ### settings
#
# `bash/jslibs/settings.yml` has javascript library URLs.
#
#     lib:
#       jquery: http://code.jquery.com/jquery-2.2.1.min.js
#       underscore: http://underscorejs.org/underscore-min.js
#

export JSLIB_DIR="$HOME/.dotfiles/bash/jslibs"
export JSLIB_SETTINGS_YAML="$JSLIB_DIR/settings.yml"

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
