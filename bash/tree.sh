#!/bin/bash

INDENT_LEVEL=4
MAX_NEST_LEVEL=8

pipe="│"
pipet="├"
pipefin="└"
line="── "
none="   "
tab="    "

usage_exit() {
  echo "Usage: $0 [-F] [-L level] [--] [directory...]"
  exit 1
}

# rec_ls <file or dir...>
#
# show files and directories recursively
function rec_ls {
  level=0

  for tryfile in "$@"; do
    echo "$tryfile"
    if [[ -d "$tryfile" ]]; then
      thisfile=$tryfile
      rec_dir $(command ls $tryfile)
    fi
  done

  unset indent thisfile
}

# rec_dir <file or dir...>
#
# helper method for rec_ls
function rec_dir {
  level=$((level + 1))
  local i=0
  local filenum=${#@}

  for file in "$@"; do
    i=$((i + 1))
    thisfile=$thisfile/$file

    # shows file
    local thisfileindent
    if [[ "$i" = "$filenum" ]]; then
      thisfileindent="$indent$pipefin$line"  # last file in this dir
    else
      thisfileindent="$indent$pipet$line"    # a file of this dir
    fi
    file="$file$(additonal_info "$thisfile")"
    echo -e "$thisfileindent$file"

    # shows directory recursively

    if [[ -d "$thisfile" ]] && [[ "$level" -lt "$MAX_NEST_LEVEL" ]]; then
      # indent
      if [[ "$i" = "$filenum" ]]; then
        indent="$indent$tab"               # sequence files do not exist
      else
        indent="$indent$pipe$none"         # some sequence files exist
      fi

      rec_dir $(command ls $thisfile)

      # deindent
      indent=$(deindent "$indent")
    fi

    thisfile=${thisfile%/*}
  done

  level=$((level - 1))
}

function hoge {
  echo "$1"
}

# additonal_info <file>
function additonal_info {
  if [[ -L "$1" ]]; then
    echo " -> $(readlink "$1")"
    return
  fi

  test "$FILE_SUFFIX" || return

  if [[ -d "$1" ]]; then
    echo "/"
  elif [[ -x "$1" ]]; then
    echo "*"
  fi
}

# deindent <string>
#
# delete indent one level from tail
function deindent {
  echo "$1" | rev | cut -c $((INDENT_LEVEL+1))- | rev
}

# --- main ---

while getopts FL:h OPT
do
  case $OPT in
  F ) FILE_SUFFIX=1
      ;;
  L ) MAX_NEST_LEVEL=$OPTARG
      ;;
  h ) usage_exit
      ;;
  \?) usage_exit
      ;;
  esac
done

shift $((OPTIND - 1))

rec_ls ${1:-.}
