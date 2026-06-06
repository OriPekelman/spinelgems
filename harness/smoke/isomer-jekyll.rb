# smoke: isomer-jekyll 0.1.0
# The gem is a scaffold with no public API beyond VERSION and an Error class.
# We exercise the Error class (inheritance, raise/rescue, message) which is
# the only real logic present.

require 'IsomerJekyll'

# VERSION constant
puts IsomerJekyll::VERSION

# Error is a subclass of StandardError
puts IsomerJekyll::Error.ancestors.include?(StandardError)

# Raise and rescue with a message
begin
  raise IsomerJekyll::Error, "something went wrong"
rescue IsomerJekyll::Error => e
  puts e.message
  puts e.class
end

# Default message when raised without args
begin
  raise IsomerJekyll::Error
rescue => e
  puts e.message
end
