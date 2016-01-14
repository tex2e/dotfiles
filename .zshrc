
# inherited from .bashrc
source ~/.bashrc

###
# Set Shell variable
HISTSIZE=1000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=10000
# スラッシュが6つ以内なら右プロンプトに表示
# 6つ以上なら左プロンプトを2行に分けてその1行目に表示
# PROMPT=$'%(6~|[%~]\n|)%m:%(2L.#%L .)%1~ %{$fg[cyan]%}%#%{$reset_color%} '
# RPROMPT=$'%(6~||[%~])'
PROMPT=$'%m:%(2L.#%L .)%1~ %{$fg[cyan]%}%#%{$reset_color%} '
RPROMPT=$'[%~]'

# Set Shell options
#setopt auto_cd
setopt auto_param_slash auto_name_dirs auto_param_keys
setopt mark_dirs list_types
setopt extended_history hist_ignore_dups hist_ignore_space share_history
setopt no_beep always_last_prompt
setopt interactive_comments
setopt cdable_vars sh_word_split pushd_ignore_dups
setopt prompt_subst
# set the option of hide RPROMPT to copy the string in terminal
#setopt transient_rprompt

# Set Keybind
bindkey -e

# Alias and functions
alias copy='cp -ip' del='rm -i' move='mv'
alias fullreset='echo "\ec\ec"'
alias .='source'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias zshrc='. ~/.zshrc'
alias zshenv='. ~/.zshenv'

# Suffix aliases
alias -s rb=ruby py=python

# Using Completion
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B> Completing %d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _complete # _approximate
zstyle ':completion:*' matcher-list '' 'm:{A-Z}={a-z}' '+m:{a-z}={A-Z}' \
  'r:|[-_.]=*' 'm:to=2'
zstyle ':completion:*' use-cache true
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'

zstyle ':completion:*:ruby:*' file-patterns '*.rb:ruby\ script *(-/):dir'
zstyle ':completion:*:python:*' file-patterns '*.py:python\ script *(-/):dir'
zstyle ':completion:*:platex:*' file-patterns '*.tex:tex --kanji=utf8:option *(-/):dir'
zstyle ':completion:*:dvi*:*' file-patterns '*.dvi:dvi *(-/):dir'
zstyle ':completion:*:open:*' file-patterns '*.pdf:pdf *(-/):dir' '*:all-files'
zstyle ':completion:*:date:*' fake '+%Y-%m-%d'
zstyle ':completion:*:make:*' file-patterns '*.c:files' '*.cpp:files'
zstyle ':completion:*:subl:*' file-patterns '*.*:files' '*:files'

autoload -Uz compinit && compinit
###


# Git status
#   作業ディレクトリがクリーンなら緑
#   追跡されていないファイルがあるときは黄色
#   追跡されているファイルに変更があるときは赤
#   変更あり+未追跡ファイルありで太字の赤
#
# ${fg[...]} や $reset_color をロード
autoload -U colors; colors

function rprompt-git-current-branch {

  local name st color

  [[ "$PWD" =~ '/\.git(/.*)?$' ]] && return

  # branch name
  name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
  [[ -z $name ]] && return

  # set color
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    color=${fg[green]}
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    color=${fg[yellow]}
  elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
    color=${fg_bold[red]}
  else
    color=${fg[red]}
  fi

  # # git diff origin/master HEAD
  # origin_diff='*'
  # git_remotes=($(git remote 2>/dev/null))
  # if [[ ${#git_remotes[@]} != 0 ]]; then
  #   git_remote=$(echo $git_remotes | cut -d ' ' -f 1)
  #   if [[ $(git diff $git_remote/master HEAD) != "" ]]; then
  #     origin_diff='(*)'
  #   fi
  # fi

  echo "${origin_diff} %{$color%}$name%{$reset_color%} "
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst
RPROMPT='`rprompt-git-current-branch`'$RPROMPT
