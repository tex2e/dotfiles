#!/bin/bash
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

find . -type f -name .DS_Store -delete
find . -type f -name '*' -exec xattr -c {} +
