#!/bin/sh
dotfiles_help() {
  cat <<HELP
  $(basename $0) -- dotfiles management system

SYNOPSIS:
  $(basename $0) link <path/to/script.sh>

Usage:

This script can run only at "~/.dotfiles"

    > dotfiles link bash/foo.sh
    ✔ create bin/foo -> bash/foo.sh

HELP
}

export DOT_DIR="$HOME/.dotfiles/bash/dotfiles"

function include {
  for file in $@; do
    test -f "$file" && source "$file"
  done
}

include "$DOT_DIR/common.sh"
include "$DOT_DIR/cmd/*.sh"

SUBCOMMAND=""
ARGS=()
while [ $# -gt 0 ]
do
  case "$1" in
  --help)
    dotfiles_help
    exit 0
    ;;
  --version|-v)
    dotfiles_version
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

test "$SUBCOMMAND" = ""  && dotfiles_help && exit 0

if ! [[ "$PWD" = "$HOME/.dotfiles" ]]; then
  echo "$(basename $0) can run only at \"~/.dotfiles\""
  echo 'Before run this, type following.'
  echo '    cd ~/.dotfiles'
  echo
  exit 1
fi

# invoke_subcommand <subcommand> <args...>
#
# invoke function which is composed of dotfiles_subcommandname
function invoke_subcommand {
  local SUBCOMMAND="${@:1:1}"
  local ARGS=( "${@:2}" )
  local ACTION="dotfiles_${SUBCOMMAND:-help}"
  if type "$ACTION" &>/dev/null; then
    "$ACTION" "${ARGS[@]}"
  else
    echo "unknown command: $SUBCOMMAND"
    exit 1
  fi
}

invoke_subcommand "$SUBCOMMAND" "${ARGS[@]}"
