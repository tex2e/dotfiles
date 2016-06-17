#!/bin/bash

git add -A --dry-run | cut -d' ' -f 2 | xargs file | grep -v '\-bit' | cut -d':' -f 1
