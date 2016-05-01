#!/bin/bash

tmpfile="/tmp/dos2unix~"
trap "rm $tmpfile; exit 1" 2

for file in $@; do
  tr -d '\r' < "$file" > "$tmpfile"
  mv "$tmpfile" "$file"
done
