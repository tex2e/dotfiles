#!/bin/bash
#:readme:
#
# ## png-compress(1) -- Compress png files under cwd
#
# [code](png-compress.sh)
#
# ### SYNOPSIS
#
#     png-compress [<path/to/dir>]
#
# ### Description
#
# Compress png files under current working directory.
# In advance you need to install "pngcrush" command.
#

if ! which pngcrush &>/dev/null; then
  echo "$0: command not found: pngcrush"
  exit 1
fi

for png in `find ${1:-.} -name "*.png"`;
do
  echo "crushing $png"
  pngcrush -brute "$png" /var/tmp/temp.png
  mv -f /var/tmp/temp.png $png
done
