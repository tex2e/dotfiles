#!/bin/bash

filename=${1:-template.sh}
scriptname="${filename%.*}"

NEWSCRIPT_DIR="$HOME/.dotfiles/bash/newscripts"
NEWSCRIPT_TEMPLATE="$NEWSCRIPT_DIR/template.sh"

cat "$NEWSCRIPT_TEMPLATE" | sed "s/SCRIPTNAME/$scriptname/g" > "$scriptname"
chmod +x "$scriptname"
