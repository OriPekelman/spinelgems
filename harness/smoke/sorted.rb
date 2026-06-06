# smoke: sorted-mongoid
# This gem is a Mongoid/sorted adapter. The standalone loadable part is
# sorted/mongoid (version + empty module). The real logic in
# sorted/orms/mongoid.rb requires mongoid, sorted, and activesupport —
# all external gems not available in the Spinel smoke environment.
# We load the top-level entrypoint and verify the module structure.

require 'sorted/mongoid'

puts Sorted::Mongoid::VERSION
puts Sorted::Mongoid.class
puts Sorted::Mongoid.ancestors.inspect
