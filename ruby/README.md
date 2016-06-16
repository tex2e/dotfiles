
Scripts
==========

To use scripts, export PATH:

    export PATH="$PATH:$HOME/.dotfiles/bin"'




## chtabsize(1) -- change soft tab size

[code](https://github.com/TeX2e/dotfiles/blob/master/ruby/chtabsize.rb)

### SYNOPSIS

    chtabsize <from-width> <to-width> <file...>

### Usage

`chtabsize` changes a soft tab size. following example is changing from 4 to 2.

    > chtabsize 4 2 sample.rb




## gsub(1) -- global substitute in files

[code](https://github.com/TeX2e/dotfiles/blob/master/ruby/gsub.rb)

### SYNOPSIS

    gsub <regex> <replacement> <file>...

### Usage

`gsub` do global-substitute in files via Ruby regexp.
following example is to put all vocals in brackets in all .txt files.

    > gsub '([aeiou])' '<\\1>' */*.txt




## rdoc2md(1) -- convert rdoc to markdown

### SYNOPSIS

    rdoc2md [<rdoc file>]

### Usage

    ruby rdoc2md.rb > README.md
    ruby rdoc2md.rb ABC.rdoc > abc.md


