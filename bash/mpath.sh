#!/bin/bash
#
# show manpath at each line
#

MPATH="$(command manpath)"
echo -e ${MPATH//:/'\n'}
