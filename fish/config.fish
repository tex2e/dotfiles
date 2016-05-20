
function fish_prompt -d "Write out the prompt"
  set color $fish_color_cwd
  if test $status -ne 0
    set color $fish_color_error
  end

  printf '%s%s>%s ' \
    (prompt_pwd) (set_color $color) (set_color normal)
end

function fish_right_prompt -d "Write out the right prompt"
  printf '%s' \
    (__fish_git_prompt)
end
