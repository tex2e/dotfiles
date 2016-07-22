#!/bin/bash
#
# git-open -- open repository's origin site
#

function usage {
  echo "Usage: git-open [<remote>]"
}

case $1 in
  -h | --help)
    usage; exit 1;;
esac

# set open command
which open     &>/dev/null && OPEN=open
which xdg-open &>/dev/null && OPEN=xdg-open
if [[ $OPEN == "" ]]; then
  echo "You must install `open` command before running this script."
  exit 1
fi

# set URL
REMOTE=${1:-origin}
URL=$(git remote -v | grep "$REMOTE" | awk '{print $2}' | uniq)
if [[ $URL == git@* ]]; then
  # convert SSH to HTTPS
  URL=$(
    echo $URL |
    sed 's,:,/,' |
    sed 's,git@,https://,')
fi

if [[ $URL == "" ]]; then
  echo "Remote \"$REMOTE\" not found."
  usage
  exit 1
fi

# --- open site --

if [[ $URL != https://* ]]; then
  echo "URL \"$URL\" must starts with \"https://\""
  exit 1
fi

echo "> $OPEN $URL"
$OPEN "$URL" &>/dev/null

if [[ $? -ne 0 ]]; then
  echo "URL \"$URL\" not found."
  exit 1
fi
