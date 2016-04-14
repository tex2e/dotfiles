#!/bin/bash

function error {
  echo -e "\033[31mError:\033[m" "$*"
}

if which git &> /dev/null; then
  GIT=$(which git)
elif [ "$GIT" != "" ]; then
  GIT="$GIT"
else
  error "command not found: git"
  exit 1
fi

# fetch plugins
if [[ -d ~/.dotfiles/vim/.vim/plugged ]]; then
  cd ~/.dotfiles/vim/.vim/plugged
  $GIT clone https://github.com/tomtom/tcomment_vim
  $GIT clone https://github.com/scrooloose/nerdtree
fi
