
###
# Setup command search path
typeset -U path
path=($path ~/.script)
cdpath=(
	.. ~ ~/Documents ~/Documents/pgm
	~/Library/Application\ Support/Sublime\ Text\ 2/
)

# export shell variable
export CC=clang
export CXX=clang++
###


# ruby
eval "$(rbenv init - zsh)"

# python
if which pyenv > /dev/null; then
    export PYENV_ROOT="${HOME}/.pyenv"
    # export PATH=${PYENV_ROOT}/shims:${PATH}
    eval "$(pyenv init -)";
fi
