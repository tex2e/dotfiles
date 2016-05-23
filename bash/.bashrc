
### Variables ###

PS1='\W \$ '
PS2='> '
: ${EDITOR:=vim}

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

if [[ -f "$HOME/.alias" ]]; then
  source ~/.alias
fi

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

if [[ -d "$HOME/.rbenv" ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi


### Useful Functions ###

mkdircd() {
  command mkdir -p "$1" && cd "$1"
}
