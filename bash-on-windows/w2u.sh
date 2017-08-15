#!/bin/bash
#
# w2u -- Convert path from window to linux
#
# Usage:
#   > echo "C:\path\to\dir" | w2u
#   /mnt/c/path/to/dir

sed 's,\\,/,g' | sed -r 's,^(.)(:),/mnt/\L\1,g'
