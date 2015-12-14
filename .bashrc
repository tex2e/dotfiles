export PS1='\h:\W \$ '
export PS2='> '

# useful alias
alias ls='ls -F'
alias la='ls -A'
alias ll='ls -l'
alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias bashrc='. ~/.bashrc'
alias bash_profile='. ~/.bash_profile'
alias fd='find . -type d -name'
alias ff='find . -type f -name'
alias gitlog='git log --oneline --decorate --graph'
mkdircd() {
	mkdir -p "$@" && cd "$1"
}
mkdirpu() {
	mkdir -p "$@" && pushd "$1"
}

CLEAR='\033[0m'
BOLD='\033[1m'
ULINE='\033[4m'

case `uname` in
	Darwin ) # mac os
		:
		;;
	Linux )
		source ~/.ubuntu.bashrc

		# # create .xmodmap file
		# xmodmap -pke> "~/.xmodmap"
		# vim ~/.xmodmap
		#
		#   keycode 37 = Control_L NoSymbol Control_L        #ctrl
		#   keycode 66 = Caps_Lock NoSymbol Caps_Lock   #caps lock
		#   clear Lock
		#   add Control = Control_L
		#
		xmodmap ~/.xmodmap
		;;
esac

