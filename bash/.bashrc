
# fix ubuntu keymapping
case `uname` in
  Linux )
    which xmodmap &> /dev/null && xmodmap "$HOME/.dotfiles/xmodmap/ubuntu-keymap" > /dev/null
    ;;
esac

# # create .xmodmap file
# xmodmap -pke > "~/.xmodmap"
# vim ~/.xmodmap
#
#     remove Lock = Caps_Lock
#     keysym Caps_Lock = Control_L
#     add Control = Control_L
#
if [[ -f "$HOME/.xmodmap" ]]; then
  xmodmap "$HOME/.xmodmap" &> /dev/null
fi


### Variables ###

PS1='\W \$ '
PS2='> '
export EDITOR=vim
# export LANG=C.UTF-8
export LANG=en_US.UTF-8

case `uname` in
  Darwin ) # mac os
    export CC=clang
    export CXX=clang++
    ;;
  Linux )
    source ~/.ubuntu.bashrc
    export CC=gcc
    export CXX=g++
    alias open='xdg-open'
    ;;
esac

### Execute Scripts ###

# Alias
source ~/.alias

if [[ -d "$HOME/.rbenv" ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi


### Useful Functions ###

mkdircd() {
  command mkdir -p "$1" && cd "$1"
}
