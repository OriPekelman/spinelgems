require 'cinderella/version'

# cinderella 1.0.0: the gem is a Mac OSX dev-environment CLI launcher.
# Its only Ruby surface is the VERSION constant — lib/cinderella.rb is
# empty (0 bytes) and the bin/cinderella executable just does `exec boxen`.
# There is no public Ruby API beyond the module namespace itself.

puts Cinderella::VERSION
puts Cinderella.class
puts Cinderella.respond_to?(:const_defined?) ? "const_defined" : "no"
puts Cinderella.const_defined?(:VERSION)
