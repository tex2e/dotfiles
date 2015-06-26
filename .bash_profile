export PS1='\h:\W \$ '
export PS2='> '
export CDPATH=:~/Documents/pgm
export PATH=$PATH":${HOME}/.script"

# ruby
eval "$(rbenv init -)"

export SUBL=~/Library/Application\ Support/Sublime\ Text\ 2/Packages/

# MacPorts Installer addition on 2014-12-09_at_18:02:20: adding an appropriate PATH variable for use with MacPorts.
export PATH=$PATH":/opt/local/bin:/opt/local/sbin"
# Finished adapting your PATH environment variable for use with MacPorts.

. .bashrc
