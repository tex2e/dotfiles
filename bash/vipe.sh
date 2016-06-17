#!/bin/bash
#:readme:
#
# ## vipe(1) -- edit pipe
#
# [code](vipe.sh)
#
# ### SYNOPSIS
#
#     command | vipe | command
#
# ### DESCRIPTION
#
# vipe allows you to run your editor in the middle of a unix pipeline
# edit the data that is being piped between programs.
#

TMPFILE=`mktemp`
cat > ${TMPFILE}
vim ${TMPFILE} < /dev/tty > /dev/tty
cat ${TMPFILE}
rm ${TMPFILE}
