#!/bin/bash
#:readme:
#
# ## git-auto(1) -- stage && commit && push
#
# [code](git-auto.sh)
#
# ### Description
#
# stage all files, and commit with automatically generated message, and push to
# tracking remote.
#
# ### Usage
#
#     > git-auto
#     git add --all
#     git commit -m <message>
#     git push <remote> <branch>
#

function usage {
  echo "Usage: git-auto [-h|--help]"
}

case $1 in
  -h | --help)
    usage; exit 1;;
esac


function is_inside_repo {
  if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "pwd is not inside the git repo." >&2
    return 1
  fi
}

function gen_commit_message {
  local NEWLINE="
"

  cd $(git rev-parse --show-toplevel)

  short_status=$(git status -s)
  A_file=$(echo "$short_status" | grep '^A' | cut -c 4-)
  M_file=$(echo "$short_status" | grep '^M' | cut -c 4-)
  R_file=$(echo "$short_status" | grep '^R' | cut -c 4-)
  D_file=$(echo "$short_status" | grep '^D' | cut -c 4-)

  message=""

  if [[ -n $A_file ]]; then
    message+="[create] ${A_file//$NEWLINE/, } $NEWLINE"
  fi

  if [[ -n $M_file ]]; then
    message+="[update] ${M_file//$NEWLINE/, } $NEWLINE"
  fi

  if [[ -n $R_file ]]; then
    message+="[rename] ${R_file//$NEWLINE/, } $NEWLINE"
  fi

  if [[ -n $D_file ]]; then
    message+="[delete] ${D_file//$NEWLINE/, } $NEWLINE"
  fi

  echo "$message"
}

function get_tracking_remote_name {
  git rev-parse --abbrev-ref --symbolic-full-name @{u} \
    | sed -e 's,/, ,'
}

function _sh {
  echo "> $*"
  eval "$*"
}

is_inside_repo || exit 1
_sh "git add --all" || exit 1
_sh "git commit -m \"$(gen_commit_message)\"" || exit 1
_sh "git push $(get_tracking_remote_name)" || exit 1
exit 0
