
Scripts
==========

To use scripts, export PATH:

    export PATH="$PATH:$HOME/.dotfiles/bin"




## chtabsize(1) -- change soft tab size

[code](chtabsize.rb)

### SYNOPSIS

    chtabsize <from-width> <to-width> <file...>

### Usage

`chtabsize` changes a soft tab size. following example is changing from 4 to 2.

    > chtabsize 4 2 sample.rb




## rdoc2md(1) -- convert rdoc to markdown

[code](rdoc2md.rb)

### SYNOPSIS

    rdoc2md [<rdoc file>]

### Usage

    ruby rdoc2md.rb > README.md
    ruby rdoc2md.rb ABC.rdoc > abc.md




## wordtest(1) -- test your vocabulary

[code](wordtest.rb)

### Usage

    wordtest

press `↓` or space key to go to next day.
`↑` key to go to previous day.
`→` key to go to next week.
`←` key to go to previous week.
`Ctrl+c` or `Ctrl+d` to exit.


