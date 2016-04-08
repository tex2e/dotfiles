#!/usr/bin/env ruby

# strip indentation
class String
  def dedent
    margin = self.scan(/^ +/).map(&:size).min
    self.gsub(/^ {#{margin}}/, '')
  end
end

# chtabsize -- change softtab size
#
# SYNOPSIS
#
#   chtabsize <before> <after> <filename>
#
def usage
  puts <<-EOS.dedent
    Overview:
      change softtab size

    Usage:
      chtabsize <before> <after> <filename...>

  EOS
  exit
end

# convert softtab width
#
# parameters
# * before - {int} actual softtab size
# * after  - {int} expected softtab size
# * line   - {string} each line
#
def convert_softtab_width(before, after, line)
  before_softtab = " " * before
  after_softtab  = " " * after

  match0 = line.match(/^(#{before_softtab})*/).to_a[0]
  indent_depth = match0.length / before

  if indent_depth > 0
    line.sub!(/^(#{before_softtab})+/, after_softtab * indent_depth)
  end

  return line
end

# --- main process ---

if ARGV.length == 0
  usage
end

unless ARGV.length >= 3
  raise ArgumentError.new("wrong number of arguments (given #{ARGV.length}, expected 3..")
end

actual   = ARGV.shift.to_i  # actual_softtab_size
expected = ARGV.shift.to_i  # expected_softtab_size

ARGV.each do |arg|
  unless File.exist?(arg)
    puts "No such file or directory: #{arg}"
    break
  end

  lines = []

  # convert softtab width
  File.open(arg, 'r') do |f|
    f.each do |line|
      line = convert_softtab_width(actual, expected, line)
      lines.push(line)
    end
  end

  # write result to origin file
  File.open(arg, 'w') do |f|
    f.write(lines.join)
  end
end
