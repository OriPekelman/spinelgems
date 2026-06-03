# rails_config 0.99.0 smoke
# This gem is a deprecated stub — its entire public API is the RailsConfig
# module and the VERSION constant (no logic was ever moved here; the real
# implementation lives in the `config` gem dependency).
# We test the module identity and constant that the gem itself defines.

require 'rails_config'
require 'rails_config/version'

# Module identity
puts RailsConfig.class          # Module
puts RailsConfig.is_a?(Module)  # true
puts RailsConfig.name           # RailsConfig

# No instance methods defined on the module itself
puts RailsConfig.instance_methods(false).sort.inspect  # []

# VERSION constant present and well-formed (major.minor.patch)
v = RailsConfig::VERSION
puts v                          # 0.99.0
puts v.split('.').length == 3   # true

# Constants defined in the module
puts RailsConfig.constants.sort.inspect  # [:VERSION]
