# dotfiles

This is a repository with my configuration files.
"Easy to deploy, maintain and develop" is my motto.

Requirements
-------------

- **Git** (if you are not a sudoer, see
  [tex2e/picnic](https://github.com/tex2e/picnic) to install git)
- **Bash**
- **Zsh**
- **curl** or **wget**
- **gawk** (for making document)
- **Vim**
- **Ruby** 2.0+
- **Python** 3.5+


Installation
-------------

~~~ bash
git clone https://github.com/TeX2e/dotfiles ~/.dotfiles
cd ~/.dotfiles
make zsh-f
~~~


Structure
------------

    .
    ├── atom/              # atom settings
    │   └── snippets.cson
    ├── bash/              # bash scripts
    │   ├── .bash_profile
    │   ├── .bashrc
    │   └── .ubuntu.bashrc
    ├── bin/               # executable (symlinks)
    ├── fish/              # fish settings
    ├── git/               # git setting files
    ├── python/            # python scripts
    ├── rake/              # global rakefiles
    ├── ruby/              # ruby scripts
    ├── sublime/           # sublime packages
    ├── vim/               # vim settings
    │   ├── .vim/
    │   └── .vimrc
    ├── xmodmap/           # xmodmap settings
    ├── zsh/               # zsh settings
    │   ├── .zshenv
    │   └── .zshrc
    ├── .alias             # alias
    ├── .path              # export PATH
    └── Makefile           # create symlinks or config settings


Makefile
----------

Usage:

    make zsh

Rules:

+ `bash`
    create symlinks which link to .bash_profile and .bashrc into home dir

+ `zsh`
    create symlinks which link to .zshenv and .zshrc into home dir

+ `atom`
    create atom config
    and install atom packages (ATOM_PKG_LIST)

+ `vim`
    create vim settings

+ `git`
    create git settings

+ `rake`
    create ~/.rake directory and set global rakefile

+ `xmodmap`
    create xmodmap config

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
