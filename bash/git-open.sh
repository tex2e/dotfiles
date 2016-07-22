#!/bin/bash
#
# git-open -- open repository's origin site
#

which open     &>/dev/null && OPEN=open
which xdg-open &>/dev/null && OPEN=xdg-open

URL=$(git remote -v | grep origin | awk '{print $2}' | uniq)

if [[ $URL == git@* ]]; then
  # convert SSH to HTTPS
  URL=$(
    echo $URL |
    sed 's,:,/,' |
    sed 's,git@,https://,')
fi

$OPEN $URL
