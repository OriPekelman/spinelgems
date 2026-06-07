require 'server_health_check-rack'

# Exercise Config.path? and Config.path_to_health_checks
cfg = ServerHealthCheckRack::Config

# Default path is /health
puts cfg.path

# path? matching — returns integer offset (truthy) or nil (falsy)
puts !cfg.path?("/health").nil?           # true
puts !cfg.path?("/health/redis").nil?     # true
puts !cfg.path?("/health?foo=1").nil?     # true
puts cfg.path?("/healthz").nil?           # true  (no match)
puts cfg.path?("/other").nil?             # true  (no match)

# path_to_health_checks
puts cfg.path_to_health_checks("/health").inspect                 # :all
puts cfg.path_to_health_checks("/health/redis").inspect           # ["redis"]
puts cfg.path_to_health_checks("/health/active_record").inspect   # ["active_record"]
puts cfg.path_to_health_checks("/health?debug=1").inspect         # :all (strips query string)

# Custom path setting
cfg.path = "/ping/"
puts cfg.path                              # /ping  (trailing slash stripped)
puts !cfg.path?("/ping").nil?             # true
puts !cfg.path?("/ping/db").nil?          # true
puts cfg.path?("/pinger").nil?            # true  (no match)
puts cfg.path_to_health_checks("/ping").inspect      # :all
puts cfg.path_to_health_checks("/ping/db").inspect   # ["db"]

# Reset path
cfg.path = "/health"

# Exercise Checks registration
ServerHealthCheckRack::Checks.check("custom_check") { true }
ServerHealthCheckRack::Checks.check("another_check") { false }
puts ServerHealthCheckRack::Checks.all_checks.sort.inspect

# VERSION
puts ServerHealthCheckRack::VERSION
