# frozen_string_literal: true

require 'gzipped_tar'

# Exercise GZippedTar::Writer + GZippedTar::Reader round-trip
writer = GZippedTar::Writer.new
writer.add('hello.txt', 'Hello, world!')
writer.add('data/numbers.txt', "1\n2\n3\n")
blob = writer.output

puts blob.bytesize > 0 ? "write ok" : "write failed"
puts blob.encoding

# Read back individual files
reader = GZippedTar::Reader.new(blob)
puts reader.read('hello.txt')
puts reader.read('data/numbers.txt').strip

# Verify a missing path returns nil
result = reader.read('nonexistent.txt')
puts result.nil? ? "nil for missing" : "unexpected: #{result.inspect}"

# Write multiple files and verify all are accessible
writer2 = GZippedTar::Writer.new
%w[alpha beta gamma].each { |name| writer2.add("#{name}.txt", name.upcase) }
blob2 = writer2.output
reader2 = GZippedTar::Reader.new(blob2)
%w[alpha beta gamma].each { |name| puts reader2.read("#{name}.txt") }
