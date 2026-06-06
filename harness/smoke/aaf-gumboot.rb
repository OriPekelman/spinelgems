# frozen_string_literal: true

# aaf-gumboot: AAF Rails bootstrap helpers gem
# Public surface that loads without Rails/ActiveSupport/Mysql2:
#   Gumboot module + Gumboot::VERSION
# Gumboot::Strap requires active_support (deep_merge) and is Rails-only.

require 'aaf-gumboot'

# Module identity
puts Gumboot.class
puts Gumboot.name

# Version constant
puts Gumboot::VERSION
puts Gumboot::VERSION.split('.').map(&:to_i).all? { |n| n >= 0 }

# Module is a proper Ruby module with no instance methods beyond Object
public_methods = Gumboot.public_methods(false).sort
puts public_methods.inspect

# Demonstrate that Gumboot is a properly defined module
puts Gumboot.is_a?(Module)
puts Gumboot.respond_to?(:name)
