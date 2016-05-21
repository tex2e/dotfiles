#!/usr/bin/env ruby
#
# rdoc2md -- convert rdoc to markdown
#
# Usage
#
#   ruby rdoc2md.rb > README.md
#   ruby rdoc2md.rb ABC.rdoc > abc.md

require 'rdoc'
converter = RDoc::Markup::ToMarkdown.new
rdoc = File.read(ARGV[0] || 'README.rdoc')
puts converter.convert(rdoc)
