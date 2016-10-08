#!/bin/bash

# dotfiles remove <path/to/bin/symlink>
# dotfiles rm <path/to/bin/symlink>

function dotfiles_remove {
  local symlink_file=${1%/}
  local symlink_dir=${symlink_file%/*}
  local original_file="$symlink_dir/$(readlink $symlink_file)"

  test -f "$symlink_file" &&
  rm "$symlink_file" &&
  success "remove bin/$symlink_file"

  test -f "$original_file" &&
  rm "$original_file" &&
  success "remove $original_file"
}

function dotfiles_rm {
  dotfiles_remove $*
}
