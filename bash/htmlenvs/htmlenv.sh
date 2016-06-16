#!/bin/bash
#:readme:
#
# ## htmlenv(1) -- init html environment
#
# [code](htmlenvs/htmlenv.sh)
#
# ### Description
#
# `htmlenv` creates a general html structure and writes templates.
#
# ### Usage
#
#     > htmlenv
#     writing index.html ... done
#     writing css/normalize.css ... done
#     writing css/common.css ... done
#     writing js/main.js ... done
#
#     > tree
#     .
#     ├── css/
#     │   ├── common.css
#     │   └── normalize.css
#     ├── index.html
#     └── js/
#         ├── lib/
#         └── main.js
#

set -u
SCRIPT=`basename $0 .sh`

HTMLENV_DIR="$HOME/.dotfiles/bash/htmlenvs"

test -d js     || mkdir js
test -d js/lib || mkdir js/lib
test -d css    || mkdir css

function copy () {
  printf "writing $2 ... "
  cp "$1" "$2"
  echo "done"
}

copy "$HTMLENV_DIR/template.html" "index.html"
copy "$HTMLENV_DIR/normalize.css" "css/normalize.css"
copy "$HTMLENV_DIR/template.css"  "css/common.css"
copy "$HTMLENV_DIR/template.js"   "js/main.js"
