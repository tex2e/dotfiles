#!/bin/bash

# dotfiles link <path/to/script.sh>
function dotfiles_link {
  local script_path=$1
  local command_basename=$(basename $script_path)
  local command_name=$(echo $command_basename | sed -e 's/.sh//')

  if ! [[ -f "$script_path" ]]; then
    echo "$script_path: no such a file."
    exit 1
  fi

  local link_command="cd bin/ && ln -s ../\"$script_path\" \"$command_name\""

  echo $link_command
  case $(ask_user "Are you sure to want to create symlink?") in
  Yes )
    eval "$link_command" &&
    success "create bin/$command_name -> $script_path"
    ;;
  No )
    echo "exiting."
    ;;
  esac
}
