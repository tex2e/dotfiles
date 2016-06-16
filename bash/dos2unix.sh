#!/bin/bash
#:readme:
#
# ## doc2unix(1) -- convert CRLF to LF
#
# [code](dos2unix.sh)
#
# ### SYNOPSIS
#
#     doc2unix <file>...
#
# ### Description
#
# `doc2unix` convert line breaks as CRLF to LF in the file(s).
# This implementation is quite simple because it deletes only '\r', to put '\n'.
#

temfile=`mktemp`
trap "rm $tmpfile; exit 1" 2

for file in $@; do
  tr -d '\r' < "$file" > "$tmpfile"
  mv "$tmpfile" "$file"
done
