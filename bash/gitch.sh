#!/bin/bash
# git remote repo ssh/http switcher

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
  printf " \033[32m✔ \033[m%s...\033[32mOK\033[m\n" "$*"
}

# is_git_dir
#
# return true if working dir is a git repository.
function is_git_dir {
  if [ ! -e .git ]; then
    error "Not a git repogitory"
    return 1
  elif [ ! -d "$PWD/.git" ]; then
    error "this directory does not have a directory .git/"
    return 1
  fi
}

# get_remote_url <remote>
#
# get the specified remote URL (default remote is origin)
function get_remote_url {
  local origin=${1:-origin}
  git config remote."$origin".url
}

# get_remote_access_way <remote>
#
# get the remote access way, http or ssh (default remote is origin)
function get_remote_access_way {
  local origin=${1:-origin}

  if echo $(get_remote_url "$origin") | grep 'http' &> /dev/null; then
    echo "http"
  else
    echo "ssh"
  fi
}

# switch_remote_access_way <remote>
#
# switch the remote access way, http <=> ssh (default remote is origin)
function switch_remote_access_way {
  local access_way repo new_remote_url
  local origin=${1:-origin}

  case "$(get_remote_access_way "$origin")" in
    "http" )
      repo="$(get_remote_url "$origin" | awk -F// '{ print $2 }' | sed -e 's,github.com/,github.com:,g')"
      new_remote_url="git@$repo"
      ;;
    "ssh" )
      repo="$(get_remote_url "$origin" | awk -F: '{ print $2 }')"
      new_remote_url="https://github.com/$repo"
      ;;
  esac

  # echo $repo
  # echo $new_remote_url

  if set_remote_url "$origin" "$new_remote_url"; then
    success "Change $origin URL"
    echo "new remote:"
    git remote -v
  fi
}

# set_remote_url <remote> <remote-URL>
#
# set the remote URL
# return true if setting is successed.
function set_remote_url {
  local origin=${1:-origin}
  local new_remote_url=$2
  git remote set-url "$origin" "$new_remote_url"
  return $?
}


case "$1" in
  -h | --help | -v | --version )
    echo -e " g\033[37;4mitch v0.1.0\033[m"
    echo "  written by nobuyo"
    echo "  This script is git push protocol switcher."
    echo "  type \`gitch\` without any arguments to switch it."
    exit 0
    ;;
esac

is_git_dir || exit 1
switch_remote_access_way "${1:-origin}"

exit 0
