#!/bin/bash

TMPFILE=`mktemp /tmp/vipe.bash`
cat > ${TMPFILE}
vim ${TMPFILE} < /dev/tty > /dev/tty
cat ${TMPFILE}
rm ${TMPFILE}
