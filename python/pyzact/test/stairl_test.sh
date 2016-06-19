#!/bin/bash

source "$(dirname $0)/utils.sh"
SCRIPT="./stairl"

echo "=== $SCRIPT ==="


cmd="echo A B C D | $SCRIPT"
expect="\
A
A B
A B C
A B C D"
actual=$(eval "$cmd")

echo "> $cmd"
gdiff <(echo "$expect") <(echo "$actual")


cmd="echo 'A B C
D E F' | $SCRIPT --eos='---'"
expect="\
A
A B
A B C
---
D
D E
D E F
---"
actual=$(eval "$cmd")

echo "> $cmd"
gdiff <(echo "$expect") <(echo "$actual")
