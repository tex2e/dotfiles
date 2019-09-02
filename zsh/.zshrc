
export PATH="/usr/local/opt/ruby/bin:$PATH"

# inherited from .bashrc
source ~/.bashrc

# show todo
if which todo &> /dev/null; then
  todo
fi

###
# Set Shell variable
HISTSIZE=1000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=1000
PROMPT=$'%m%(2L.#%L.) %1~ %{$fg[cyan]%}%#%{$reset_color%} '
HISTORY_IGNORE="(ls*|cd|pwd|exit|cd ..|git ss|git aa)"
export HOMEBREW_NO_INSTALL_CLEANUP=1

# Set Shell options
setopt always_last_prompt
unsetopt auto_name_dirs
unsetopt auto_param_keys
setopt auto_param_slash
unsetopt beep
unsetopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt SHARE_HISTORY
setopt ignore_eof
setopt interactive_comments
setopt list_types
setopt mark_dirs
setopt prompt_subst
setopt sh_word_split
setopt share_history
unsetopt nomatch # for rake arguments like: `rake subcomand[args]`

# Set Keybind
bindkey -e

# Alias and functions
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Using Completion
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B> Completing %d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _complete _prefix #_approximate
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z} r:|[-_.]=** m:to=2'
zstyle ':completion:*' use-cache true
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'

zstyle ':completion:*:ruby:*' file-patterns '*.rb:ruby-script' '*(-/):dir'
zstyle ':completion:*:python:*' file-patterns '*.py:python-script' '*(-/):dir'
zstyle ':completion:*:platex:*' file-patterns '*.tex:tex-file' '*(-/):dir'
zstyle ':completion:*:open:*' file-patterns '*.pdf:pdf-file' '*(-/):dir' '*:all-files'
zstyle ':completion:*:date:*' fake '+%Y-%m-%d'
zstyle ':completion:*:subl:*' file-patterns '*.*:files' '*:all-files'
zstyle ':completion:*:perl:*' file-patterns '*.pl:perl-script' '*.p6:perl6-script' '*:all-files'

autoload -Uz compinit && compinit
###

# Color
autoload -Uz colors && colors

# Show Git State in ZSH Prompt via vcs_info
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{yellow}" # ステージングした時に出す文字列
zstyle ':vcs_info:*' unstagedstr "%F{red}" # 変更がある時に出す文字列
zstyle ':vcs_info:*' formats "%F{green}%c%u%b%f" # 表示フォーマット
zstyle ':vcs_info:*' actionformats '%b|%a' # rebase時などの表示フォーマット
function _update_vcs_info_msg() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vsc_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _update_vcs_info_msg
RPROMPT='${vcs_info_msg_0_}'
