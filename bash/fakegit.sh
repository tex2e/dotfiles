#!/usr/bin/env bash
#:readme:
#
# ## fakegit(1) -- Emulating "git clone" with other tools
#
# [code](fakegit.sh)
#
# ### SYNOPSIS
#
#     fakegit clone [-b <branch_name>] <GitHub Repository URL> [<directory>]
#
# ### DESCRIPTION
#
# The fakegit command provides psuedo "git clone" command only for GitHub repository,
# which downloads files with curl, or wget.
# This is useful for environments which is difficult to install git command.
#
# ### Usage
#
# `fakegit` provides only "clone" command like `git clone`
#
#     > fakegit clone https://github.com/hnw/fakegit
#
# ### Instant Usage
#
#     > bash <(curl -L https://raw.github.com/TeX2e/dotfiles/master/bash/fakegit.sh) clone <URL>
#

# origin: https://github.com/hnw/fakegit

# The MIT License
#
# Copyright (c) 2012 Yoshio HANAWA
# Copyright (c) 2016 @TeX2e
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

version="1.0.0"

# -e : Exit immediately if a simple command exits with a non-zero status.
set -e

validate_url() {
  local url="$1"
  # supports following URLs
  #  HTTP: https://github.com/*/*.git
  #  SSH:  git@github.com:*/*.git
  #  Git:  git://github.com/*/*.git
  local valid_url=$(echo "$1" | grep '^\(https://github.com/\|git@github.com:\|git://github.com/\)[^/]*/[^/]*.git$' || true)
  if [ -z "$valid_url" ]; then
    echo "fakegit: Specified invalid GitHub URL \`$url'" >&2
    exit 1
  fi
}

fetch_command() {
  if which curl &>/dev/null; then
    echo "curl" "-L" "$@"
  elif which wget &>/dev/null; then
    echo "wget" "-O-" "$@"
  fi
}

log() {
  printf "fakegit: %b\n" "$*" >&2
  return $?
}

fail() {
  log "ERROR: $*\n"
  exit 1
}

fakegit_clone() {
  local branch_name="master"

  if [ "$1" = "-b" ] || [ "$1" = "--branch" ]; then
    branch_name="$2"
    if [ -z "$branch_name" ] ; then
      fail "switch \`$1' requires a value"
      exit 1
    fi
    shift 2
  fi

  local git_repo="$1"

  if [ -z "$git_repo" ]; then
    echo "usage: $0 clone [-b <branch_name>] <GitHub Repository URL> [<directory>]" >&2
    exit 1
  fi

  validate_url "$git_repo"
  # Git URL -> HTTP URL
  local https_repo="${git_repo/#git:/https:}"
  # SSH URL -> HTTP URL
  https_repo="${https_repo/#git@github.com:/https://github.com/}"
  local svn_repo="${https_repo%*.git}"
  local proj_name="${svn_repo##*/}"
  local dir="${2:-$proj_name}"

  local fetch_command=$(fetch_command "${svn_repo}/tarball/${branch_name}" || true)
  local extract_command="tar xzf - --strip-components 1 -C $dir"
  if [ -z "$fetch_command" ]; then
    fail "No download command found.\nPlease install one of \`curl' or \`wget' and try again"
  fi
  mkdir -p "$dir"
  log "Instaed of git, executing:\n" $fetch_command "|" $extract_command
  $fetch_command | $extract_command
}

fakegit_help() {
  case "$1" in
  "" )
    echo "usage: fakegit <command> [<args>]"
    ;;
  "clone" )
    echo "usage: fakegit clone <GitHub repository> [<directory>]"
    ;;
  * )
    command_path="$(command -v "fakegit_$1" || true)"
    if [ -n "$command_path" ]; then
      echo "Sorry, the \`$1' command isn't documented yet."
      echo
      echo "You can view the command's source here:"
      echo "$command_path"
      echo
    else
      echo "fakegit: no such command \`$1'"
    fi
  esac
}

command="$1"
case "$command" in
"" | "-h" | "--help" )
  echo -e "fakegit ${version}\n$(fakegit_help)" >&2
  ;;
* )
  command_path="$(command -v "fakegit_$command" || true)"
  if [ -z "$command_path" ]; then
    echo "fakegit: Unsupported command \`$command'" >&2
    exit 1
  fi

  shift 1
  "$command_path" "$@"
  ;;
esac
