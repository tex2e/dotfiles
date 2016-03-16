#!/bin/bash

# convert a yaml string to a tsv string
function parse-yaml {
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s\t%s\n", vn, $2, $3);
      }
   }'
   return 0
}

# download a file from specified url.
function download {
  if which curl &>/dev/null; then
    curl -O "$@"
  elif which wget &>/dev/null; then
    wget "$@"
  fi
}

# jslib install [--download-here] <library...>
function jslib-install {
  # get option
  local DOWNLOAD_HERE=
  if [[ "$1" = '--here' ]] || [[ "$1" = '-h' ]]; then
    DOWNLOAD_HERE=1  # set true
  fi

  # get setting file
  local jslibs=$(parse-yaml $JSLIB_SETTINGS_YAML)

  # install libraries
  for library in $@; do
    # if library is not jot downed to the setting file, skip it.
    install_url=$(echo "$jslibs" | grep -e '\blib_'"$library"'\b' | cut -f 2)
    test "$install_url" = "" && continue

    # if DOWNLOAD_HERE is false
    if [[ DOWNLOAD_HERE = 0 ]]; then
      # default path is ./js/lib/lib_name.js
      mkdir -p js/lib/ && cd js/lib
    fi

    local install_filename=$(basename "$install_url")
    echo "install to $PWD/$install_filename"
    download "$install_url"
    cd - &>/dev/null
  done
}

function jslib-i {
  jslib-install "$@"
}
