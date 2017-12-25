#!/bin/bash -u
#:readme:
#
# ## jpg-compress(1) -- Compress jpg files under cwd
#
# [code](jpg-compress.sh)
#
# ### SYNOPSIS
#
#     jpg-compress [<path/to/dir>]
#
# ### Description
#
# Compress jpg files under current working directory.
# In advance you need to install "jpegoptim" command.
#

case ${1:-} in
  "" | -h | --help )
    echo "Usage: $(basename $0) <file>..."
    exit
    ;;
esac

if ! which jpegoptim &>/dev/null; then
  echo "$0: command not found: jpegoptim"
  exit 1
fi

for jpg in `find "${1:-.}" -iname "*.jpg"`;
do
  echo "Compressing $jpg"
  jpegoptim --max=90 "$jpg"
done
