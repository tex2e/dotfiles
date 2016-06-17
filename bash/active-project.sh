#!/bin/bash
#:readme:
#
# ## active-project(1) -- list all active projects
#
# [code](active-project.sh)
#
# ### SYNOPSIS
#
#     active-project [<days>]
#
# ### Description
#
# List all directories in $CDPATH that have been modified in the last N days
# and contain git repositories.
#
# ### Usage
#
#     > active-project      # 90 days
#     > active-project 10   # 10 days
#

NEWLINE="
"

function cdpath_directories {
  local days_since_modified=${1:-90}

  echo "${CDPATH//:/$NEWLINE}" | while read dir; do
    test -z "$dir" && continue
    find -L "$dir" \
      -not -path '*/\.*' \
      -type d \
      -mtime -$days_since_modified \
      2>/dev/null
  done
}

function is_a_git_repo {
  while read dir; do
    if [[ -d "$dir/.git" ]]; then
      echo "$dir"
    fi
  done
}

cdpath_directories $1 | is_a_git_repo | sort -u
