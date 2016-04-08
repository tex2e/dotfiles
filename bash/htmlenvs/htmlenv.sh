#!/bin/bash

set -u
SCRIPT=`basename $0 .sh`

HTMLENV_DIR="$HOME/.dotfiles/bash/htmlenvs"

test -d js/  || mkdir js/
test -d css/ || mkdir css/

function copy () {
  printf "writing $2 ... "
  cp "$1" "$2"
  echo "done"
}

copy "$HTMLENV_DIR/template.html" "index.html"
copy "$HTMLENV_DIR/normalize.css" "css/normalize.css"
copy "$HTMLENV_DIR/template.css"  "css/common.css"
copy "$HTMLENV_DIR/template.js"   "js/main.js"
