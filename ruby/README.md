
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




## gen-c-doc-for-latex(1) -- create latex documentation from c file

### Require

- kramdown (ruby gem)

### Usage

For instance, there is one c file named "example.c":

~~~c
/**
 * Some explanations about following function.
 * An explanation starts with `/**` will be documented.
 */
int main(int argc, char **argv) {
    //...
}

/**
 * This function has no return type.
 */
void reshape(int w, int h) {
    //...
}

/**
 * Though it has long return type, it seems to be okay.
 */
long long int bigNumber() {
    //...
}
~~~

and latex \input{|"cmd"} can be call external command.
Note that to do this, latex requires `-shell-escape` option when compiling.

~~~latex
\begin{description}
\input{|"gen-c-doc-for-latex path/to/example.c"}
\end{description}
~~~

This code results in:

~~~latex
\begin{description}
\item[ \texttt{ main(int argc, char **argv) $\to$ int  } ]~\\
Some explanations about following function.An explanation starts with \texttt{/**} will be documented.

\item[ \texttt{ reshape(int w, int h) } ]~\\
This function has no return type.

\item[ \texttt{ time() $\to$ long long int  } ]~\\
Though it has long return type, it seems to be okay.
\end{description}
~~~




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


