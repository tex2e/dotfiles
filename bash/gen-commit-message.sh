#!/bin/bash
#
# gen-commit-message -- generate commit message from git status
#

NEWLINE="
"

if ! git rev-parse --is-inside-work-tree &> /dev/null; then
  echo "pwd is not inside the git repo." >&2
  exit 1
fi

cd $(git rev-parse --show-toplevel)

short_status=$(git status -s)
A_file=$(echo "$short_status" | grep '^A' | cut -c 4-)
M_file=$(echo "$short_status" | grep '^M' | cut -c 4-)
R_file=$(echo "$short_status" | grep '^R' | cut -c 4-)
D_file=$(echo "$short_status" | grep '^D' | cut -c 4-)

declare -a A_files=($A_file)
declare -a M_files=($M_file)
declare -a D_files=($D_file)
declare -a R_files=($R_file)

message=""

if [[ ${#A_files[@]} != 0 ]]; then
  message+="create ${A_files//$NEWLINE/, } $NEWLINE"
fi

if [[ ${#M_files[@]} != 0 ]]; then
  message+="update ${M_files//$NEWLINE/, } $NEWLINE"
fi

if [[ ${#R_files[@]} != 0 ]]; then
  message+="rename ${R_files//$NEWLINE/, } $NEWLINE"
fi

if [[ ${#D_files[@]} != 0 ]]; then
  message+="delete ${D_files//$NEWLINE/, } $NEWLINE"
fi

message=$(echo "$message" | sed -e '/^$/ d')
echo "$message"
