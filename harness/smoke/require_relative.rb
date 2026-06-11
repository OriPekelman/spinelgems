# The gem is a Ruby 1.8 backport of require_relative; on 1.9+ it is a no-op.
# Verify the gem loads cleanly and that require_relative is callable.
puts Object.new.respond_to?(:require_relative, true)
puts "loaded"
