# metric_fu-Saikuro smoke: exercises Filter threshold logic and
# Saikuro::VERSION. The self-contained parts (filter.rb, version.rb)
# work under both CRuby 3.x and Spinel — the rest of the gem requires
# RubyToken which was removed in Ruby 3.x.
require 'saikuro/version'
require 'saikuro/filter'

puts Saikuro::VERSION

# Filter constructor defaults: limit=-1, error=11, warn=8
f = Filter.new(-1, 11, 8)
puts f.ignore?(3)    # false: 3 >= -1
puts f.warn?(9)      # true:  9 >= 8
puts f.warn?(7)      # false: 7 < 8
puts f.error?(11)    # true:  11 >= 11
puts f.error?(10)    # false: 10 < 11

# Custom thresholds via constructor
f2 = Filter.new(5, 20, 10)
puts f2.ignore?(4)   # true:  4 < 5
puts f2.ignore?(6)   # false: 6 >= 5
puts f2.warn?(10)    # true:  10 >= 10
puts f2.warn?(9)     # false: 9 < 10
puts f2.error?(20)   # true:  20 >= 20
puts f2.error?(19)   # false: 19 < 20
