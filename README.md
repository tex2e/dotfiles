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

    The MIT License

    Copyright (c) 2016 @TeX2e

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
