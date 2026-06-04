# frozen_string_literal: true

# sensu-plugins-snmp smoke
#
# The gem's lib/ contains only the version module.
# All real plugin logic (check-snmp, metrics-snmp, etc.) lives in bin/ and
# requires 'sensu-plugin' and 'snmp' — both unavailable external gems.
# There is no smokeable pure-Ruby logic beyond the version constant, which
# is insufficient per spinelgems#4. This smoke documents that constraint.

require 'sensu-plugins-snmp'

# Only public API available without external deps:
puts SensuPluginsSnmp::Version::MAJOR
puts SensuPluginsSnmp::Version::MINOR
puts SensuPluginsSnmp::Version::PATCH
puts SensuPluginsSnmp::Version::VER_STRING
