#!/bin/bash -e

cd $(dirname $0)

export FROM_DIR="$PWD"
export TO_DIR="$HOME/.config/Code/User/"

# バックアップの作成とリンクの作成
function createSymlink {
  if [ -e "$TO_DIR/${2:-$1}" ]; then
    cp "$TO_DIR/${2:-$1}" "$TO_DIR/${2:-$1}.bak"
  fi
  ln -f -s "$FROM_DIR/$1" "$TO_DIR/${2:-$1}"
}

case `uname` in
  Darwin ) # mac os
    # TODO:
    ;;
  Linux )
    createSymlink settings.json
    createSymlink keybindings.json
    createSymlink snippets/markdown.json
    createSymlink snippets/shellscript.json
    ;;
esac

