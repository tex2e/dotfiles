
Scripts
==========

To use scripts, export PATH:

    export PATH="$PATH:$HOME/.dotfiles/bin"'



## color(1) -- ANSI color code cheat sheet

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/color.sh)

### Usage

`color` shows cheat sheet of color code.

    > color

### Description

display ANSI Color code (16colors)

#### Text attributes
- 0  All attributes off
- 1  Bold on
- 4  Underscore (on monochrome display adapter only)
- 5  Blink on
- 7  Reverse video on
- 8  Concealed on

#### Foreground colors
- 30   Black
- 31   Red
- 33   Brown
- 32   Green
- 34   Blue
- 35   Purple
- 36   Cyan
- 37   White

#### Background colors
- 40   Black
- 41   Red
- 42   Green
- 43   Yellow
- 44   Blue
- 45   Magenta
- 46   Cyan
- 47   White



## doc2unix(1) -- convert \r\n to \n

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/dos2unix.sh)

### SYNOPSIS

    doc2unix <file>...

### Usage

`doc2unix` convert \r\n to \n in the file(s).

    > doc2unix foo.txt




## extract(1) -- unzip file

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/extract.sh)

### SYNOPSIS

    extract <file>...

### Usage

`extract` unzips file.

    > extract foo.zip

suport for tar.bz2, tar.gz, bz2, rar, gz, tar, tbz2, tgz, zip, Z and 7z




## fakegit(1) -- Emulating "git clone" with other tools

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/fakegit.sh)

### SYNOPSIS

    fakegit clone [-b <branch_name>] <GitHub Repository URL> [<directory>]

### DESCRIPTION

The fakegit command provides psuedo "git clone" command only for GitHub repository,
which downloads files with curl, or wget.
This is useful for environments which is difficult to install git command.

### Usage

`fakegit` provides only "clone" command like `git clone`

    > fakegit clone https://github.com/hnw/fakegit

### Instant Usage

    > bash <(curl -L https://raw.github.com/TeX2e/dotfiles/master/bash/fakegit.sh) clone <URL>




## gitch(1) -- ssh/https switcher on git repository

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/gitch.sh)

### SYNOPSIS

    gitch [<remote>]

### Usage

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




## htmlenv(1) -- init html environment

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/htmlenvs/htmlenv.sh)

### Usage

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
        ├── lib/
        └── main.js




## install-sublime3(1) -- install sublime on Ubuntu without sudo/root

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/install-sublime3.sh)

**Note: this script only runs on Ubuntu.**

### SYNOPSIS

    install-sublime3 [<target> [<build>]]

- `target`    Default target is "/usr/local".
- `build`     build version. If not defined, tries to get the build into the
              Sublime Text 3 website.

### Usage

`install-sublime3` installs sublime text 3.
the sublime is installed to

    > install-sublime3

you can specify the installed directory.

    > install-sublime3 ~/usr/local

and also you can specify the sublime build version.

    > install-sublime3 ~/usr/local 3114




## jslib(1) -- javascript library install tool via shell script

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/jslibs/jslib.sh)

### SYNOPSIS

    jslib install <library>

### Usage

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

### settings

`bash/jslibs/settings.yml` has javascript library URLs.

    lib:
      jquery: http://code.jquery.com/jquery-2.2.1.min.js
      underscore: http://underscorejs.org/underscore-min.js




## mkdo(1) -- Compile C file and Execute

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/mkdo.sh)

### SYNOPSIS

    mkdo <file> [-c '<args>'] [-e '<args>'] [-o]

### Usage

`mkdo` compile C file and execute it.

    > mkdo foo

`-c` option can specify the compiling options.

`-e` option can specify the excution options.




## texenv(1) -- init LaTeX environment for writing reports

[code](https://github.com/tex2e/dotfiles/blob/master/bash/texenvs/texenv.sh)

### SYNOPSIS

    texenv [make]

### Usage

to create tex environment, type:

    texenv && make init

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




## todo(1) -- task management system

### SYNOPSIS

    todo
    todo -m <message>
    todo -d <number>

### Usage

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




## tree(1) -- list contents of directories in a tree-like format via shell script

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/tree.sh)

if you can install `tree` command via package installer, it is recommended.

### SYNOPSIS

    tree [-F] [-L level] [--] [directory]

### Usage

`tree` shows files and directories list recursively.

    > tree
    .
    ├── README.md
    ├── index.html
    └── js
        ├── lib
        │   └── underscore-min.js
        └── main.js

when a symbolic link is encountered, the format is like `name -> real-path`

    > tree
    .
    └── bin
        ├── texenv -> ../bash/texenvs/texenv.sh
        ├── todo -> ../bash/todo.sh
        └── tree -> ../bash/tree.sh

`tree -F` append a "/" for directories, a "\*" for executable files.

    > tree -F
    .
    └── ruby/
        └── 2.2.3-1/
            ├── usr/
            │   ├── bin/
            │   │   ├── cygruby220.dll*
            │   │   ├── erb*
            │   │   ├── irb*
            │   │   └── ruby.exe*
            │   ├── include/
            │   │   └── ruby-2.2.0/
            │   │       ├── ruby/
            │   │       │   ├── backward/
            │   │       │   ├── config.h
            │   │       │   ├── debug.h
    ...

`tree -L <number>` specifies a max display depth of the directory tree.

    > tree -F -L 3
    .
    └── ruby/
        └── 2.2.3-1/
            ├── usr/
            └── var/




## vipe(1) -- edit pipe

[code](https://github.com/TeX2e/dotfiles/blob/master/bash/vipe.sh)

### SYNOPSIS

    command | vipe | command

### DESCRIPTION

vipe allows you to run your editor in the middle of a unix pipeline
edit the data that is being piped between programs.
