# dotfiles


Installation
-------------

~~~ bash
git clone https://github.com/TeX2e/dotfiles .dotfiles
cd .dotfiles
make zsh  # optional
~~~

if `git` command is not installed, type following instead of `git clone ...`:

~~~bash
function download {
  local url=$1
  if which wget &>/dev/null; then
    wget "$url"
  elif which curl &>/dev/null; then
    curl -O "$url"
  fi
}
download https://raw.githubusercontent.com/TeX2e/dotfiles/master/bash/fakegit.sh
chmod +x ./fakegit.sh
./fakegit.sh clone https://github.com/TeX2e/dotfiles.git
~~~

Directories
------------

    .
    ├── Makefile       # create symlinks or config settings
    ├── atom/          # atom settings
    ├── bash/          # bash scripts
    ├── bin/           # executable (symlinks)
    ├── git/           # git setting files
    ├── python/        # python scripts
    ├── rake/          # global rakefiles
    ├── ruby/          # ruby scripts
    ├── vim/           # vim settings
    └── zsh/           # zsh settings


Makefile
----------

Usage:

    make zsh

+ `path`
    create symlinks which link to .path which contains exported PATH list

+ `bash`
    create symlinks which link to .bash_profile and .bashrc into home dir

+ `zsh`
    create symlinks which link to .zshenv and .zshrc into home dir

+ `atom`
    link to your atom/snippets.cson
    and install atom packages (ATOM_PKG_LIST)

+ `vim`
    create vim settings

+ `git`
    create git settings

+ `rake`
    create ~/.rake directory and set global rakefile

+ `<command>-f`
    do `make <command>` with --force


License
--------

    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
        Version 2, December 2004

    Copyright (C) 2016 @TeX2e

    Everyone is permitted to copy and distribute verbatim or modified
    copies of this license document, and changing it is allowed as long
    as the name is changed.

    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

    0. You just DO WHAT THE FUCK YOU WANT TO.
