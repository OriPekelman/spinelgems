# frozen_string_literal: true
require 'file_exists'

# file_exists adds File.exists? and Dir.exists? as aliases for exist?
# Test with known paths that exist and don't exist.

existing_file = __FILE__
missing_file  = '/this/path/does/not/exist/at/all.rb'

puts File.exists?(existing_file)   # true — smoke script itself exists
puts File.exists?(missing_file)    # false

existing_dir = File.dirname(__FILE__)
missing_dir  = '/no/such/directory/anywhere'

puts Dir.exists?(existing_dir)     # true
puts Dir.exists?(missing_dir)      # false

# Confirm aliases match exist? results
puts File.exists?(existing_file) == File.exist?(existing_file)   # true
puts Dir.exists?(existing_dir)   == Dir.exist?(existing_dir)     # true
