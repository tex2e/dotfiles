#!/bin/bash

find . -name .DS_Store -type f -delete
xattr -c $(ls -l | grep -e '^..........@' | awk '{print $NF}' )
