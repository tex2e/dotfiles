#!/bin/bash -e

cd $(dirname $0)

# バックアップの作成とリンクの作成
function createSymlink {
  if [ -e "$HOME/${2:-$1}" ]; then
    cp "$HOME/${2:-$1}" "$HOME/${2:-$1}.bak"
  fi
  ln -f -s "$PWD/$1" "$HOME/${2:-$1}"
}

createSymlink .vimrc
