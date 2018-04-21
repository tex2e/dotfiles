#!/bin/bash

function dotfiles_update {
  cd $(dirname $0)
  git pull origin master
}
