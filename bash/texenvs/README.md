TeX Enviroment Initializer
===========================

texenv.sh
-----------

This texenv.sh is executable file on bash.
It is recommended to put a `texenv` symbolic link to the texenv.sh on path set in $PATH enviroment.
Executing this script like `texenv`, it creates a symbolic link to Makefile.mk.

Available commands are as follows:

- `texenv     ` - create a symbolic link to Makefile.mk.
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

This Makefile.mk is defined a rule to make pdf file from latex.
To use this to create a pdf, type `make pdf`.

Available commands are as follows:

- `make init      ` - create a directory images/ and write a template tex file (default name is report.tex).
    When current directory has a same name, it ask that "overwrite a file (y/n)".
- `make init OUTPUT=filename.tex` - specify a filename to write a template.
- `make pdf       ` - create pdf from tex file.
- `make open      ` - create pdf and open it.
- `make clean     ` - remove any temporary products such as .aux, .log and .dvi.
- `make distclean ` - remove any generated file.
- `make help      ` - show available commands.

Rakefile.rb
------------

You can also use `rake` commands to make pdf from latex.
Type `texenv rake` to create a symbolic link to Rakefile.rb.
There is a difference between two output.
However, the Rakefile.rb's rule is behaved like Makefile.mk.

Available commands are as follows:

- `rake clean  `  - remove any temporary products.
- `rake clobber`  - remove any generated file.
- `rake init   `  - create directory images/ and latex template file (default name is report.tex). 
    When current directory has a same name, it ask that "overwrite a file (y/n)".
- `rake init OUTPUT=filename.tex` - specify a filename to write a template.
- `rake open   `  - create pdf and open it.
- `rake pdf    `  - create pdf from dvi file.
- `rake --tasks`  - show available commands.

template.tex
------------

This template.tex will be set a latex template.
Typing `make init`, the script writes a latex template file (copied the template.tex) in current directory.



