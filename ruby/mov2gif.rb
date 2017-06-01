#!/usr/bin/env ruby

require 'tmpdir'

if ARGV.length != 3
  puts "mov2gif: Create animation GIF"
  puts "Usage: mov2gif 1 input.mov output.gif     -- normal (x1)"
  puts "Usage: mov2gif 2 input.mov output.gif     -- faster (x2)"
  puts "Usage: mov2gif 0.5 input.mov output.gif   -- slower (x0.5)"
  abort
end

rate = ARGV[0].to_f
movname = ARGV[1]
gifname = ARGV[2]

Dir.mktmpdir do |tmpdir|
  cmd = "ffmpeg -i #{movname} -r 24 #{tmpdir}/%05d.png"
  puts cmd
  system(cmd)
  cmd = "convert -delay #{10 / rate} -loop 0 #{tmpdir}/*.png #{gifname}"
  puts cmd
  system(cmd)
end
