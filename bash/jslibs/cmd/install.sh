#!/bin/bash

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
         printf("%s%s %s\n", vn, $2, $3);
      }
   }'
   return 0
}

function download {
  if which curl &>/dev/null; then
    curl -O "$@"
  elif which wget &>/dev/null; then
    wget "$@"
  fi
}

# jslib install <library...>
function jslib-install {
  jslibs=$(parse-yaml $JSLIB_SETTINGS_YAML)
  echo "$jslibs"
  for library in $@; do
    install_url=$(echo "$jslibs" | grep -e '\blib_'"$library"'\b' | cut -d ' ' -f 2)
    test "$install_url" == "" && continue
    mkdir -p js/lib/ && cd js/lib &&
    download "$install_url"
    cd - &>/dev/null
  done
}

function jslib-i {
  jslib-install "$@"
}
