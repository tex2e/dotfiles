#!/bin/bash

source "$(dirname $0)/utils.sh"
SCRIPT="./stairr"

echo "=== $SCRIPT ==="


cmd="echo A B C D | $SCRIPT"
expect="\
D
C D
B C D
A B C D"
actual=$(eval "$cmd")

echo "> $cmd"
gdiff <(echo "$expect") <(echo "$actual")


cmd="echo 'A B C
D E F' | $SCRIPT --eos='---'"
expect="\
C
B C
A B C
---
F
E F
D E F
---"
actual=$(eval "$cmd")

echo "> $cmd"
gdiff <(echo "$expect") <(echo "$actual")
