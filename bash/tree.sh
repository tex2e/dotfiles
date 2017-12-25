#!/bin/bash
#:readme:
#
# ## tree(1) -- list contents of directories in a tree-like format via shell script
#
# [code](tree.sh)
#
# it is recommended to install `tree` command via package installer.
#
# ### SYNOPSIS
#
#     tree [-F] [-L level] [--] [directory]
#
# ### Description
#
# `tree` is a recursive directory listing program.
# With no arguments, `tree` recursively lists a files in the current directory.
# When directory argument is given, `tree` recursively lists all the files
# in given directory.
#
# By default, when a symbolic link is encountered,
# the path that the symbolic link refers to is printed after the name of the
# link in the format: "path -> real-path"
#
# ### Usage
#
# `tree` shows files and directories list recursively.
#
#     > tree
#     .
#     ├── README.md
#     ├── index.html
#     └── js
#         ├── lib
#         │   └── underscore-min.js
#         └── main.js
#
# when a symbolic link is encountered, the format is like `name -> real-path`
#
#     > tree
#     .
#     └── bin
#         ├── texenv -> ../bash/texenvs/texenv.sh
#         ├── todo -> ../bash/todo.sh
#         └── tree -> ../bash/tree.sh
#
# `tree -F` append a "/" for directories, a "\*" for executable files.
#
#     > tree -F
#     .
#     └── ruby/
#         └── 2.2.3-1/
#             ├── usr/
#             │   ├── bin/
#             │   │   ├── cygruby220.dll*
#             │   │   ├── erb*
#             │   │   ├── irb*
#             │   │   └── ruby.exe*
#             │   ├── include/
#             │   │   └── ruby-2.2.0/
#             │   │       ├── ruby/
#             │   │       │   ├── backward/
#             │   │       │   ├── config.h
#             │   │       │   ├── debug.h
#     ...
#
# `tree -L <number>` specifies a max display depth of the directory tree.
#
#     > tree -F -L 3
#     .
#     └── ruby/
#         └── 2.2.3-1/
#             ├── usr/
#             └── var/
#

case ${1:-} in
  --help )
    echo "Usage: $(basename $0) [-F] [-L level] [--] [directory]"
    exit
    ;;
esac

export LANG="ja_JP.UTF-8"

INDENT_LEVEL=4
MAX_NEST_LEVEL=8

# check whether cut command support for multibyte string.
if [[ $(echo "あいうえお" | cut -c 1-2) = "あい" ]]; then
  pipe="│"
  pipet="├"
  pipefin="└"
  line="── "
else
  pipe="|"
  pipet="|"
  pipefin="\`"
  line="-- "
fi
none="   "
tab="    "

usage_exit() {
  echo "Usage: $0 [-F] [-L level] [--] [directory]"
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

# additonal_info <file>
#
# return additonal file info
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
  local target_str=$1
  echo "$target_str" | rev | cut -c $((INDENT_LEVEL+1))- | rev
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
