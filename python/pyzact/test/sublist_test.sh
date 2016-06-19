#!/bin/bash

source "$(dirname $0)/utils.sh"
SCRIPT="./sublist"

echo "=== $SCRIPT ==="


cmd="echo A B C D | $SCRIPT"
expect="\
A
A B
B
A B C
B C
C
A B C D
B C D
C D
D"
actual=$(eval "$cmd")

echo "> $cmd"
gdiff <(echo "$expect") <(echo "$actual")
