#!/bin/bash

usage() {
    cat <<HELP
NAME:
  $SCRIPT_NAME -- show registered repositories status

SYNOPSIS:
  $SCRIPT_NAME -a <path>
  $SCRIPT_NAME [<path>]

DESCRIPTION:
  show registered repositories status

  --help             Print this help.
  -a <path>          Add repository to list.
  -d <path>          Delete repository from list.

EXAMPLE:
  {examples if any}

HELP
}

SCRIPT_NAME=$(basename $0)
SCRIPT_DIR="$(cd $(dirname "$0"); pwd)"
GIT_REPO_LIST_FILE="$HOME/.dotfiles/bash/repos/watchrepo"
GIT_REPO_ALIAS_FILE="$HOME/.dotfiles/bash/repos/repo_alias"

abspath() {
  if [[ ! -e "$1" ]]; then
    echo "$1"
    return
  fi
  echo $(cd "$1" && pwd)
}

contains-element() {
  local e
  for e in "${@:2}"; do
    [[ "$e" == "$1" ]] && return 0
  done
  return 1
}

git-status() {
  repo="$1"

  cd "$repo"
  [[ -d "$PWD/.git" ]] || return

  # branch name
  branch_name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
  [[ -z "$branch_name" ]] && return

  st=`git status 2>/dev/null`

  # set color
  color=
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    color=32 # green
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    color=33 # yellow
  elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
    color='1;31' # bold_red
  else
    color=31 # red
  fi

  st_branch=`git status --short --branch | head -n1 2>/dev/null`

  repo_basename=$(basename "$repo")
  echo -e "\033[${color}m$repo_basename\033[0m $st_branch"
}

add-repo() {
  mkdir -p "$(dirname "$GIT_REPO_LIST_FILE")"
  mkdir -p "$(dirname "$GIT_REPO_ALIAS_FILE")"

  for repo in $@; do
    # add new repo to $GIT_REPO_LIST_FILE
    if [[ ! -e "$repo" ]]; then
      echo "$repo: No such file or directory"
      exit
    fi
    if [[ ! -d "$repo/.git" ]]; then
      echo "$repo: Not a git repository"
      exit
    fi
    repo=$(abspath "$repo")
    echo "$repo" >> "$GIT_REPO_LIST_FILE"

    # add new alias to $GIT_REPO_ALIAS_FILE
    repo_basename=$(basename $repo)
    echo "alias $repo_basename='cd $repo'" >> "$GIT_REPO_ALIAS_FILE"
  done

  # sort and remove duplication
  sort "$GIT_REPO_LIST_FILE"  | uniq > tmp~ && cat tmp~ > "$GIT_REPO_LIST_FILE"
  sort "$GIT_REPO_ALIAS_FILE" | uniq > tmp~ && cat tmp~ > "$GIT_REPO_ALIAS_FILE"
  rm tmp~

  # update .bashrc
  echo "type \"source .bashrc\" to update aliases"
}

delete-repo() {
  mkdir -p "$(dirname "$GIT_REPO_LIST_FILE")"
  mkdir -p "$(dirname "$GIT_REPO_ALIAS_FILE")"

  for repo in $@; do
    # delete repo from $GIT_REPO_LIST_FILE and $GIT_REPO_ALIAS_FILE
    repo=$(abspath "$repo")
    repo_basename=$(basename "$repo")
    repo=$(echo "$repo" | sed -e 's,/,\\/,g' -e 's/\./\\./g')
    repo_basename=$(echo "$repo_basename" | sed -e 's/\./\\./g')

    sed -e '/^'"$repo"'$/d' "$GIT_REPO_LIST_FILE" > tmp~ && \
    cat tmp~ > "$GIT_REPO_LIST_FILE"
    sed -e "/^alias $repo_basename='cd $repo'/D" "$GIT_REPO_ALIAS_FILE" > tmp~ && \
    cat tmp~ > "$GIT_REPO_ALIAS_FILE"
  done
}

main() {
  while getopts a:d:h OPT; do
    case "$OPT" in
      h) usage; exit 0;;
      a) VALUE_A="$VALUE_A $OPTARG" ;;
      d) VALUE_D="$VALUE_D $OPTARG" ;;
    esac
  done

  shift $((OPTIND - 1))

  # add new repo
  if [[ "$VALUE_A" != '' ]]; then
    add-repo "$VALUE_A"
    return
  fi

  # delete repo
  if [[ "$VALUE_D" != '' ]]; then
    delete-repo "$VALUE_D"
    return
  fi

  # show repositories status
  if [[ $# == 0 ]]; then
    cat "$GIT_REPO_LIST_FILE" | \
    while read repo; do
      git-status "$repo"
    done
    return
  fi

  # show specified repositories status
  git_repo_list=$(cat "$GIT_REPO_LIST_FILE")
  for repo in "$@"; do
    found_repo=$(echo "$git_repo_list" | grep "$repo"'$')
    if [[ -n "$found_repo" ]]; then
      git-status "$found_repo"
    fi
  done
}

main "$@"
