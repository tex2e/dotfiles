#!/bin/bash

source "$(dirname $0)/utils.sh"
SCRIPT="./slit"

echo "=== $SCRIPT ==="


cmd="echo {A..Z} | $SCRIPT 3"
expect="\
A B C D E F G H I
J K L M N O P Q R
S T U V W X Y Z"
actual=$(eval "$cmd")

echo "> $cmd"
gdiff <(echo "$expect") <(echo "$actual")


cmd="echo A B C D | $SCRIPT 3"
expect="\
A B
C
D"
actual=$(eval "$cmd")

echo "> $cmd"
gdiff <(echo "$expect") <(echo "$actual")
