export PS1='\h:\W \$ '
export PS2='> '
export CDPATH='~/Documents/pgm'
export PATH="${PATH}:${HOME}/.script"

case `uname` in
	Darwin ) # mac os
		export SUBL="~/Library/Application\ Support/Sublime\ Text\ 2/Packages/"
		;;
	Linux )
		# change caps lock keybind to ctrl
		setxkbmap -option ctrl:nocaps
		;;
esac

# MacPorts Installer addition on 2014-12-09_at_18:02:20: adding an appropriate PATH variable for use with MacPorts.
export PATH="${PATH}:/opt/local/bin:/opt/local/sbin"
# Finished adapting your PATH environment variable for use with MacPorts.


# ruby
if which rbenv > /dev/null; then
	path=(~/.rbenv/shims $path)
	eval "$(rbenv init -)"
fi

# python
if which pyenv > /dev/null; then
    export PYENV_ROOT="${HOME}/.pyenv"
    # export PATH=${PYENV_ROOT}/shims:${PATH}
    eval "$(pyenv init -)";
fi

. .bashrc
