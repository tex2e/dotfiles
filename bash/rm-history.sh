#!/bin/bash
#:readme:
#
# ## rm-history(1) -- Remove shell history
#
# [code](rm-history.sh)
#
# ### SYNOPSIS
#
#     rm-history [<regex>]
#
# ### Description
#
# From history,
# - Remove last command if no argument specified.
# - Remove commands mathced given regex.
#

function rm_history {
  local history_file

  case $SHELL in
    */bash )
      history_file="$HOME/.bash_history"
      ;;
    */zsh )
      history_file="$HOME/.zsh_history"
      ;;
  esac

  if [[ "$1" != "" ]]; then
    echo sed -i \"/$1/d\" \"$history_file\"
    sed -i "/$1/d" "$history_file"
  else
    echo sed -i \'\$d\' \"$history_file\"
    sed -i '$d' "$history_file"
  fi
}

rm_history $@
