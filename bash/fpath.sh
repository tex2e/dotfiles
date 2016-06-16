#!/bin/bash
#:readme:
#
# ## fpath(1) -- split fpaths into each line
#
# [code](fpath.sh)
#
# ### SYNOPSIS
#
#     fpath
#
# ### Description
#
# FPATH (zsh function path) contents is difficult to read
# because each paths are joined with ":",
# so split cdpaths into each line and show them.
#

echo -e ${FPATH//:/'\n'}
