# dotfiles


Installation
------------

~~~ bash
git clone https://github.com/TeX2e/dotfiles
mv dotfiles/ .dotfiles/
cd .dotfiles/
make rc
~~~

if `git` command is not installed, type following:

~~~bash
sh <(curl -L https://raw.github.com/TeX2e/dotfiles/master/bash/fakegit.sh) \
    clone https://github.com/TeX2e/dotfiles
mv dotfiles/ .dotfiles/
cd .dotfiles/
make rc
~~~


Makefile
----------

Usage:

    make rc atom git rake

+ `rc`
    create symbolic links.
    After running this command, your home directory has a symbolic link
    which links to run-command file such as .bash_profile and .bashrc in .dotfiles/

+ `rc-f`
    create symbolic link with --force

+ `atom`
    link to your atom/snippets.cson
    and install atom packages (ATOM_PKG_LIST)

+ `git`
    set a useful git aliases

+ `rake`
    create ~/.rake directory and set global rakefile

+ `rake-f`
    create ~/.rake with --force


Scripts
----------


### todo(1) -- task management system

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/todo.sh)

#### SYNOPSIS

    todo [-l]
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

    > jslib install jquery

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

    > chtabsize 4 2 sample.rb


### gitch(1) -- ssh/https switcher on git repository

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/gitch.sh)

#### SYNOPSIS

    gitch [<branch>]

#### Usage

`gitch` switch the access protocol between https and ssh.

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

    > fakegit clone https://github.com/hnw/fakegit


### color(1) -- color code cheat sheet

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/color.sh)

#### Usage

    > color
