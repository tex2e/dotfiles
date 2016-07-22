#!/bin/bash
#
# git-open -- open repository's origin site
#

function usage {
  echo "Usage: git-open [<remote>]"
}

which open     &>/dev/null && OPEN=open
which xdg-open &>/dev/null && OPEN=xdg-open

case $1 in
  -h | --help)
    usage; exit 1;;
esac

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

# --- open a site ---

case $URL in
  https://*)
    : ;;
  *)
    echo "URL \"$URL\" must be started with \"https://\""
    exit 1;;
esac

echo "> $OPEN $URL"
$OPEN "$URL" &>/dev/null

if [[ $? -ne 0 ]]; then
  echo "URL \"$URL\" not found."
  exit 1
fi
