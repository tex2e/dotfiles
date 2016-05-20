
function fish_prompt -d "Write out the prompt"
  set color $fish_color_cwd
  if test $status -ne 0
    set color $fish_color_error
  end

  printf '%s%s>%s ' \
    (prompt_pwd) (set_color $color) (set_color normal)
end

function fish_right_prompt -d "Write out the right prompt"
  # Git status
  #   green when working directory is clean
  #   yellow when it has untracked files
  #   red when changes are not staged for commit
  #   bold red when it has untracked files and changes are not staged
  #
  echo "$PWD" | grep '/\.git(/.*)?$'; and return

  # branch name
  set head_ref (git symbolic-ref HEAD 2> /dev/null)
  test -z $head_ref; and return
  set name (basename $head_ref)

  # set color
  set st (git status 2> /dev/null)
  if echo "$st" | grep "^nothing to"
    set color green
  else if echo "$st" | grep "^nothing added"
    set color yellow
  else if echo "$st" | grep "^# Untracked"
    set color --bold red
  else
    set color red
  end

  printf '%s%s%s' \
    (set_color $color) $name (set_color normal)
end
