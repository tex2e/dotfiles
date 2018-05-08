#!/usr/bin/env ruby

require 'securerandom'

len = (ARGV[0]) ? ARGV[0].to_i : 10
puts SecureRandom.random_number(10 ** len)
