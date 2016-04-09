#!/bin/bash
#
# todo -- todo list management system
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
