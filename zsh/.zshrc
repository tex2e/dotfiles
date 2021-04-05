
### Variable ###

export EDITOR=vim
# export LANG=en_US.UTF-8
export LANG=ja_JP.UTF-8
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=2000
PROMPT=$'%m%(2L.#%L.) %1~ %{$fg[cyan]%}%#%{$reset_color%} '
HISTORY_IGNORE="(ls*|cd|pwd|exit|cd ..|git ss|git aa)"
# Don't consider certain characters part of the word
WORDCHARS=${WORDCHARS//\/}
# hide EOL sign ('%')
PROMPT_EOL_MARK=""
export HOMEBREW_NO_INSTALL_CLEANUP=1


### Options ###

setopt always_last_prompt
unsetopt auto_name_dirs
unsetopt auto_param_keys
setopt auto_param_slash
unsetopt beep
unsetopt extended_history
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history
setopt ignore_eof
setopt interactive_comments
setopt list_types
setopt mark_dirs
setopt prompt_subst       # enable command substitution in prompt
setopt sh_word_split
unsetopt nomatch          # for rake arguments like `rake subcomand[args]`
setopt magic_equal_subst  # enable filename expansion after equal
setopt notify             # report background job status immediately


### Key Mapping ###

if [[ -f "$HOME/.Xmodmap" ]]; then
  # To avoid error "xmodmap: unable to open display 'localhost:0.0'"
  export DISPLAY=:0.0
  export LIBGL_ALWAYS_INDIRECT=1
  # keymapping
  xmodmap "$HOME/.Xmodmap" &> /dev/null
fi
# configure key keybindings
bindkey -e                                      # Emacs key bindings
bindkey ' ' magic-space                         # do history expansion on space
bindkey '^[[3;5~' kill-word                     # ctrl + Supr
bindkey '^[[3~' delete-char                     # delete
bindkey '^[[1;5C' forward-word                  # ctrl + ->
bindkey '^[[1;5D' backward-word                 # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history  # page up
bindkey '^[[6~' end-of-buffer-or-history        # page down
bindkey '^[[H' beginning-of-line                # home
bindkey '^[[F' end-of-line                      # end
bindkey '^[[Z' undo                             # shift + tab undo last action


### Functions ###

mkdircd() {
  command mkdir -p "$1" && cd "$1"
}
touch00() {
  touch -t $(date +%m%d0000) $*
}


### Alias ###

source ~/.alias
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Git Bash
if which explorer.exe &>/dev/null; then
  alias open='explorer'
fi
# Ubuntu
if [[ `uname` = "Linux" ]]; then
  alias open='xdg-open 2>/dev/null'
fi
# Bash on Windows
if [[ `uname` = "Linux" ]] && [[ -d /mnt/c ]]; then
  alias open='cmd.exe /c start'
fi


### Completion ###

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

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

autoload -Uz compinit && compinit -d ~/.cache/zcompdump

# Color
autoload -Uz colors && colors


### Git Status ###

# Show Git Status in ZSH Prompt via vcs_info
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


### Others ###

# Google Cloud SDK
if [[ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi

# opam configuration
if [[ -r /mnt/c/Users/mnfec/.opam/opam-init/init.zsh ]]; then
  . /mnt/c/Users/mnfec/.opam/opam-init/init.zsh
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# override default virtualenv indicator in prompt
VIRTUAL_ENV_DISABLE_PROMPT=1
venv_info() {
  [ $VIRTUAL_ENV ] && echo "(%B%F{reset}$(basename $VIRTUAL_ENV)%b%F{%(#.blue.green)})"
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)──}$(venv_info)(%B%F{%(#.red.blue)}%n%(#.💀.㉿)%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
  # RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'

  # enable syntax-highlighting
  # git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/zsh-syntax-highlighting
  if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && [ "$color_prompt" = yes ]; then
    . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
    ZSH_HIGHLIGHT_STYLES[default]=none
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[path]=underline
    ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[command-substitution]=none
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[process-substitution]=none
    ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[assign]=none
    ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
    ZSH_HIGHLIGHT_STYLES[named-fd]=none
    ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
    ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
    ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
  fi
else
  PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
  TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a'
  ;;
esac

new_line_before_prompt=no
precmd() {
  # Print the previously configured title
  print -Pnr -- "$TERM_TITLE"

  # Print a new line before the prompt, but only if it is not the first line
  if [ "$new_line_before_prompt" = yes ]; then
    if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
      _NEW_LINE_BEFORE_PROMPT=1
    else
      print ""
    fi
  fi
}

# Enable color support of ls, less and man, and also add handy aliases.
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias diff='diff --color=auto'
  alias ip='ip --color=auto'

  export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
  export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
  export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
  export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
  export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
  export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
  export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

  # Take advantage of $LS_COLORS for completion as well
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# Enable auto-suggestions based on the history.
# git clone https://github.com/zsh-users/zsh-autosuggestions /usr/share/zsh-autosuggestions
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  # change suggestion color
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# Enable command-not-found if installed.
# sudo apt-get install command-not-found
if [ -f /etc/zsh_command_not_found ]; then
  . /etc/zsh_command_not_found
fi
