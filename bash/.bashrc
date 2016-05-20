
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

path() {
  echo -e ${PATH//:/'\n'}
}
cdpath() {
  echo -e ${CDPATH//:/'\n'}
}
fpath() {
  echo -e ${FPATH//:/'\n'}
}
manpath() {
  local MPATH="$(command manpath)"
  echo -e ${MPATH//:/'\n'}
}

extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1"     ;;
      *.tar.gz)  tar xzf "$1"     ;;
      *.bz2)     bunzip2 "$1"     ;;
      *.rar)     unrar e "$1"     ;;
      *.gz)      gunzip "$1"      ;;
      *.tar)     tar xf "$1"      ;;
      *.tbz2)    tar xjf "$1"     ;;
      *.tgz)     tar xzf "$1"     ;;
      *.zip)     unzip "$1"       ;;
      *.Z)       uncompress "$1"  ;;
      *.7z)      7z x "$1"        ;;
      *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
