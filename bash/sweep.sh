#!/bin/bash

# Delete .DS_Store
# Delete extended attribute keys

find . -type f -name .DS_Store -delete
find . -type f -name '*' -exec xattr -c {} +
