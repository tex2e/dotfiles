#!/bin/bash
#:readme:
#
# ## git-open(1) -- Open repository's origin site
#
# [code](git-open.sh)
#
# ### SYNOPSIS
#
#     git-open [--dry-run] [<remote>]
#
# ### Description
#
# Open an repository's origin site.
#

function usage {
  echo "Usage: git-open [--dry-run] [<remote>]"
}

for OPT in $@; do
  case "$OPT" in
    -h | --help )
      usage
      exit 1
      ;;
    --dry-run)
      DRY_RUN=1
      shift 1
      ;;
    '--'|'-' )
      shift 1
      param+=( "$@" )
      break
      ;;
    -*)
      echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
      exit 1
      ;;
    *)
      if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
        param+=( "$1" )
        shift 1
      fi
      ;;
  esac
done

# set open command
which open     &>/dev/null && OPEN=open
which xdg-open &>/dev/null && OPEN=xdg-open
if [[ "$OPEN" == "" ]]; then
  echo "You must install `open` command before running this script."
  exit 1
fi

# set URL
REMOTE=${param[0]:-origin}
URL=$(git remote -v | grep "$REMOTE" | awk '{print $2}' | uniq)
# convert ssh to https
if [[ "$URL" == ssh://* ]]; then
  # remove ssh:// and convert git@ to https://
  URL=$(
    echo "$URL" |
    awk -F"//" '{ print $2 }' |
    sed 's,:,/,' |
    sed 's,git@,https://,'
  )
fi
# remove authentication (https://username@github.com -> https://github.com)
if [[ "$URL" == https://*@* ]]; then
  URL=$(echo "$URL" | sed 's,//.*@,//,')
fi

if [[ $URL == "" ]]; then
  echo "Remote \"$REMOTE\" not found."
  usage
  exit 1
fi

# --- open site --

if [[ $URL != https://* ]] && [[ $URL != http://* ]]; then
  echo "URL \"$URL\" must starts with \"https://\""
  exit 1
fi

echo "> $OPEN $URL"
if [[ "$DRY_RUN" != 1 ]]; then
  $OPEN "$URL" &>/dev/null
fi
