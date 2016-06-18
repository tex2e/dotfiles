#!/bin/bash
#:readme:
#
# ## dict(1) -- a command line dictionary for UNIX
#
# [code](dict.sh)
#
# ### SYNOPSIS
#
#     dict <word>
#
# ### Description
#
# a command line dictionary for UNIX
#
# ### Usage
#
#     dict rudimentary
#     dict laconic
#

curl "dict://dict.org/d:$1:*" | less
