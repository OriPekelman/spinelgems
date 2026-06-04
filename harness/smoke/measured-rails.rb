# frozen_string_literal: true
# measured-rails 3.0.0 is a tombstone gem: functionality was merged into
# the `measured` gem. lib/measured-rails.rb is intentionally a no-op.
# The only real behaviour to verify is that require succeeds without defining
# any new constants.

before = Object.constants.sort

require "measured-rails"

after = Object.constants.sort
added = after - before

puts "require: ok"
puts "constants_added: #{added.length}"
# The gem itself notes "don't define anything, this gem is a no-op"
puts "no_op: #{added.empty?}"
