#!/bin/bash

source "$(dirname $0)/utils.sh"
SCRIPT="./flat"

echo "=== $SCRIPT ==="


cmd="seq 10 | $SCRIPT"
expect="\
1 2 3 4 5 6 7 8 9 10"
actual=$(eval "$cmd")

echo "> $cmd"
gdiff <(echo "$expect") <(echo "$actual")


cmd="echo '\
AA,AB,AC,AD
BA,BB,BC,BD
CA,CB,CC,CD
DA,DB,DC,DD' | $SCRIPT --fs=, 8"
expect="\
AA,AB,AC,AD,BA,BB,BC,BD
CA,CB,CC,CD,DA,DB,DC,DD"
actual=$(eval "$cmd")

echo "> $cmd"
gdiff <(echo "$expect") <(echo "$actual")
