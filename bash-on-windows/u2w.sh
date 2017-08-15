#!/bin/bash
#
# u2w -- Convert path from linux to window
#
# Usage:
#   > echo "/mnt/c/path/to/dir" | u2w
#   C:\path\to\dir

sed -r 's,^(/mnt/)(.),\U\2:,g' | sed 's,/,\\,g'
