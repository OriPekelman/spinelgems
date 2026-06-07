# rsence-deps smoke test
# This gem is a pure dependency stub for the RSence framework.
# Its lib file contains only a comment — there is no public API to call.
# We verify the require succeeds and the file truly defines nothing.

require 'rsence-deps'

puts "require ok"
# Confirm no Rsence-related constant exists
has_rsence = Object.const_defined?(:RsenceDeps)
has_rsence2 = Object.const_defined?(:Rsence)
puts "RsenceDeps constant: #{has_rsence}"
puts "Rsence constant: #{has_rsence2}"
puts "done"
