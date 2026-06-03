# frozen_string_literal: true

# Smoke: sensu-plugins-network-checks
# Exercises: version module constants + TCP_STATES hash + /proc/net/tcp parsing
# (the core logic inlined from bin/check-netstat-tcp.rb and bin/metrics-netstat-tcp.rb)

require 'sensu-plugins-network-checks'

# 1. Version constants (VER_STRING is computed via Array#compact + join)
puts SensuPluginsNetworkChecks::Version::MAJOR
puts SensuPluginsNetworkChecks::Version::MINOR
puts SensuPluginsNetworkChecks::Version::PATCH
puts SensuPluginsNetworkChecks::Version::VER_STRING

# 2. TCP_STATES hash — the core data structure shared by all check/metrics scripts
TCP_STATES = {
  '00' => 'UNKNOWN',
  'FF' => 'UNKNOWN',
  '01' => 'ESTABLISHED',
  '02' => 'SYN_SENT',
  '03' => 'SYN_RECV',
  '04' => 'FIN_WAIT1',
  '05' => 'FIN_WAIT2',
  '06' => 'TIME_WAIT',
  '07' => 'CLOSE',
  '08' => 'CLOSE_WAIT',
  '09' => 'LAST_ACK',
  '0A' => 'LISTEN',
  '0B' => 'CLOSING'
}.freeze

# Check a few known mappings
puts TCP_STATES['01']
puts TCP_STATES['0A']
puts TCP_STATES['06']
puts TCP_STATES.size

# 3. Parse synthetic /proc/net/tcp-like lines using the same regex the gem uses
# (from check-netstat-tcp.rb / metrics-netstat-tcp.rb)
# Using synthetic data makes this deterministic — no live /proc/net/tcp reads.
state_counts = Hash.new(0)
TCP_STATES.each_pair { |_hex, name| state_counts[name] = 0 }

tcp4_pattern = /^\s*\d+:\s+(.{8}):(.{4})\s+(.{8}):(.{4})\s+(.{2})/

# Synthetic /proc/net/tcp lines: format is "sl: local_addr:port remote_addr:port state ..."
# State codes: 0A=LISTEN, 01=ESTABLISHED, 06=TIME_WAIT, 08=CLOSE_WAIT
synthetic_lines = [
  "  sl  local_address rem_address   st tx_queue rx_queue",
  "   0: 3600007F:0035 00000000:0000 0A 00000000:00000000",
  "   1: 00000000:D439 00000000:0000 0A 00000000:00000000",
  "   2: 00000000:0016 00000000:0000 0A 00000000:00000000",
  "   3: 0100007F:0277 00000000:0000 0A 00000000:00000000",
  "   4: 3204A8C0:0050 1204A8C0:C3DE 01 00000000:00000000",
  "   5: 3204A8C0:0050 1304A8C0:B2F0 01 00000000:00000000",
  "   6: 3204A8C0:0050 1404A8C0:A1E2 06 00000000:00000000",
  "   7: 3204A8C0:1234 0A04A8C0:8877 08 00000000:00000000",
]

synthetic_lines.each do |line|
  line = line.strip
  m = line.match(tcp4_pattern)
  if m
    connection_state = m[5]
    state_name = TCP_STATES[connection_state]
    state_counts[state_name] += 1 if state_name
  end
end

# Print sorted state names (deterministic output)
sorted_states = %w[LISTEN ESTABLISHED TIME_WAIT CLOSE_WAIT CLOSE SYN_SENT SYN_RECV FIN_WAIT1 FIN_WAIT2 LAST_ACK CLOSING UNKNOWN]
sorted_states.each do |state|
  puts "#{state}:#{state_counts[state]}"
end

# 4. Port hex parsing (used in check-netstat-tcp.rb to filter by port)
# Port 22 = 0x0016, Port 53 = 0x0035, Port 80 = 0x0050
puts '0016'.to_i(16)
puts '0035'.to_i(16)
puts '0050'.to_i(16)

# 5. Version string construction logic — same as VER_STRING
parts = [5, 0, 0]
puts parts.compact.join('.')
