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
  elif [ ! -d "$(pwd)"/.git ]; then
    error "this directory did not have a directory .git/"
    exit 1
  fi
}

function check_ssh_available {
  ssh -T git@github.com
  if [ $? = 1 ]; then
    echo -n "SSH CONNECTION..."; success "OK"
  else
    echo -n "SSH CONNECTION..."; warn "Does not established"
  fi
}

function get_origin_url {
  origin="$(awk '/\[remote/ {getline; print $3}' "$(pwd)"/.git/config)"
}

function check_access {
  acc="http"
  echo $origin | grep 'http' > /dev/null || acc="ssh"
}

function encode {
  if [ "$1" = "http" ]; then
    local repo="$(echo $origin | awk -F// '{ print $2 }' | sed -e 's@github.com/@github.com:@g')"
    new_origin="git@"$repo
    # echo $new_origin
  elif [ "$1" = "ssh" ]; then
    local repo="$(echo $origin | awk -F: '{ print $2 }')"
    new_origin="https://github.com/"$repo
    # echo $new_origin
  fi
}

  function set_new_origin {
    git remote set-url origin $new_origin && {
      success "Change origin URL"
      echo "new remote:"
      git remote -v
    }
}

if [ "$1" = "help" ] || [ "$1" = "-h" ] || [ "$1" = "-v" ]; then
  echo -e " g\033[37;4mitch v0.1.0\033[m"
  echo "  written by nobuyo"
  echo "  This script is git push protocol switcher."
  exit 0
elif [ "$1" != "" ]; then
  warn "Given argument(s) will be ignored."
fi

is_git_dir
get_origin_url
# echo $origin
check_access
# echo $acc
encode $acc
# echo $new_origin
set_new_origin
