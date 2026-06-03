# yoginth 0.0.55: ships only `module Yoginth; end` — no public API beyond the namespace stub.
require 'yoginth'

puts Yoginth.name          # => Yoginth
puts Yoginth.class         # => Module
puts Yoginth.is_a?(Module) # => true
