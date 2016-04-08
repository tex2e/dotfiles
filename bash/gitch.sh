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

function is_git_dir {
  if [ ! -e .git ]; then
    error "Not git repogitory, exiting"
    exit 1
  elif [ ! -d "$PWD/.git" ]; then
    error "this directory does not have a directory .git/"
    exit 1
  fi
}

function get_origin_url {
  git config remote.origin.url
}

function get_origin_access_way {
  local access

  if echo $(get_origin_url) | grep 'http' &> /dev/null; then
    access="http"
  else
    access="ssh"
  fi
  echo $access
}

function switch_origin_access_way {
  local access_way repo new_origin_url

  case "$(get_origin_access_way)" in
    "http" )
      repo="$(get_origin_url | awk -F// '{ print $2 }' | sed -e 's,github.com/,github.com:,g')"
      new_origin_url="git@$repo"
      ;;
    "ssh" )
      repo="$(get_origin_url | awk -F: '{ print $2 }')"
      new_origin_url="https://github.com/$repo"
      ;;
  esac

  # echo $repo
  # echo $new_origin_url

  if set_origin_url "$new_origin_url"; then
    success "Change origin URL"
    echo "new remote:"
    git remote -v
  fi
}

function set_origin_url {
  local new_origin=$1
  git remote set-url origin "$new_origin"
  return $?
}

is_git_dir
switch_origin_access_way

exit 0
