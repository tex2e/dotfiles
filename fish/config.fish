
### Alias ###
. ~/.config/fish/aliases.fish


### Path ###

if not echo $PATH | grep --quiet ".dotfiles/bin"
  set -x PATH \
    /usr/local/bin $PATH \
    $HOME/.npm-packages/bin \
    $HOME/.dotfiles/bin \
    $HOME/local/bin \
    $HOME/picnic-tools/bin
end
set -x CDPATH $HOME $HOME/Documents $HOME/Documents/pgm


### Prompt ###

function fish_prompt -d "Write out the prompt"
  set -l color $fish_color_cwd
  if test $status -ne 0
    set color $fish_color_error
  end

  printf '%s%s>%s ' \
    (prompt_pwd) (set_color $color) (set_color normal)
end

function fish_right_prompt -d "Write out the right prompt"
  test -d "$PWD/.git"; or return

  # branch name
  set -l head (git symbolic-ref HEAD 2> /dev/null)
  test -z $head; and return
  set -l branch (basename $head)
  test -z $branch; and return

  # set color
  set st (git status 2> /dev/null)
  if echo "$st" | grep --quiet "nothing to"
    set color green
  else if echo "$st" | grep --quiet "nothing added"
    set color yellow
  else if echo "$st" | grep --quiet "Untracked files"
    set color red --bold
  else
    set color red
  end

  printf '%s%s%s ' \
    (set_color $color) $branch (set_color normal)
end
