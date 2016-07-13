#!/bin/bash

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
