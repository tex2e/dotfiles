
function fish_prompt -d "Write out the prompt"
  set -l color $fish_color_cwd
  if test $status -ne 0
    set color $fish_color_error
  end

  printf '%s%s>%s ' \
    (prompt_pwd) (set_color $color) (set_color normal)
end

# load __fish_git_prompt
__fish_git_prompt > /dev/null

function fish_right_prompt -d "Write out the right prompt"
  test -d "$PWD/.git"; or return

  # branch name
  set -l head (git symbolic-ref HEAD 2> /dev/null)
  test -z $head; and return
  set -l branch (basename $head)
  test -z $branch; and return

  # set color
  set st (git status 2> /dev/null)
  if echo "$st" | grep "nothing to" > /dev/null
    set color green
  else if echo "$st" | grep "nothing added" > /dev/null
    set color yellow
  else if echo "$st" | grep "Untracked files" > /dev/null
    set color red --bold
  else
    set color red
  end

  printf '%s%s%s %s' \
    (set_color $color) (echo $branch) (set_color normal) \
    (__fish_git_prompt_informative_status)
end
