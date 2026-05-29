# frozen_string_literal: true

puts Slimcop::VERSION
puts Slimcop::VERSION.class
puts Slimcop::VERSION.split('.').length
puts Slimcop::VERSION.start_with?('0.')
puts Slimcop.is_a?(Module)
