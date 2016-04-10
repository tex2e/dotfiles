# dotfiles


Installation
-------------

~~~ bash
git clone https://github.com/TeX2e/dotfiles
mv dotfiles/ .dotfiles/
cd .dotfiles/
make zsh
~~~

if `git` command is not installed, type following instead of `git clone ...`:

~~~bash
sh <(curl -L https://raw.github.com/TeX2e/dotfiles/master/bash/fakegit.sh) \
    clone https://github.com/TeX2e/dotfiles
~~~


Directories
------------

    .
    ├── Makefile       # create symlinks or config settings
    ├── atom/          # atom settings
    ├── bash/          # bash scripts
    ├── bin/           # executable (symlinks)
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

+ `path-f`
    do `make path` with --force

+ `bash`
    create symlinks which link to .bash_profile and .bashrc into home dir

+ `bash-f`
    do `make bash` with --force

+ `zsh`
    create symlinks which link to .zshenv and .zshrc into home dir

+ `zsh-f`
    do `make zsh` with --force

+ `atom`
    link to your atom/snippets.cson
    and install atom packages (ATOM_PKG_LIST)

+ `vim`
    create vim settings

+ `git`
    set a useful git aliases

+ `rake`
    create ~/.rake directory and set global rakefile

+ `rake-f`
    do `make rake` with --force



Scripts
----------

To use scripts, export PATH:

    export PATH="$PATH:$HOME/.dotfiles/bin"


### todo(1) -- task management system

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/todo.sh)

#### SYNOPSIS

    todo
    todo -m <message>
    todo -d <number>

#### Usage

`todo -m <message>` creates a todo task.

    > todo -m 'Do my assignment'
    todo << Do my assignment
    > todo -m 'Clean room'
    todo << Clean room

`todo` shows todo list.

    > todo
    todo list :
         1  Do my assignment
         2  Clean room

`todo -d <number>` deletes a specified todo task.

    > todo -d 1
    done >> Do my assignment


### texenv(1) -- init LaTeX environment for writing reports

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/texenvs/texenv.sh)

#### SYNOPSIS

    texenv [make]

#### Usage

`texenv` creates a symbolic link to Makefile.mk

    > texenv
    linking Makefile ... done
    > make init
    creating directory images/ ... done
    writing template tex file ...
    OUTPUT=report.tex
    cp -i "~/.dotfiles/bash/texenvs"/template.tex ~/path/to/dir/report.tex || true

    > tree
    .
    ├── Makefile -> ~/.dotfiles/bash/texenvs/Makefile.mk
    ├── images/
    └── report.tex

    1 directory, 2 files

further infomation is in [bash/texenvs](https://github.com/TeX2e/dotfiles/blob/master/bash/texenvs/)


### htmlenv(1) -- init html environment

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/htmlenvs/htmlenv.sh)

#### Usage

`htmlenv` creates a general html structure and writes templates.

    > htmlenv
    writing index.html ... done
    writing css/normalize.css ... done
    writing css/common.css ... done
    writing js/main.js ... done

    > tree
    .
    ├── css/
    │   ├── common.css
    │   └── normalize.css
    ├── index.html
    └── js/
        └── main.js

    2 directories, 4 files

further infomation is in [bash/htmlenvs](https://github.com/TeX2e/dotfiles/blob/master/bash/htmlenvs/)


### jslib(1) -- javascript library install tool via shell script

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/jslibs/jslib.sh)

#### SYNOPSIS

    jslib install <library>

#### Usage

`jslib` downloads a specified javascript library.

    > jslib install jquery
    install to path/to/dir/jquery-2.2.1.min.js

if current directory has `js/lib/` or `javascript/lib/` directory, downloads to there.

    > tree
    .
    └── javascript/
        └── lib/

    > jslib install jquery
    install to path/to/dir/javascript/lib/jquery-2.2.1.min.js

#### settings

`bash/jslibs/settings.yaml` has javascript library URLs.

    lib:
      jquery: http://code.jquery.com/jquery-2.2.1.min.js
      underscore: http://underscorejs.org/underscore-min.js


### chtabsize(1) -- change soft tab size

[code](https://github.com/TeX2e/dotfiles/blob/master/ruby/change-softtab-size.rb)

#### SYNOPSIS

    chtabsize <from-width> <to-width> <file...>

#### Usage

`chtabsize` changes a soft tab size. following example is changing from 4 to 2.

    > chtabsize 4 2 sample.rb


### gitch(1) -- ssh/https switcher on git repository

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/gitch.sh)

#### SYNOPSIS

    gitch [<remote>]

#### Usage

`gitch` switch the access protocol between https and ssh.
default remote is "origin".

    > git remote -v
    github	git@github.com:TeX2e/test (fetch)
    github	git@github.com:TeX2e/test (push)
    origin	https://github.com/TeX2e/test (fetch)
    origin	https://github.com/TeX2e/test (push)

    > gitch
     ✔ Change origin URL...OK
    new remote:
    github	git@github.com:TeX2e/test (fetch)
    github	git@github.com:TeX2e/test (push)
    origin	git@github.com:TeX2e/test (fetch)
    origin	git@github.com:TeX2e/test (push)

    > gitch github
     ✔ Change origin URL...OK
    new remote:
    github	https://github.com/TeX2e/test (fetch)
    github	https://github.com/TeX2e/test (push)
    origin	git@github.com:TeX2e/test (fetch)
    origin	git@github.com:TeX2e/test (push)


### fakegit(1) -- do "git clone" without git

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/fakegit.sh)

#### SYNOPSIS

    fakegit clone [-b <branch_name>] <GitHub Repository URL> [<directory>]

#### Usage

`fakegit` provides only "clone" command like `git clone`

    > fakegit clone https://github.com/hnw/fakegit


### color(1) -- color code cheat sheet

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/color.sh)

#### Usage

`color` shows cheat sheet of color code.

    > color


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
