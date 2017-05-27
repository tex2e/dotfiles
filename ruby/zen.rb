#!/usr/bin/env ruby

require "open-uri"

puts open("https://api.github.com/zen").read
