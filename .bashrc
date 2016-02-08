
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
alias gitlog='git log --oneline --decorate --graph'
alias home='cd ~'
alias chx='chmod 755'
alias chr='chmod 644'

mkdir() {
  command mkdir -p "$1"
  if [ "$2" = "cd" ]; then
    cd "$1"
  else
    command mkdir -p "$@"
  fi
}

mkdircd() {
  command mkdir -p "$1" && cd "$1"
}

mkdirpu() {
  command mkdir -p "$1" && pushd "$1"
}

extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xjf $1     ;;
      *.tar.gz)  tar xzf $1     ;;
      *.bz2)     bunzip2 $1     ;;
      *.rar)     unrar e $1     ;;
      *.gz)      gunzip $1      ;;
      *.tar)     tar xf $1      ;;
      *.tbz2)    tar xjf $1     ;;
      *.tgz)     tar xzf $1     ;;
      *.zip)     unzip $1       ;;
      *.Z)       uncompress $1  ;;
      *.7z)      7z x $1        ;;
      *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
     echo "'$1' is not a valid file"
  fi
}

alias busy="cat /dev/urandom | hexdump -C | grep "ca fe""

CLEAR='\033[0m'
BOLD='\033[1m'
ULINE='\033[4m'

case `uname` in
  Darwin ) # mac os
    :
    ;;
  Linux )
    source ~/.ubuntu.bashrc

    # # create .xmodmap file
    # xmodmap -pke> "~/.xmodmap"
    # vim ~/.xmodmap
    #
    #   keycode 37 = Control_L NoSymbol Control_L   #ctrl
    #   keycode 66 = Caps_Lock NoSymbol Caps_Lock   #caps lock
    #   clear Lock
    #   add Control = Control_L
    #
    xmodmap ~/.xmodmap
    ;;
esac
