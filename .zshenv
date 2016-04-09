
# export path
source ~/.path

# functions path
fpath=($fpath /usr/local/share/zsh-completions ~/.dotfiles/zsh/function)

# todo
if which todo > /dev/null; then
  todo
fi
