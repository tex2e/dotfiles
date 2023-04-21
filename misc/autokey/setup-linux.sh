#!/bin/bash -e

cd $(dirname $0)

export FROM_DIR="$PWD"
export TO_DIR="$HOME/.config/autokey/data"

# リンクの作成
function createSymlink {
  if [ ! -e "$TO_DIR/${2:-$1}" ]; then
    ln -f -s "$FROM_DIR/$1" "$TO_DIR/${2:-$1}"
  fi
}

createSymlink CapsCtrl
createSymlink Replace
