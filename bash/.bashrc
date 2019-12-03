
### Bash 4.x Feature ###

if [[ "$BASH_VERSION" =~ ^4\. ]]; then
  shopt -s globstar
fi


### Key Mapping ###

# xmodmap -pke > "~/.xmodmap"  # create .xmodmap file
# vim ~/.xmodmap
#
#     remove Lock = Caps_Lock
#     keysym Caps_Lock = Control_L
#     add Control = Control_L
#
# if [[ -f "$HOME/.xmodmap" ]]; then
#   xmodmap "$HOME/.xmodmap" &> /dev/null
# fi
# # fix ubuntu keymapping
# case `uname` in
#   Linux )
#     which xmodmap &> /dev/null &&
#     xmodmap "$HOME/.dotfiles/xmodmap/ubuntu-keymap" > /dev/null
#     ;;
# esac


### Variables ###

PS1='\W \$ '
PS2='> '
export EDITOR=vim
# export LANG=C.UTF-8
export LANG=en_US.UTF-8
export HISTIGNORE="ls*:cd:pwd:exit:cd ..:git ss:git aa"

case `uname` in
  Darwin ) # mac os
    export CC=clang
    export CXX=clang++
    ;;
  Linux )
    source ~/.ubuntu.bashrc
    export CC=gcc
    export CXX=g++
    alias open='xdg-open 2>/dev/null'
    ;;
esac


### Useful Functions ###

mkdircd() {
  command mkdir -p "$1" && cd "$1"
}
alias mkcd='mkdircd'

sandbox() {
  mkdircd sandbox
}
rmsandbox() {
  case `pwd` in
    */sandbox ) cd .. && rm -rf sandbox ;;
    *         ) echo "rmsandbox: Current dir is not a sandbox!" && return 1 ;;
  esac
}

touch00() {
  touch -t $(date +%m%d0000) $*
}

t() {
  ffmpeg -ss $2 -to $3 -i $1 $(dirname $1)/$(basename $1 .mp4)-t.mp4
}
s() {
  for file in $@; do
    ffmpeg -i $file -vf scale=700:-1 $(dirname $file)/$(basename $file .mp4)-s.mp4 \
    || ffmpeg -y -i $file -vf scale=690:-1 $(dirname $file)/$(basename $file .mp4)-s.mp4 \
    || ffmpeg -y -i $file -vf scale=710:-1 $(dirname $file)/$(basename $file .mp4)-s.mp4 \
    || ffmpeg -y -i $file -vf scale=702:-1 $(dirname $file)/$(basename $file .mp4)-s.mp4
  done
}
vup() {
  ffmpeg -i $1 -af volume=+${2:-5}dB $(dirname $1)/$(basename $1 .mp4)-vu.mp4
}
vdown() {
  ffmpeg -i $1 -af volume=-${2:-5}dB $(dirname $1)/$(basename $1 .mp4)-vd.mp4
}
co() {
  for file in $@; do
    ffmpeg -i $file -preset slow $(dirname $file)/$(basename $file .mp4)-co.mp4
  done
}


### Execute Scripts ###

# Alias
source ~/.alias

## rbenv settings
#if [[ -d "$HOME/.rbenv" ]]; then
#  export PATH="$HOME/.rbenv/bin:$PATH"
#  eval "$(rbenv init -)"
#fi

## alert command
#case `uname` in
#  Darwin ) # mac os
#    function alert() {
#      osascript -e "display notification \"$2\" with title \"$1\""
#    }
#    ;;
#  Linux )
#    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)"'
#    ;;
#esac

# For BoW (Bash on Windows)
if [[ `uname` = 'Linux' ]] && [[ -d /mnt/c ]]; then
  alias open='~/.dotfiles/bash-on-windows/open.sh'
fi
