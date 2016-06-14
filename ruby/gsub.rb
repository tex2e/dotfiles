#!/usr/bin/env ruby
#:readme:
#
# ## gsub(1) -- global substitute in files
#
# [code](https://github.com/TeX2e/dotfiles/blob/master/ruby/gsub.rb)
#
# ### SYNOPSIS
#
#     gsub <regex> <replacement> <file>...
#
# ### Usage
#
# `gsub` do global-substitute in files via Ruby regexp.
# following example is to put all vocals in brackets in all .txt files.
#
#     > gsub '([aeiou])' '<\\1>' */*.txt
#

require 'fileutils'
require 'tempfile'

if ARGV.size < 3
  puts "global substitute in files"
  puts "usage: "
  puts "  gsub <regex> <replacement> <file>..."
  puts ""
  puts "example: put all vocals in brackets in all .txt files"
  puts "  gsub '([aeiou])' '<\\1>' *.txt"
  puts ""
  exit
end

regexp = Regexp.new(ARGV[0])
replacement = ARGV[1]
files = ARGV[2..-1]

files.each do |filename|
  next unless File.file?(filename)
  print "processing #{filename} ... "
  temp = Tempfile.new("file_sub")
  File.foreach(filename) do |line|
    temp << line.gsub(regexp, replacement)
  end
  temp.close
  FileUtils.move(temp.path, filename)
  puts "OK"
end
