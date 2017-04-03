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

tmpfile=`mktemp`
trap "rm $tmpfile; exit 1" 2

for file in $@; do
  echo -n "converting $file ... "
  tr -d '\r' < "$file" > "$tmpfile"
  mv "$tmpfile" "$file"
  echo "done"
done
