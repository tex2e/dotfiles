#! /bin/bash

set -u
SCRIPT=`basename $0 .sh`

# to use this to create tex enviroment, type:
#
#     texenv
#     make init
#
# further infomation is in ${TEXENV_DIR}/Makefile.mk
#

TEXENV_DIR="$HOME/.dotfiles/bash/texenvs"

option=${1:-null}

if [ $# = 0 ] || [ $option = make ]; then
  printf 'linking Makefile ... '
  ln -s ~/.dotfiles/bash/texenvs/Makefile.mk "$PWD/Makefile" &>/dev/null && \
  echo 'done' || \
  echo 'file exists'
elif [ $option = rake ]; then
  printf 'linking Rakefile ... '
  ln -s ~/.dotfiles/bash/texenvs/Rakefile.rb "$PWD/Rakefile" &>/dev/null && \
  echo 'done' || \
  echo 'file exists'
else
  echo 'nothing to be done'
  exit 1
fi

exit 0
