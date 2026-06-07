# smoke: pods 0.0.1
# The gem defines only Pods::VERSION and an empty Pods module.
# There is no real public API to exercise; this is a stub/placeholder gem.
require 'pods'

puts Pods::VERSION
puts Pods.is_a?(Module)
