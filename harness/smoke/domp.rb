# domp: Devise & Omniauth Multiple Providers generator gem
# The gem's lib/ is empty except for the Domp module and VERSION constant.
# All actual logic is in Rails::Generators::NamedBase subclass (requires Rails).
# We exercise what is available: the module identity and version constant.

require 'domp'

puts Domp::VERSION
puts Domp.is_a?(Module)
puts Domp.name
