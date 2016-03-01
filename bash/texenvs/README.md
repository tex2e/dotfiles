TeX Enviroment Initializer
===========================

To set a directory which has TeX enviroment, type following commands:

    texenv
    make init
    
or one liner:

    texenv && make init

texenv.sh
-----------

This texenv.sh is an executable file in bash.
It is recommended to put a `texenv` symbolic link to the texenv.sh
on a path set in $PATH enviroment.
Executing this script like `texenv`, it creates a symbolic link to Makefile.mk.

The possible commands are as follows:

- `texenv     ` - create a symbolic link to Makefile.mk. (Recommended)
- `texenv make` - same above.
- `texenv rake` - create a symbolic link to Rakefile.mk.

After running a command `texenv`, `make init` and `make pdf`, a directory which has a Makefile consists of:

    .
    ├── Makefile -> ~/.dotfiles/bash/texenvs/Makefile.mk
    ├── Rakefile -> ~/.dotfiles/bash/texenvs/Rakefile.rb  # when type `texenv rake`
    ├── images/
    ├── report.aux
    ├── report.dvi
    ├── report.fls
    ├── report.log
    ├── report.pdf
    └── report.tex

Makefile.mk
------------

This Makefile.mk defines a rule to make a pdf file from latex.
To use this to create a pdf, type `make pdf`.

The possible commands are as follows:

- `make init       ` - create a directory images/ and write a template tex file (default name is report.tex).
    When current directory has a same name, it asks that "overwrite a file (y/n)".
- `make init OUTPUT=filename.tex` - specify a filename to write a template.
- `make pdf        ` - create pdf from tex file.
- `make open       ` - create pdf and open it. (Require `open` command)
- `make punctuation` - replace "。" and "、" with "．" and "，"
- `make clean      ` - remove any temporary products such as .aux, .log and .dvi.
- `make distclean  ` - remove any generated file.
- `make help       ` - print the list of available commands.

Rakefile.rb
------------

You can also use `rake` commands to make a pdf from latex.
Type `texenv rake` to create a symbolic link to Rakefile.rb.
There is a difference between the two output.
However, the Rakefile.rb's rule behaves like Makefile.mk.

The possible commands are as follows:

- `rake clean  `  - remove any temporary products.
- `rake clobber`  - remove any generated file.
- `rake init   `  - create directory images/ and latex template file (default name is report.tex).
    When current directory has a same name, it asks that "overwrite a file (y/n)".
- `rake init OUTPUT=filename.tex` - specify a filename to write a template.
- `rake open   `  - create pdf and open it. (Require `open` command)
- `rake pdf    `  - create pdf from dvi file.
- `rake --tasks`  - print the list of available commands.

template.tex
------------

This template.tex will be set a latex template.
Typing `make init`, the script writes a latex template file
(copied the template.tex) in the current directory.
