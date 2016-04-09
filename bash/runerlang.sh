#!/bin/bash

file_name="$1"
file=${1%.*}

erlc "$file_name"
erl -noshell -run "$file" start -run init stop

