#!/bin/bash
#:readme:
#
# ## gen-commit-message(1) -- generate commit message
#
# [code](bash/gen-commit-message.sh)
#
# ### Description
#
# generate commit message from git status.
# This command is supposed use at git commit -m
#
# ### Usage
#
#     > gen-commit-message
#     create new1.sh, new2.sh
#     update foo.html, bar.css, baz.js
#     rename hage.c -> hoge.c
#     delete tmp.txt
#
#     > git commit -m "$(gen-commit-message)"
#

NEWLINE="
"

if ! git rev-parse --is-inside-work-tree &> /dev/null; then
  echo "pwd is not inside the git repo." >&2
  exit 1
fi

cd $(git rev-parse --show-toplevel)

short_status=$(git status -s)
A_file=$(echo "$short_status" | grep '^A' | cut -c 4-)
M_file=$(echo "$short_status" | grep '^M' | cut -c 4-)
R_file=$(echo "$short_status" | grep '^R' | cut -c 4-)
D_file=$(echo "$short_status" | grep '^D' | cut -c 4-)

message=""

if [[ -n $A_file ]]; then
  message+="create ${A_file//$NEWLINE/, } $NEWLINE"
fi

if [[ -n $M_file ]]; then
  message+="update ${M_file//$NEWLINE/, } $NEWLINE"
fi

if [[ -n $R_file ]]; then
  message+="rename ${R_file//$NEWLINE/, } $NEWLINE"
fi

if [[ -n $D_file ]]; then
  message+="delete ${D_file//$NEWLINE/, } $NEWLINE"
fi

echo "$message"
