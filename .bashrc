
PS1='\W \$ '
PS2='> '
EDITOR=vim

case `uname` in
  Darwin ) # mac os
    CC=clang
    CXX=clang++
    ;;
  Linux )
    source ~/.ubuntu.bashrc

    CC=gcc
    CXX=g++

    # # create .xmodmap file
    # xmodmap -pke > "~/.xmodmap"
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

CLEAR='\033[0m'
BOLD='\033[1m'
ULINE='\033[4m'

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
alias gitlog='git log --oneline --decorate --graph'
alias chx='chmod 755'
alias chr='chmod 644'
alias server='python -m SimpleHTTPServer 8000 &>/dev/null &'
alias npmls='npm ls --depth 0'
alias npmlist='npm ls --depth 0'
alias kill1='kill -9 %1'
alias kill2='kill -9 %2'
alias kill3='kill -9 %3'
alias kill4='kill -9 %4'
alias kill5='kill -9 %5'

# external alias
repo_alias="$HOME/.dotfiles/bash/repos/repo_alias"
if [[ -f "$repo_alias" ]]; then
  source "$repo_alias"
fi

mkdircd() {
  command mkdir -p "$1" && cd "$1"
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

new-script() {
    cat <<'SHELLSCRIPT' > "$1"
#!/bin/sh
usage() {
    cat <<HELP
NAME:
   $0 -- {one sentence description}

SYNOPSIS:
  $0 [-h|--help]
  $0 [--verbose]

DESCRIPTION:
   {description here}

  -h  --help      Print this help.
      --verbose   Enables verbose mode.

EXAMPLE:
  {examples if any}

HELP
}

main() {
  SCRIPT_DIR="$(cd $(dirname "$0"); pwd)"

  for ARG; do
    case "$ARG" in
      --help) usage; exit 0;;
      --verbose) set -x;;
      --) break;;
      -*)
        OPTIND=1
        while getopts h OPT "$ARG"; do
          case "$OPT" in
            h) usage; exit 0;;
          esac
        done
        ;;
    esac
  done

  # do something
}

main "$@"

SHELLSCRIPT
    chmod +x "$1"
}
