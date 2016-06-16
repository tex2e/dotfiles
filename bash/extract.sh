#!/bin/bash
#:readme:
#
# ## extract(1) -- unzip file
#
# [code](extract.sh)
#
# ### SYNOPSIS
#
#     extract <file>...
#
# ### Description
#
# unzip file which support as follows.
# - tar.bz2
# - tar.gz
# - bz2
# - rar
# - gz
# - tar
# - tbz2
# - tgz
# - zip
# - Z
# - 7z
#
# ### Usage
#
# `extract` unzips file.
#
#     > extract foo.zip
#

for file in $@; do
  if ! [ -f "$file" ]; then
    echo "'$file' is not a valid file"
    continue
  fi

  case "$file" in
    *.tar.bz2) tar xjf "$file"     ;;
    *.tar.gz)  tar xzf "$file"     ;;
    *.bz2)     bunzip2 "$file"     ;;
    *.rar)     unrar e "$file"     ;;
    *.gz)      gunzip "$file"      ;;
    *.tar)     tar xf "$file"      ;;
    *.tbz2)    tar xjf "$file"     ;;
    *.tgz)     tar xzf "$file"     ;;
    *.zip)     unzip "$file"       ;;
    *.Z)       uncompress "$file"  ;;
    *.7z)      7z x "$file"        ;;
    *) echo "'$file' cannot be extracted via extract()" ;;
  esac
done
