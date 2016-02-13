export PS1='\h:\W \$ '
export PS2='> '
export CDPATH='~/Documents/pgm'
export PATH="$PATH:$HOME/.dotfiles/bash"

case `uname` in
  Darwin ) # mac os
    :
    ;;
  Linux )
    # ruby
    if which rbenv > /dev/null; then
      export path=(~/.rbenv/shims $path)
      eval "$(rbenv init -)"
    fi

    # python
    if which pyenv > /dev/null; then
      export PYENV_ROOT="${HOME}/.pyenv"
      # export PATH=${PYENV_ROOT}/shims:${PATH}
      eval "$(pyenv init -)";
    fi
    ;;
  * )
    ;;
esac
