
### Alias ###
. ~/.config/fish/aliases.fish


### Path ###

if not contains /usr/local/bin $PATH
  set -x PATH /usr/local/bin $PATH
end

# PATH
set user_paths \
  $HOME/.npm-packages/bin \
  $PATH $HOME/.dotfiles/bin \
  $PATH $HOME/local/bin \
  $PATH $HOME/picnic-tools/bin

for i in $user_paths
  if not contains $i $PATH
    set PATH $PATH $i
  end
end

# CDPATH
set user_cdpath \
  $HOME \
  $HOME/Documents \
  $HOME/Documents/pgm

for i in $user_cdpath
  if not contains $i $CDPATH
    set CDPATH $CDPATH $i
  end
end


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
  if not git rev-parse --git-dir > /dev/null ^ /dev/null
    # we are NOT inside a git repo
    return
  end

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

# Change the terminal title automatically based on current process / working-directory
#
# The main improvement over the default 'fish_title' behavior
# is that I use the name of the current git repo, if any, as
# opposed to the raw working-directory
function fish_title
  set -l command (echo $_)
  if not test $command = "fish"
    # we are busy running some non-fish command, so use the command name
    echo $command
    return
  end
  # we are sitting at the fish prompt

  if not git rev-parse --git-dir > /dev/null ^ /dev/null
    # we are NOT inside a git repo, so just use the working-directory
    echo (pwd)
    return
  end
  # we are inside a git directory, so use the name of the repo as the terminal title

  set -l git_dir (git rev-parse --git-dir)
  if test $git_dir = ".git"
    # we are at the root of the git repo
    echo (basename (pwd))
  else
    # we are at least one level deep in the git repo
    echo (basename (dirname $git_dir))
  end
end


### Useful Functions ###

# mkdir and cd
function mkdircd
  command mkdir -p "$argv[1]"; and cd "$argv[1]"
end

# show $PATH at each line
function path
  set -l IFS ':'
  for p in $PATH
    echo $p
  end
end

# show $CDPATH at each line
function cdpath
  set -l IFS ':'
  for p in $CDPATH
    echo $p
  end
end

# unzip file
# suport tar.bz2, tar.gz, bz2, rar, gz, tar, tbz2, tgz, zip, Z and 7z file
function extract
  if not test -f "$argv[1]"
    echo "'$1' is not a valid file"
    return
  end

  switch "$argv[1]"
  case '*.tar.bz2'
    tar xjf "$argv[1]"
  case '*.tar.gz'
    tar xzf "$argv[1]"
  case '*.bz2'
    bunzip2 "$argv[1]"
  case '*.rar'
    unrar e "$argv[1]"
  case '*.gz'
    gunzip "$argv[1]"
  case '*.tar'
    tar xf "$argv[1]"
  case '*.tbz2'
    tar xjf "$argv[1]"
  case '*.tgz'
    tar xzf "$argv[1]"
  case '*.zip'
    unzip "$argv[1]"
  case '*.Z'
    uncompress "$argv[1]"
  case '*.7z'
    7z x "$argv[1]"
  case '*'
    echo "'$1' cannot be extracted via extract()"
  end
end

# display fish-shell logo
function logo
    echo '                 '(set_color F00)'___
  ___======____='(set_color FF7F00)'-'(set_color FF0)'-'(set_color FF7F00)'-='(set_color F00)')
/T            \_'(set_color FF0)'--='(set_color FF7F00)'=='(set_color F00)')
[ \ '(set_color FF7F00)'('(set_color FF0)'0'(set_color FF7F00)')   '(set_color F00)'\~    \_'(set_color FF0)'-='(set_color FF7F00)'='(set_color F00)')
 \      / )J'(set_color FF7F00)'~~    \\'(set_color FF0)'-='(set_color F00)')
  \\\\___/  )JJ'(set_color FF7F00)'~'(set_color FF0)'~~   '(set_color F00)'\)
   \_____/JJJ'(set_color FF7F00)'~~'(set_color FF0)'~~    '(set_color F00)'\\
   '(set_color FF7F00)'/ '(set_color FF0)'\  '(set_color FF0)', \\'(set_color F00)'J'(set_color FF7F00)'~~~'(set_color FF0)'~~     '(set_color FF7F00)'\\
  (-'(set_color FF0)'\)'(set_color F00)'\='(set_color FF7F00)'|'(set_color FF0)'\\\\\\'(set_color FF7F00)'~~'(set_color FF0)'~~       '(set_color FF7F00)'L_'(set_color FF0)'_
  '(set_color FF7F00)'('(set_color F00)'\\'(set_color FF7F00)'\\)  ('(set_color FF0)'\\'(set_color FF7F00)'\\\)'(set_color F00)'_           '(set_color FF0)'\=='(set_color FF7F00)'__
   '(set_color F00)'\V    '(set_color FF7F00)'\\\\'(set_color F00)'\) =='(set_color FF7F00)'=_____   '(set_color FF0)'\\\\\\\\'(set_color FF7F00)'\\\\
          '(set_color F00)'\V)     \_) '(set_color FF7F00)'\\\\'(set_color FF0)'\\\\JJ\\'(set_color FF7F00)'J\)
                      '(set_color F00)'/'(set_color FF7F00)'J'(set_color FF0)'\\'(set_color FF7F00)'J'(set_color F00)'T\\'(set_color FF7F00)'JJJ'(set_color F00)'J)
                      (J'(set_color FF7F00)'JJ'(set_color F00)'| \UUU)
                       (UU)'(set_color normal)
end
