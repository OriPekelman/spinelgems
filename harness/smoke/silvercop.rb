# silvercop is a config-only gem (RuboCop config inheritance).
# lib/silvercop.rb contains only a comment; there are no classes, modules,
# or methods to exercise. Smoke verifies require succeeds and prints gem path.
require 'silvercop'

# The gem provides no Ruby API — only a config/rubocop.yml for inherit_gem.
# Confirm the require loaded without error:
puts "silvercop loaded"
puts "Gem is config-only: no public Ruby API"
