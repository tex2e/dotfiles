#!/bin/bash
#:readme:
#
# ## mpath(1) -- split manpaths into each line
#
# [code](mpath.sh)
#
# ### SYNOPSIS
#
#     mpath
#
# ### Description
#
# manpath contents is difficult to read because each paths are joined with ":",
# so split manpaths into each line and show them.
#

MPATH="$(command manpath)"
echo -e ${MPATH//:/'\n'}
