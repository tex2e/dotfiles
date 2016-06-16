#!/bin/bash
#:readme:
#
# ## doc2unix(1) -- convert \r\n to \n
#
# [code](dos2unix.sh)
#
# ### SYNOPSIS
#
#     doc2unix <file>...
#
# ### Usage
#
# `doc2unix` convert \r\n to \n in the file(s).
#
#     > doc2unix foo.txt
#

temfile=`mktemp`
trap "rm $tmpfile; exit 1" 2

for file in $@; do
  tr -d '\r' < "$file" > "$tmpfile"
  mv "$tmpfile" "$file"
done
