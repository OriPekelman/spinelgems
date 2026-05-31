puts RSpecTimeout::SIGNAL_LEVEL
puts RSpecTimeout::TIMEOUT_OPTS_DEFAULTS[:timeout]
puts RSpecTimeout::TIMEOUT_OPTS_DEFAULTS.frozen?
timeout = 60
msg = "RSpec timeout killed your test suite because it took longer than #{timeout} seconds to run"
puts msg.length
puts msg
