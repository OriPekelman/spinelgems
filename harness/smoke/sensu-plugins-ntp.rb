# smoke: sensu-plugins-ntp
# Tests: SensuPluginsNtp::Version constants + inline parsing logic from bin scripts
# No external deps: sensu-plugin is ignored; we inline the pure-Ruby parsers.

require 'sensu-plugins-ntp'

# 1. Version constants
puts SensuPluginsNtp::Version::MAJOR
puts SensuPluginsNtp::Version::MINOR
puts SensuPluginsNtp::Version::PATCH
puts SensuPluginsNtp::Version::VER_STRING

# 2. Inline the ntpdate parser from bin/metrics-ntpdate.rb
# (pure Ruby — no ntpdate binary needed, we exercise on synthetic strings)
def parse_ntpdate(output)
  float = /-?\d+\.\d+/
  pattern = /offset (#{float}), delay (#{float})/
  stats = { offset: nil, delay: nil }
  output.scan(pattern).each do |parsed|
    offset, delay = parsed
    offset = Float(offset)
    delay   = Float(delay)
    if stats[:delay].nil? || delay <= stats[:delay]
      stats[:delay]  = delay
      stats[:offset] = offset
    end
  end
  stats
end

sample_ntpdate = <<~TEXT
  server 192.168.1.1, stratum 2, offset 0.012345, delay 0.05678
  server 10.0.0.1, stratum 2, offset -0.002100, delay 0.03000
TEXT

result = parse_ntpdate(sample_ntpdate)
puts result[:offset]
puts result[:delay]

# Best (lowest delay) server wins
puts result[:delay] < 0.05678 ? "best-delay-correct" : "best-delay-wrong"

# 3. Inline the ntpstats parser from bin/metrics-ntpstats.rb
def parse_ntpstats(output)
  key_pattern = Regexp.compile(%w(
    clk_jitter
    clk_wander
    frequency
    mintc
    offset
    stratum
    sys_jitter
    tc
  ).join('|'))
  num_val_pattern = /-?[\d]+(\.[\d]+)?/
  pattern = /(#{key_pattern})=(#{num_val_pattern}),?\s?/

  output.scan(pattern).reduce({}) do |hash, parsed|
    key, val, fraction = parsed
    hash[key] = fraction ? val.to_f : val.to_i
    hash
  end
end

sample_ntpstats = "stratum=3, offset=0.012500, sys_jitter=0.003100, clk_jitter=0.002400, clk_wander=0.000150, frequency=-25.432, mintc=3, tc=6,"
stats = parse_ntpstats(sample_ntpstats)
puts stats['stratum']
puts stats['offset']
puts stats['sys_jitter']
puts stats['clk_jitter']
puts stats['frequency']
puts stats['mintc']
puts stats['tc']

# 4. Verify numeric types: integer fields vs float fields
puts stats['stratum'].is_a?(Integer) ? "stratum-is-integer" : "stratum-wrong-type"
puts stats['offset'].is_a?(Float)   ? "offset-is-float"   : "offset-wrong-type"
puts stats['mintc'].is_a?(Integer)  ? "mintc-is-integer"  : "mintc-wrong-type"
puts stats['tc'].is_a?(Integer)     ? "tc-is-integer"     : "tc-wrong-type"

# 5. ntpdate: no match → nil offsets
empty = parse_ntpdate("no ntp data here")
puts empty[:offset].nil? ? "nil-on-no-match" : "unexpected-value"
