#!/bin/bash -u
#:readme:
#
# ## sweep(1) -- Sweep MacOS metadata under cwd (only MacOS)
#
# [code](sweep.sh)
#
# ### SYNOPSIS
#
#     sweep [<path/to/dir>]
#
# ### Description
#
# Delete .DS_Store and delete extended attribute keys which added to files.
#

case ${1:-} in
  -h | --help )
    echo "Usage: $(basename $0) [<dir>]"
    exit
    ;;
esac

find ${1:-.} -type f -name .DS_Store -delete
find ${1:-.} -type f -name '*' -exec xattr -c {} +
