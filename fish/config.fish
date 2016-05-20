
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

  set st (git status 2> /dev/null)
  if echo "$st" | grep "nothing to"
    set color green
  else if echo "$st" | grep "nothing added"
    set color yellow
  else if echo "$st" | grep "Untracked files"
    set color red --bold
  else
    set color red
  end

  printf '%s%s%s%s' \
    (set_color $color) (__fish_git_prompt) (set_color normal) \
    (__fish_git_prompt_informative_status)
end
