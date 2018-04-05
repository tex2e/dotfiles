
Scripts
==========

To use scripts, export PATH:

    export PATH="$PATH:$HOME/.dotfiles/bin"




## color(1) -- ANSI color code cheat sheet

[code](color.sh)

### SYNOPSIS

    color

### Description

display ANSI Color code sheet (16colors)

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




## extract(1) -- unzip file

[code](extract.sh)

### SYNOPSIS

    extract <file>...

### Description

unzip file which support as follows.
- tar.bz2
- tar.gz
- bz2
- rar
- gz
- tar
- tbz2
- tgz
- zip
- Z
- 7z

### Usage

`extract` unzips file.

    > extract foo.zip




## fakegit(1) -- Emulating "git clone" with other tools

[code](fakegit.sh)

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




## git-open(1) -- Open repository's origin site

[code](git-open.sh)

### SYNOPSIS

    git-open [--dry-run] [<remote>]

### Description

Open an repository's origin site.




## git-protocol(1) -- change protocol of git repository's remote

[code](git-protocol.sh)

### SYNOPSIS

    git-protocol <command> [<remote>]

### Description

Change protocol of git repository's remote.
If you give "switch" as command, switch the git access protocol between https and ssh.
If "secure" is as command, set url to https in place of http.
Without second argument "remote", set "origin" to remote by default.

### Usage

    > git remote -v
    origin	http://github.com/TeX2e/test (fetch)
    origin	http://github.com/TeX2e/test (push)

    > git protocol secure origin
     ✔ Change origin URL...OK
    new remote:
    origin	https://github.com/TeX2e/test (fetch)
    origin	https://github.com/TeX2e/test (push)

    > git protocol switch origin
     ✔ Change origin URL...OK
    new remote:
    origin	git@github.com:TeX2e/test (fetch)
    origin	git@github.com:TeX2e/test (push)





## htmlenv(1) -- init html environment

[code](htmlenvs/htmlenv.sh)

### Description

`htmlenv` creates a general html structure and writes templates.

### Usage

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




## img-compress(1) -- Compress image files under cwd

[code](img-compress.sh)

### SYNOPSIS

    img-compress [<path/to/dir>]

### Description

Compress image files under current working directory.




## mkdo(1) -- Compile C file and Execute

[code](mkdo.sh)

### SYNOPSIS

    mkdo <file> [-c '<args>'] [-e '<args>'] [-o]

### Description

compile C file and execute it.
`mkdo foo.c` == `make foo && ./foo`

### Usage

`mkdo` compile C file and execute it.

    > mkdo foo

`-c` option can specify the compiling options.

`-e` option can specify the excution options.




## path(1) -- split paths into each line

[code](path.sh)

### SYNOPSIS

    path [-f|f|fun|func|function|fpath] [-m|man|manual|manpath]
         [-c|-cd|cd|cdpath]

### Description

contents of PATH, CDPATH, FPATH (zsh function path) and manpath are difficult to
read because each paths are joined with ":", so split paths into each line and
show them.




## rm-history(1) -- Remove shell history

[code](rm-history.sh)

### SYNOPSIS

    rm-history [<regex>]

### Description

From history,
- Remove last command if no argument specified.
- Remove commands mathced given regex.




## sweep(1) -- Sweep MacOS metadata under cwd (only MacOS)

[code](sweep.sh)

### SYNOPSIS

    sweep [<path/to/dir>]

### Description

Delete .DS_Store and delete extended attribute keys which added to files.




## texenv(1) -- init LaTeX environment for writing reports

[code](texenvs/texenv.sh)

### SYNOPSIS

    texenv [make]

### Description

init LaTeX environment for writing reports.

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




## todo(1) -- A command line todo manager

[code](todo.sh)

### SYNOPSIS

    todo
    todo -m <message>
    todo -d <number>

### Description

`todo` is a command line todo list manager.
It maintains a list of tasks that you want to do, allowing you to add/remove them.

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

[code](tree.sh)

it is recommended to install `tree` command via package installer.

### SYNOPSIS

    tree [-F] [-L level] [--] [directory]

### Description

`tree` is a recursive directory listing program.
With no arguments, `tree` recursively lists a files in the current directory.
When directory argument is given, `tree` recursively lists all the files
in given directory.

By default, when a symbolic link is encountered,
the path that the symbolic link refers to is printed after the name of the
link in the format: "path -> real-path"

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


