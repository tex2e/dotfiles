#!/bin/bash -u
#:readme:
#
# ## mkdo(1) -- Compile C file and Execute
#
# [code](mkdo.sh)
#
# ### SYNOPSIS
#
#     mkdo <file> [-c '<args>'] [-e '<args>'] [-o]
#
# ### Description
#
# compile C file and execute it.
# `mkdo foo.c` == `make foo && ./foo`
#
# ### Usage
#
# `mkdo` compile C file and execute it.
#
#     > mkdo foo
#
# `-c` option can specify the compiling options.
#
# `-e` option can specify the excution options.
#

function usage {
  echo "Usage: mkdo <file> [-c '<args>'] [-e '<args>'] [-o]"
  exit 0
}

if [ $# -eq 0 ]; then
  usage
fi

# remove extension from filename
FILE=${1%.*}

shift 1

while getopts c:e:oh OPT ; do
  case $OPT in
    c ) VALUE_C=" $OPTARG" ;;
    e ) VALUE_E=" $OPTARG" ;;
    o ) VALUE_O=" > ${FILE}.out" ;;
    h ) usega ;;
    * ) usage ;;
  esac
done

compile="make '${FILE}'${VALUE_C}"
execute="'${FILE}'${VALUE_E}${VALUE_O}"

# If executable file is not specified as absolute path, prefix "./"
echo "$execute" | grep -e '^\./' -e '^~/' -e '^/' || execute="./$execute"

echo "> $compile"
eval "$compile" || exit 1
echo "> $execute"
eval "$execute" || exit 1

exit 0
