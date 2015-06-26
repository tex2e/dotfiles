
###
# Set Shell variable
HISTSIZE=1000 HISTFILE=~/.zsh_history SAVEHIST=180
PROMPT="${HOST%%.*}:%2(L.#%L .)%1~ %# "
RPROMPT='[%~]'

# Set Shell options
setopt auto_cd auto_remove_slash auto_name_dirs
setopt extended_history hist_ignore_dups hist_ignore_space prompt_subst
setopt extended_glob list_types no_beep always_last_prompt
setopt cdable_vars sh_word_split auto_param_keys pushd_ignore_dups

# Alias and functions
alias copy='cp -ip' del='rm -i' move='mv'
alias fullreset='echo "\ec\ec"'
h () { history $* | less }
alias ja='LANG=ja_JP.UTF-8'
alias ls='ls -F'
alias la='ls -a'
alias ll='ls -la'
alias .='source'
alias zshrc='. ~/.zshrc'
alias zshenv='. ~/.zshenv'
mkdircd () { mkdir -p "$@" && cd "$*[-1]" }
mkdirpu () { mkdir -p "$@" && pushd "$*[-1]" }
alias push=pushd pop=popd dirs='dirs -v'

# Suffix aliases
alias -s rb=ruby py=python

# Using Completion
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B> Completing %d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*' matcher-list '' 'm:{A-Z}={a-z}' '+m:{a-z}={A-Z}' \
	'r:|[-_.]=*' 'm:to=2'
zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*:ruby:*' file-patterns '*.rb:ruby\ script *(-/):dir'
zstyle ':completion:*:python:*' file-patterns '*.py:python\ script *(-/):dir'
zstyle ':completion:*:platex:*' file-patterns '*.tex:tex --kanji=utf8:option *(-/):dir'
zstyle ':completion:*:dvi*:*' file-patterns '*.dvi:dvi *(-/):dir'
zstyle ':completion:*:open:*' file-patterns '*.pdf:pdf *(-/):dir' '*:all-files'
zstyle ':completion:*:date:*' fake '+%Y-%m-%d'

autoload -Uz compinit && compinit
###


# c compile and execute
function runcpp () {
	g++ -x c $1 && shift && ./a.out $@
}
alias -s {c,cpp}=runcpp


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

	name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
	[[ -z $name ]] && return

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

	echo "%{$color%}$name%{$reset_color%} "
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

RPROMPT='[`rprompt-git-current-branch`%~]'









