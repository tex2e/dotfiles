#!/bin/bash
# Usage: {script} [ OPTIONS ] TARGET BUILD
#
#   TARGET      Default target is "/usr/local".
#   BUILD       If not defined tries to get the build into the Sublime Text 3 website.
#
# OPTIONS
#
#   -h, --help  Displays this help message.
#

set -e

if [[ "${1}" = '-h' ]] || [[ "${1}" = '--help' ]]; then
  awk '/^#!/,/^$/ { print }' "$0" |
  sed '1d' |
  sed -E 's/^# ?(.*)/\1/g' |
  sed "s/{script}/$(basename "${0}")/g"
  exit
fi

declare URL
declare URL_FORMAT="https://download.sublimetext.com/sublime_text_3_build_%d_x%d.tar.bz2"
declare TARGET="${1:-/usr/local}"
declare BUILD="${2}"
declare BITS

function error {
  echo -e "\033[31mError\033[m" "$*"
}

function check_os {
  if ! [[ "$(uname -n)" = "ubuntu" ]]; then
    error "the nodename is not \"ubuntu\", exiting."
    exit 1
  fi
}

function download {
  if which curl &>/dev/null; then
    curl -L $@
  elif which wget &>/dev/null; then
    wget -O - $@
  fi
}

# --- main ---

check_os

if [[ -z "${BUILD}" ]]; then
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
