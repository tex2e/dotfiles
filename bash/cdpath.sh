#!/bin/bash
#:readme:
#
# ## cdpath(1) -- split cdpaths into each line
#
# [code](cdpath.sh)
#
# ### SYNOPSIS
#
#     cdpath
#
# ### Description
#
# CDPATH contents is difficult to read because each paths are joined with ":",
# so split cdpaths into each line and show them.
#

echo -e ${CDPATH//:/'\n'}
