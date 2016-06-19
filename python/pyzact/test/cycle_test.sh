#!/bin/bash

source "$(dirname $0)/utils.sh"
SCRIPT="./cycle"

echo "=== $SCRIPT ==="


cmd="echo A B C D E | $SCRIPT"
expect="\
A B C D E
B C D E A
C D E A B
D E A B C
E A B C D"
actual=$(eval "$cmd")

echo "> $cmd"
gdiff <(echo "$expect") <(echo "$actual")
