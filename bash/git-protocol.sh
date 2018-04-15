#!/bin/bash -u
#:readme:
#
# ## git-protocol(1) -- change protocol of git repository's remote
#
# [code](git-protocol.sh)
#
# ### SYNOPSIS
#
#     git-protocol <command> [<remote>]
#
# ### Description
#
# Change protocol of git repository's remote.
# If you give "switch" as command, switch the git access protocol between https and ssh.
# If "secure" is as command, set url to https in place of http.
# Without second argument "remote", set "origin" to remote by default.
#
# ### Usage
#
#     > git remote -v
#     origin	http://github.com/TeX2e/test (fetch)
#     origin	http://github.com/TeX2e/test (push)
#
#     > git protocol origin
#      ✔ Change origin URL...OK
#     new remote:
#     origin	git@github.com:TeX2e/test (fetch)
#     origin	git@github.com:TeX2e/test (push)
#
#     > git protocol secure origin
#      ✔ Change origin URL...OK
#     new remote:
#     origin	https://github.com/TeX2e/test (fetch)
#     origin	https://github.com/TeX2e/test (push)
#

function help {
  cat <<EOS
git-protocol -- change protocol of git repository's remote

Usage:
  git-protocol [command] [remote]

Command list:
  switch -- switch protocol https and ssh
  secure -- use https instead of http

EOS
}

function warn {
  echo -e "\033[33mWarning:\033[m" "$*"
}
function error {
  echo -e "\033[31mError:\033[m" "$*"
}
function success {
  printf " \033[32m✔ \033[m%s...\033[32mOK\033[m\n" "$*"
}

function is_inside_repo {
  git rev-parse --is-inside-work-tree &>/dev/null
  return $?
}

# --- git protocol switch ---

# get_remote_access_way <remote>
#
# get the remote access way, http or ssh (default remote is origin)
function get_remote_access_way {
  local origin=${1:-origin}
  if echo $(git config remote."$origin".url) | grep 'http' &> /dev/null; then
    echo "http"
  else
    echo "ssh"
  fi
}

# switch_remote_access_way <remote>
#
# switch the remote access way, http <=> ssh (default remote is origin)
function switch_remote_access_way {
  local origin=${1:-origin}
  local repo new_remote_url

  case $(get_remote_access_way "$origin") in
    "http" )
      repo=$(git config remote."$origin".url | awk -F// '{ print $2 }' | sed -e 's,.com/,.com:,')
      new_remote_url="git@$repo"
      ;;
    "ssh" )
      repo=$(git config remote."$origin".url | awk -F@ '{ print $2 }' | sed -e 's,.com:,.com/,')
      new_remote_url="https://$repo"
      ;;
  esac

  if git remote set-url "$origin" "$new_remote_url"; then
    success "Change $origin URL"
    echo "new remote:"
    git remote -v
  fi
}

# --- git protocol secure ---

# set_secure_protocol <remote>
#
# change remote url http to https
function set_secure_protocol {
  local origin=${1:-origin}
  local new_remote_url

  new_remote_url="$(git config remote."$origin".url | sed -e 's,http:/,https:/,g')"
  if git remote set-url "$origin" "$new_remote_url"; then
    success "Change $origin URL"
    echo "new remote:"
    git remote -v
  fi
}


# --- main ---

if ! is_inside_repo; then
  error "This is not a git repository."
  exit 1
fi

args_command=${1:-}
args_remote=${2:-}

case $args_command in
  switch | "")
    switch_remote_access_way "${args_remote:-origin}" ;;
  secure )
    set_secure_protocol "${args_remote:-origin}" ;;
  "" | -h | --help )
    help && exit ;;
  * )
    error "Unknown command: $args_command" ;;
esac

exit 0
