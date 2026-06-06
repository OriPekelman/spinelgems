# Smoke: ocra gem
# ocra is a Windows EXE packer for Ruby scripts (Windows-only tool).
# lib/ocra.rb intentionally exposes only Ocra::VERSION as a class; all real
# packing logic lives in the bin/ocra CLI script. The public require 'ocra'
# surface is exactly this one class with one constant.
require 'ocra'

puts Ocra::VERSION
puts Ocra.class

# VERSION is a string — exercise string splitting and integer conversion
v = Ocra::VERSION
parts = v.split('.')
puts parts.length
puts parts.map(&:to_i).map(&:to_s).join('.')
puts v.start_with?('1') ? 'v1-series' : 'other'
puts v.include?('.') ? 'has-dots' : 'no-dots'
puts v.size > 4 ? 'long' : 'short'
