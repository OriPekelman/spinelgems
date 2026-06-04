require 'mickey_goldmill'
require 'mickey_goldmill/version'

# MickeyGoldmill is a Rails generator gem; its public API is entirely
# Rails::Generators::Base subclasses. The only standalone Ruby content
# is the module declaration and version constant.

puts MickeyGoldmill::VERSION
puts MickeyGoldmill.is_a?(Module)
puts MickeyGoldmill.name
