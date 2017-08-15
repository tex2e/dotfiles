#!/bin/bash

if [ $# -eq 0 ]; then
  DIR=.
else
  DIR="$*"
fi

explorer.exe $DIR
