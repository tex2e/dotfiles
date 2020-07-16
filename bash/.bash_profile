
PS1='\W \$ '

if [[ `uname` =~ ^MINGW64  ]]; then
  PS1='\[\033]0;\w\007\]\[\033[32m\]\W\[\033[0m\] $ '
fi

# export path
source ~/.path

# Alias
source ~/.alias
