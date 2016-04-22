
: ${PS1:='\W \$ '}
: ${PS2:='> '}
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

# # create .xmodmap file
# xmodmap -pke > "~/.xmodmap"
# vim ~/.xmodmap
#
#     remove Lock = Caps_Lock
#     keysym Caps_Lock = Control_L
#     add Control = Control_L
#
if [[ -f "~/.xmodmap" ]]; then
  xmodmap ~/.xmodmap
fi

# useful alias
alias ls='ls -F'
alias la='ls -A'
alias l.='\ls -d .*'
alias ll='ls -l'
alias lal='la -l'
alias lla='ll -A'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias bashrc='. ~/.bashrc'
alias bash_profile='. ~/.bash_profile'
alias fd='find . -type d -name'
alias ff='find . -type f -name'
alias en='LANG=en_US.UTF-8'
alias ja='LANG=ja_JP.UTF-8'
alias tree='tree -F'
alias tree1='tree -L 1'
alias tree2='tree -L 2'
alias tree3='tree -L 3'
alias tree4='tree -L 4'
alias tree5='tree -L 5'
alias gitlog='git log --graph --oneline --all --decorate'
alias chx='chmod 755'
alias chr='chmod 644'
alias server='python -m SimpleHTTPServer 8000 &>/dev/null &'
alias npmls='npm ls --depth 0'
alias npmlist='npm ls --depth 0'
alias npms='npm start'
alias npmt='npm test'
alias npmb='npm run build'
alias kill1='kill -9 %1'
alias kill2='kill -9 %2'
alias kill3='kill -9 %3'
alias kill4='kill -9 %4'
alias kill5='kill -9 %5'
alias bf="cat > ~/.vim/bf"
alias bfcat="cat ~/.vim/bf"

if [[ -d "$HOME/.rbenv" ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

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
  if [ -f "$1" ] ; then
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
