#!/bin/bash
#:readme:
#
# ## path(1) -- split exported paths into each line
#
# [code](path.sh)
#
# ### SYNOPSIS
#
#     path
#
# ### Description
#
# PATH contents is difficult to read because each paths are joined with ":",
# so split paths into each line and show them.
#

echo -e ${PATH//:/'\n'}
