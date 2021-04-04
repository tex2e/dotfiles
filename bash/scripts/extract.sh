#!/bin/bash -u
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
# - tar.xz
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

function help {
cat <<EOT
Usage:
    extract <file>...

unzip file list:

- tar.bz2
- tar.gz
- bz2
- rar
- gz
- tar
- tbz2
- tgz
- zip
- Z
- 7z

EOT
exit
}

exe() { echo "\$ $@"; "$@"; }

case ${1:-} in
  "" | -h | --help )
    help
    exit
    ;;
esac

for file in $@; do
  if ! [ -f "$file" ]; then
    echo "'$file' is not a valid file"
    continue
  fi

  case "$file" in
    *.tar.bz2) exe tar xjf "$file"     ;;
    *.tar.gz)  exe tar xzf "$file"     ;;
    *.tar.xz)  exe tar xf  "$file"     ;;
    *.bz2)     exe bunzip2 "$file"     ;;
    *.rar)     exe unrar e "$file"     ;;
    *.gz)      exe gunzip "$file"      ;;
    *.tar)     exe tar xf "$file"      ;;
    *.tbz2)    exe tar xjf "$file"     ;;
    *.tgz)     exe tar xzf "$file"     ;;
    *.zip)     exe unzip "$file"       ;;
    *.Z)       exe uncompress "$file"  ;;
    *.7z)      exe 7z x "$file"        ;;
    *) echo "'$file' cannot be extracted via extract()" ;;
  esac
done
