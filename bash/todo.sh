#!/bin/bash
#:readme:
#
# ## todo(1) -- A command line todo manager
#
# [code](todo.sh)
#
# ### SYNOPSIS
#
#     todo
#     todo -m <message>
#     todo -d <number>
#
# ### Description
#
# `todo` is a command line todo list manager.
# It maintains a list of tasks that you want to do, allowing you to add/remove them.
#
# ### Usage
#
# `todo -m <message>` creates a todo task.
#
#     > todo -m 'Do my assignment'
#     todo << Do my assignment
#     > todo -m 'Clean room'
#     todo << Clean room
#
# `todo` shows todo list.
#
#     > todo
#     todo list :
#          1  Do my assignment
#          2  Clean room
#
# `todo -d <number>` deletes a specified todo task.
#
#     > todo -d 1
#     done >> Do my assignment
#

function usage {
cat <<EOT
Usage:
  todo [-l | -m <message> | -d <lineno>]

Options:
  -l          show all todo list
  -m message  add new todo task
  -d lineno   delete todo task
EOT
exit 1
}

TODO_FILE="$HOME/.todo"
[[ -f "$TODO_FILE" ]] || touch "$TODO_FILE"

function list {
  if [[ -s "$TODO_FILE" ]]; then
    echo 'todo list : '
    cat -n "$TODO_FILE"
  else
    echo 'nothing to do' 1>&2
  fi
}

function add {
  echo "todo << $1"
  echo "$1" >> "$TODO_FILE"
}

function delete {
  echo -n 'done >> '
  sed -n "${1}p" "$TODO_FILE"
  sed -i -e "${1}d" "$TODO_FILE"
  rm "$TODO_FILE-e"
}

[[ $# == 0 ]] && list
[[ $# == 1 ]] && usage

while getopts :lm:d: OPT ; do
  case $OPT in
    l ) list;              shift        ;;
    m ) add    "$OPTARG";  shift; shift ;;
    d ) delete "$OPTARG";  shift; shift ;;
    * ) usage;             exit         ;;
  esac
done
