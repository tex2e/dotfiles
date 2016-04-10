#!/bin/bash

function warn {
  # color:yellow
  echo -e "\033[33mWarning:\033[m" "$*"
}

function error {
  # color:red
  echo -e "\033[31mError:\033[m" "$*"
}

function success {
  # color:green
  printf " \033[32m✔ \033[m%s\n" "$*"
}

function fail {
  # color:red
  printf " \003[31m✘ \033[m%s\n" "$*"
}

function ask_user {
  local question=$1
  read -p "$question (y/n) " answer
  case ${answer:0:1} in
    y|Y )
      echo Yes && return 0 ;;
    * )
      echo No  && return 1 ;;
  esac
}
