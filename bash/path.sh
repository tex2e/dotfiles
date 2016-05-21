#!/bin/bash
#
# show $PATH at each line
#

echo -e ${PATH//:/'\n'}
