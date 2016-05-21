#!/bin/bash
#
# show $CDPATH at each line
#

echo -e ${CDPATH//:/'\n'}
