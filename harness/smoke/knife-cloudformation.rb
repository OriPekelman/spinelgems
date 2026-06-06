# knife-cloudformation smoke
# This gem is a deprecated stub that only provides a VERSION constant;
# all real functionality was moved to the 'sfn' gem (external dep, ignored).
# We exercise the VERSION constant and basic module existence.

require 'knife-cloudformation'

# Module must exist
puts KnifeCloudformation.class

# VERSION is a Gem::Version object
v = KnifeCloudformation::VERSION
puts v.class
puts v.to_s

# Verify it is the expected version
puts v == Gem::Version.new('0.5.0')

# Gem::Version comparison methods work on it
puts v >= Gem::Version.new('0.4.0')
puts v < Gem::Version.new('1.0.0')
