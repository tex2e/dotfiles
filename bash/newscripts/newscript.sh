#!/bin/bash

new_script_name=${1:-template.sh}

export NEWSCRIPT_DIR="$HOME/.dotfiles/bash/newscripts"
export NEWSCRIPT_TEMPLATE="$NEWSCRIPT_DIR/template.sh"

cp -i "$NEWSCRIPT_TEMPLATE" "$new_script_name"
chmod +x "$new_script_name"
