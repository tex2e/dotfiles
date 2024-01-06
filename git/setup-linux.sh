#!/bin/bash -e

cd $(dirname $0)

# バックアップの作成とリンクの作成
function createSymlink {
  if [ -e "$HOME/${2:-$1}" ]; then
    cp "$HOME/${2:-$1}" "$HOME/${2:-$1}.bak"
  fi
  echo ln -f -s "$PWD/$1" "$HOME/${2:-$1}"
  ln -f -s "$PWD/$1" "$HOME/${2:-$1}"
}

createSymlink .gitconfig
createSymlink .gitignore_global
createSymlink .gitattributes_global .config/git/attributes

case `uname` in
  Darwin ) # mac os
    createSymlink .gitconfig.macos
    ;;
  Linux )
    createSymlink .gitconfig.linux
    ;;
esac

