
###
# Setup command search path
typeset -U path
path=(/usr/local/bin $path ~/.dotfiles/bash)
cdpath=(~ ~/Documents ~/Documents/pgm)

# functions path
fpath=($fpath /usr/local/share/zsh-completions ~/.dotfiles/zsh/function)

# export shell variable
case `uname` in
  Darwin ) # mac os
    export CC=clang
    export CXX=clang++
    ;;
  Linux )
    export CC=gcc
    export CXX=g++
    ;;
esac
export EDITOR=vim
###

# todo
if which todo > /dev/null; then
  todo -l
fi
