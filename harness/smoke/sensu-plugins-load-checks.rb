require 'sensu-plugins-load-checks'
require 'sensu-plugins-load-checks/load-average'

# Test version constants
puts SensuPluginsLoadChecks::Version::MAJOR
puts SensuPluginsLoadChecks::Version::MINOR
puts SensuPluginsLoadChecks::Version::PATCH
puts SensuPluginsLoadChecks::Version::VER_STRING

# Test LoadAverage class — reads /proc/loadavg and /proc/cpuinfo (available on Linux)
la = LoadAverage.new

# cpu_count returns an integer >= 1 on any real host
cores = la.cpu_count
puts cores.is_a?(Integer) ? "cores_ok" : "cores_bad"
puts cores > 0 ? "cores_positive" : "cores_zero"

# load_avg returns an array of 3 floats (per-core load for 1m, 5m, 15m)
avg = la.load_avg
puts avg.is_a?(Array) ? "avg_array" : "avg_bad"
puts avg.length == 3 ? "avg_len3" : "avg_len_wrong"
puts avg.all? { |v| v.is_a?(Float) } ? "avg_floats" : "avg_not_floats"

# failed? should be false on a working Linux host
puts la.failed? ? "failed" : "not_failed"

# exceed? with very high thresholds → should not exceed
puts la.exceed?([9999.0, 9999.0, 9999.0]) ? "exceeded" : "not_exceeded"

# exceed? with zero thresholds → should exceed (any load >= 0)
puts la.exceed?([0.0, 0.0, 0.0]) ? "exceeded_zero" : "not_exceeded_zero"

# to_s returns a comma-separated string of floats
s = la.to_s
puts s.is_a?(String) ? "to_s_string" : "to_s_bad"
puts s.split(', ').length == 3 ? "to_s_3parts" : "to_s_parts_wrong"
