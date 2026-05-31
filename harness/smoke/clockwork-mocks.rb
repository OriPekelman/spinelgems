# clockwork is an external dep; stub it so the gem loads without it
module Clockwork; end unless defined?(Clockwork)
require_relative "lib/clockwork_mocks/version"

puts ClockworkMocks::VERSION
puts ClockworkMocks::VERSION.split('.').length
puts ClockworkMocks::VERSION.split('.').first.to_i >= 1
