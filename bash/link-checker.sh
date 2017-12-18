#!/bin/bash -u
#:readme:
#
# ## link-checker(1) -- Check out broken links
#
# [code](link-checker.sh)
#
# ### SYNOPSIS
#
#     link-checker <url>
#
# ### Description
#
# Check and list up broken links of given url.
#

if [[ $# != 1 ]]; then
  echo "Usage: $(basename $0) <url>"
  exit
fi

wget -e robots=off -nd --spider -r "$1" 2>&1 \
  | grep -B 2 '404 Not Found' \
  | awk '/http/ { print $NF }'
