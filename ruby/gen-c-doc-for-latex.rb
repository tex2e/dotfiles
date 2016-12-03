#!/usr/local/bin/ruby

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
      m = match[1].match(%r{
        (?<return_type>
          (?:\w+\s){1,}
        )
        (?<function>
          (?:\w+\s?)\([^!@#$+%^]*?\)
        )
        }x)
      return_type = (m[1] =~ /^void/) ? nil : m[1]
      function = m[2]

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
