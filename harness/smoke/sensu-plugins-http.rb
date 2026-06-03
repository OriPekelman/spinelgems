# frozen_string_literal: true

# Smoke test for sensu-plugins-http
#
# The gem's real public API (AwsV4#apply_v4_signature, Common#aws_config,
# Common#merge_s3_config) all require `aws-sdk` at runtime, which is not
# available. The AWS signature logic also uses Net::HTTP objects that trigger
# Spinel codegen failures (sp_Net_HTTP, sp_Struct undeclared).
#
# Exercises: Version module (VER_STRING computed from MAJOR/MINOR/PATCH via
# Array#compact + join), integer type checks, version string parsing, and
# the gem module hierarchy (SensuPluginsHttp::AwsV4 + Common top-level module).

require 'sensu-plugins-http'

# 1. Version constants - integers, not literals
major = SensuPluginsHttp::Version::MAJOR
minor = SensuPluginsHttp::Version::MINOR
patch = SensuPluginsHttp::Version::PATCH
puts major
puts minor
puts patch

# 2. VER_STRING is computed: [MAJOR, MINOR, PATCH].compact.join('.')
ver = SensuPluginsHttp::Version::VER_STRING
puts ver

# 3. Verify computed string matches the parts (real logic check)
puts [major, minor, patch].compact.join('.') == ver

# 4. String operations on the version - real computations
puts ver.split('.').map(&:to_i).sum
puts ver.split('.').length
puts ver.start_with?("#{major}.")
puts ver.end_with?(".#{patch}")

# 5. Module namespace checks
puts SensuPluginsHttp::AwsV4.name
puts SensuPluginsHttp.name
puts Common.name
