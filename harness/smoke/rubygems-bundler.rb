require_relative "lib/rubygems-bundler/version"

puts RubygemsBundler::VERSION
puts RubygemsBundler::VERSION.class
parts = RubygemsBundler::VERSION.split(".")
puts parts.length
puts parts.first
