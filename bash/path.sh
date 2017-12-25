#!/bin/bash -u
#:readme:
#
# ## path(1) -- split paths into each line
#
# [code](path.sh)
#
# ### SYNOPSIS
#
#     path [-f|f|fun|func|function|fpath] [-m|man|manual|manpath]
#          [-c|-cd|cd|cdpath]
#
# ### Description
#
# contents of PATH, CDPATH, FPATH (zsh function path) and manpath are difficult to
# read because each paths are joined with ":", so split paths into each line and
# show them.
#

case ${1:-} in
  -h | --help )
    echo "Usage: path [fpath | manpath | cdpath]"
    exit
    ;;
  -c | -cd | cd | cdpath )
    echo -e ${CDPATH//:/'\n'}
    ;;
  -f | f | fun | func | function | fpath )
    echo -e ${FPATH//:/'\n'}
    ;;
  -m | m | man | manual | manpath )
    MPATH="$(command manpath)"
    echo -e ${MPATH//:/'\n'}
    ;;
  * )
    echo -e ${PATH//:/'\n'}
    ;;
esac
