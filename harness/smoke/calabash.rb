require 'calabash'

# This gem (calabash 1.2.1) is a pure stub/wrapper: its entire lib
# is Calabash::VERSION — there is no public logic to exercise.
# The gem delegates all real work to calabash-ios / calabash-android,
# which require full iOS/Android toolchains (out-of-scope, no-network).
# We can only verify the module and version constant load correctly.

puts Calabash::VERSION
puts Calabash::VERSION.split('.').map(&:to_i).sum  # arithmetic on version parts
puts Calabash.is_a?(Module)
puts Calabash::VERSION.frozen?
