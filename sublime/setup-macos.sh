#!/bin/bash -e

cd $(dirname $0)

export FROM_DIR="$PWD"
export TO_DIR="$HOME/Library/Application Support/Sublime Text/Packages/User"

# バックアップの作成とリンクの作成
function createSymlink {
  if [ -e "$TO_DIR/${2:-$1}" ]; then
    cp "$TO_DIR/${2:-$1}" "$TO_DIR/${2:-$1}.bak"
  fi
  ln -f -s "$FROM_DIR/$1" "$TO_DIR/${2:-$1}"
}

createSymlink "Preferences_MacOS.sublime-settings" "Preferences.sublime-settings"

# ターミナルでsublコマンドを使えるようにする設定
if [ ! -f /usr/local/bin/subl ]; then
    echo "[+] Create /usr/local/bin/subl"
    sudo ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
fi
