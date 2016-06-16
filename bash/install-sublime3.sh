#!/bin/bash
#:readme:
#
# ## install-sublime3(1) -- install sublime on Ubuntu without sudo/root
#
# [code](install-sublime3.sh)
#
# **Note: this script only runs on Ubuntu.**
#
# ### SYNOPSIS
#
#     install-sublime3 [<target> [<build>]]
#
# - `target`    Default target is "/usr/local".
# - `build`     build version. If not defined, tries to get the build into the
#               Sublime Text 3 website.
#
# ### Usage
#
# `install-sublime3` installs sublime text 3.
# the sublime is installed to
#
#     > install-sublime3
#
# you can specify the installed directory.
#
#     > install-sublime3 ~/usr/local
#
# and also you can specify the sublime build version.
#
#     > install-sublime3 ~/usr/local 3114
#

set -e

if [[ "${1}" = '-h' ]] || [[ "${1}" = '--help' ]]; then
  # show usage
  echo "Usage: install-sublime3 [<target> [<build>]]"
  exit
fi

declare URL
declare URL_FORMAT="https://download.sublimetext.com/sublime_text_3_build_%d_x%d.tar.bz2"
declare TARGET="${1:-/usr/local}" # root dir
declare BUILD="${2}" # build version
declare BITS

TARGET=${TARGET%/} # remove slash from the end of the path

function error {
  echo -e "\033[31mError\033[m" "$*"
}

function download {
  if which curl &>/dev/null; then
    curl -L $@
  elif which wget &>/dev/null; then
    wget -O - $@
  fi
}

# --- main ---

# check os
if ! [[ "$(uname)" = "Linux" ]]; then
  error "the os name is not \"Linux\", exiting."
  exit 1
fi

if [[ -z "${BUILD}" ]]; then
  # extract a latest build version from Sublime Text 3 website
  BUILD=$(
    download http://www.sublimetext.com/3 |
    grep '<h2>Build' |
    head -n1 |
    sed -E 's#<h2>Build ([0-9]+)</h2>#\1#g'
  )
fi

if [[ "$(uname -m)" = "x86_64" ]]; then
  BITS=64
else
  BITS=32
fi

URL=$(printf "${URL_FORMAT}" "${BUILD}" "${BITS}")

read -p "Do you really want to install Sublime Text 3 (Build ${BUILD}, x${BITS}) on \"${TARGET}\"? [Y/n]: " CONFIRM
CONFIRM=$(echo "${CONFIRM}" | tr [a-z] [A-Z])
if [[ "${CONFIRM}" = 'N' ]] || [[ "${CONFIRM}" = 'NO' ]]; then
  echo "Aborted!"
  exit
fi

echo "Downloading Sublime Text 3"
download "${URL}" | tar -xjC "${TARGET}"

# echo "Creating shortcut file"
# cat ${TARGET}/sublime_text_3/sublime_text.desktop |
# sed "s#/opt#${TARGET}#g" |
# cat > "/usr/share/applications/sublime_text.desktop"

echo "Creating binary file"
mkdir -p "${TARGET}/bin"
cat > "${TARGET}/bin/subl" <<SCRIPT
#!/bin/bash
if [ \"\$1\" = \"--help\" ]; then
  ${TARGET}/sublime_text_3/sublime_text --help
else
  ${TARGET}/sublime_text_3/sublime_text \$@ > /dev/null 2>&1 &
fi
SCRIPT
chmod +x "${TARGET}/bin/subl"

echo "Finish!"
