#!/bin/bash

source "$(dirname $0)/utils.sh"
SCRIPT="./subset"

echo "=== $SCRIPT ==="


cmd="echo A B C D | $SCRIPT"
expect="\
A
B
C
D
A B
A C
A D
B C
B D
C D
A B C
A B D
A C D
B C D
A B C D"
actual=$(eval "$cmd")

echo "> $cmd"
gdiff <(echo "$expect") <(echo "$actual")
