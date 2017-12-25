#!/bin/bash -u
#:readme:
#
# ## img-compress(1) -- Compress image files under cwd
#
# [code](img-compress.sh)
#
# ### SYNOPSIS
#
#     img-compress [<path/to/dir>]
#
# ### Description
#
# Compress image files under current working directory.
#

case ${1:-} in
  -h | --help )
    echo "Usage: $(basename $0) <dir>"
    exit
    ;;
esac

# Compress jpeg

if ! which jpegoptim &>/dev/null; then
  echo "$(basename $0): command not found: jpegoptim"
  exit 1
fi

for jpg in `find "${1:-.}" -iname "*.jpg"`; do
  echo "Compressing $jpg"
  jpegoptim --max=90 "$jpg"
done

# Compress png

if ! which pngcrush &>/dev/null; then
  echo "$(basename $0): command not found: pngcrush"
  exit 1
fi

for png in `find "${1:-.}" -iname "*.png"`; do
  echo "Compressing $png"
  pngcrush -brute "$png" /var/tmp/temp.png
  mv -f /var/tmp/temp.png $png
done
