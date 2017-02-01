#!/bin/bash

# Delete .DS_Store under the cwd.
# Delete extended attribute keys from file in the cwd.

find . -type f -name .DS_Store -delete
xattr -c $(ls -l | grep -e '^..........@' | awk '{print $NF}')
