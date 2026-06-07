# smoke: the-perfect-gem
# This gem (a jeweler example) has an empty lib/the_perfect_gem.rb — no public API.
# We verify require succeeds and no exception is raised.

require 'the_perfect_gem'

# Re-require is idempotent in CRuby
loaded = require 'the_perfect_gem'
puts "second_require_false: #{loaded == false}"
puts "require_succeeded: true"
