#!/usr/bin/env ruby
#:readme:
#
# ## rdoc2md(1) -- convert rdoc to markdown
#
# ### SYNOPSIS
#
#     rdoc2md [<rdoc file>]
#
# ### Usage
#
#     ruby rdoc2md.rb > README.md
#     ruby rdoc2md.rb ABC.rdoc > abc.md
#

require 'rdoc'
converter = RDoc::Markup::ToMarkdown.new
rdoc = File.read(ARGV[0] || 'README.rdoc')
puts converter.convert(rdoc)
