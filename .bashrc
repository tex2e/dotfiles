
# useful alias
alias ls='ls -F'
alias la='ls -A'
alias ll='ls -l'
alias lal='la -l'
alias lla='ll -A'
alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias bashrc='. ~/.bashrc'
alias bash_profile='. ~/.bash_profile'
alias fd='find . -type d -name'
alias ff='find . -type f -name'
alias en='LANG=en_US.UTF-8'
alias ja='LANG=ja_JP.UTF-8'
alias tree='tree -F'
alias gitlog='git log --oneline --decorate --graph'
mkdir() {
  command mkdir -p "$1"
  [ "$2" = "cd" ] && cd "$1"
}
mkdircd() {
  command mkdir -p "$1" && cd "$1"
}
mkdirpu() {
  command mkdir -p "$1" && pushd "$1"
}

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
