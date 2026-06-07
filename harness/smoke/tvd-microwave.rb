# tvd-microwave smoke: empty-module stub gem; exercises version loading via File.read/__FILE__
require 'tvd-microwave'

# The gem defines TVDinner::Microwave as an empty module and loads VERSION
# via File.read(File.dirname(__FILE__) + '/../../VERSION') — real runtime I/O.

# 1. Module namespace is accessible
puts TVDinner::Microwave.class          # Module

# 2. VERSION is a non-empty string loaded from the filesystem at require time
v = TVDinner::Microwave::VERSION
puts v.is_a?(String)                   # true
puts v.strip.empty?                    # false
puts v.strip                           # 0.0.15

# 3. Module has no instance methods beyond Object defaults
own = TVDinner::Microwave.instance_methods(false)
puts own.empty?                        # true (empty module)

# 4. The version string matches a semver-like pattern
puts v.strip =~ /\A\d+\.\d+\.\d+/ ? "semver:ok" : "semver:fail"
