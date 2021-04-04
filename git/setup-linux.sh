#!/bin/bash -e

# バックアップの作成とリンクの作成
function createSymlink {
  if [ -e "$HOME/${2:-$1}" ]; then
    cp "$HOME/${2:-$1}" "$HOME/${2:-$1}.bak"
  fi
  ln -f -s "$PWD/$1" "$HOME/${2:-$1}"
}

createSymlink .gitconfig
createSymlink .gitignore_global

case `uname` in
  Darwin ) # mac os
    createSymlink .gitconfig.macos
    ;;
  Linux )
    createSymlink .gitconfig.linux
    ;;
esac

