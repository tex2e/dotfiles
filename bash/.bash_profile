
PS1='\W \$ '

# export path
source ~/.path

# Alias
source ~/.alias

# Git for Windows
if [[ `uname` =~ ^MINGW64 ]]; then
  PS1='\[\033]0;\w\007\]\[\033[32m\]\W\[\033[0m\] $ '
  alias open='explorer'
  alias which='type'

  mkdircd() {
    command mkdir -p "$1" && cd "$1"
  }
  touch00() {
    touch -t $(date +%m%d0000) $*
  }
fi
