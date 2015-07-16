
###
# Setup command search path
typeset -U path
path=($path ~/.script ~/.dotfiles/bash)
cdpath=(~ ~/Documents ~/Documents/pgm)
# functions path
fpath=($fpath ~/.dotfiles/zsh/function)

# export shell variable
case `uname` in
	Darwin ) # mac os
		export CC=clang
		export CXX=clang++
		;;
	Linux )
		export CC=gcc
		export CXX=gcc
		;;
esac
export EDITOR=vim
###


# ruby
eval "$(rbenv init - zsh)"

# python
if which pyenv > /dev/null; then
    export PYENV_ROOT="${HOME}/.pyenv"
    # export PATH=${PYENV_ROOT}/shims:${PATH}
    eval "$(pyenv init -)";
fi
