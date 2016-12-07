#!/usr/bin/env ruby
#:readme:
#
# ## gen-c-doc-for-latex(1) -- create latex documentation from c file
#
# ### Require
#
# - kramdown (ruby gem)
#
# ### Usage
#
# For instance, there is one c file named "example.c":
#
# ~~~c
# /**
#  * Some explanations about following function.
#  * An explanation starts with `/**` will be documented.
#  */
# int main(int argc, char **argv) {
#     //...
# }
#
# /**
#  * This function has no return type.
#  */
# void reshape(int w, int h) {
#     //...
# }
#
# /**
#  * Though it has long return type, it seems to be okay.
#  */
# long long int bigNumber() {
#     //...
# }
# ~~~
#
# and latex \input{|"cmd"} can be call external command.
# Note that to do this, latex requires `-shell-escape` option when compiling.
#
# ~~~latex
# \begin{description}
# \input{|"gen-c-doc-for-latex path/to/example.c"}
# \end{description}
# ~~~
#
# This code results in:
#
# ~~~latex
# \begin{description}
# \item[ \texttt{ main(int argc, char **argv) $\to$ int  } ]~\\
# Some explanations about following function.An explanation starts with \texttt{/**} will be documented.
#
# \item[ \texttt{ reshape(int w, int h) } ]~\\
# This function has no return type.
#
# \item[ \texttt{ time() $\to$ long long int  } ]~\\
# \end{description}
# ~~~
#

require 'kramdown'

# 1. read source code file
# 2. extract function declaration and its document
# 3. format for latex

def gen_doc(file)
  File.read(file)
    .scan(%r{
      ^
      /\*\*
        (?<document> .*? )
      \*/ \s+
      ^
      (?<func_declaration> (?:\w+\s?){2,} \([^!@#$+%^]*?\) )
      }xm)
    .map do |match|
      document = match[0].gsub(/\n\s*\*\s*/, '').strip
      document = Kramdown::Document.new(document).to_latex
      return_type, function = match[1].match(%r{
        (?<return_type>
          (?:\w+\s){1,}
        )
        (?<function>
          (?:\w+\s?)\([^!@#$+%^]*?\)
        )
        }x).to_a[1,2]

      return_type = nil if return_type.match(/^void/)

      item = ""
      if return_type
        item << "\\item[ \\texttt{ #{function} $\\to$ #{return_type} } ]~\\\\\n"
      else
        item << "\\item[ \\texttt{ #{function} } ]~\\\\\n"
      end
      item << document
    end

rescue => e
  STDERR.puts e
  ""
end

file = ARGV[0]
raise ArgumentError, 'wrong number of arguments (expected 1)' if file.nil?
puts gen_doc(file)
