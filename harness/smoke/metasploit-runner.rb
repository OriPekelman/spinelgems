# Smoke for metasploit-runner.
# The harness pre-loads all lib files via require_relative; this body just
# drives the public API.  No require statements needed here.

# 1. CONSTANTS
puts CONSTANTS::DEFAULT_PORT
puts CONSTANTS::DEFAULT_URI
puts CONSTANTS::DEFAULT_SSL.inspect
puts CONSTANTS::REQUIRED_TOKEN_MESSAGE

# 2. CommandLineArgumentParser
args = [
  '--connection-url', 'http://127.0.0.1',
  '--token', 'tok' + 'en123',
  '--workspace-name', 'test_ws',
  '--device-ip-to-scan', '10.0.0.1',
  '--port', '4444',
  '--use-ssl',
  '--exploit-speed', '3',
  '--whitelist-hosts', '10.0.0.0/24',
  '--module-filter', 'exploit/multi/handler',
]
parsed = CommandLineArgumentParser.parse(args)
puts parsed['connection_url']
puts parsed['token']
puts parsed['workspace_name']
puts parsed['port']
puts parsed['use_ssl'].inspect
puts parsed['exploit_speed']

# 3. ExploitRunDescription from parsed hash
desc = ExploitRunDescription.new(parsed)

puts desc.port
puts desc.uri
puts desc.use_ssl.inspect
puts desc.ssl_version
puts desc.exploit_speed
puts desc.limit_sessions.inspect

opts = desc.get_options
puts opts[:host]
puts opts[:port]

eopts = desc.get_exploit_options
puts eopts['workspace']
puts eopts['DS_EXPLOIT_SPEED']
puts eopts['DS_MinimumRank']
puts eopts['DS_LimitSessions'].inspect

aopts = desc.get_audit_options
puts aopts['workspace']
puts aopts['DS_MAX_REQUESTS']

dopts = desc.get_discover_options
puts dopts['workspace']
puts dopts['ips'].first

puts desc.to_bool('true').inspect
puts desc.to_bool('false').inspect
puts desc.to_bool(true).inspect

puts desc.device_ip_to_scan

# 4. verify raises on missing token
bare = ExploitRunDescription.new({'exploit_speed' => 5, 'limit_sessions' => false})
begin
  bare.verify
rescue StandardError => e
  puts e.message
end
