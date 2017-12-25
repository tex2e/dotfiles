#!/bin/bash -u

# dotfiles clean
function dotfiles_clean {
  local bin_dir="$DOT_HOME/bin"
  local broken_links=$(find "$bin_dir" -type l ! -exec test -e {} \; -print)
  if [[ -n "$broken_links" ]]; then
    echo "Removing broken links:"
    echo "$broken_links"
    rm $broken_links
  fi
}
