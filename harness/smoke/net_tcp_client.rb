require 'net_tcp_client'

# 1. VERSION constant
puts Net::TCPClient::VERSION

# 2. Exception hierarchy: ConnectionTimeout, ReadTimeout, WriteTimeout < SocketError
[Net::TCPClient::ConnectionTimeout,
 Net::TCPClient::ReadTimeout,
 Net::TCPClient::WriteTimeout].each do |klass|
  puts klass.ancestors.include?(SocketError)
end

# 3. ConnectionFailure: custom attrs (server + cause), inherits SocketError
cause = RuntimeError.new("underlying io failure")
cf = Net::TCPClient::ConnectionFailure.new("host unreachable", "db.example.com:5432", cause)
puts cf.message
puts cf.server
puts cf.cause.class
puts cf.is_a?(SocketError)

# 4. reconnect_on_errors class-level list includes expected entries
errors = Net::TCPClient.reconnect_on_errors
puts errors.include?(Errno::ECONNRESET)
puts errors.include?(Errno::ETIMEDOUT)
puts errors.include?(EOFError)
puts errors.include?(Net::TCPClient::ConnectionTimeout)

# 5. Address#initialize and #to_s (no DNS lookup — direct construction)
addr = Net::TCPClient::Address.new("db.example.com", "192.0.2.1", 5432)
puts addr.host_name
puts addr.ip_address
puts addr.port
puts addr.to_s

# 6. Address.addresses_for_server_name raises ArgumentError on bad format
begin
  Net::TCPClient::Address.addresses_for_server_name("nodomain")
rescue ArgumentError => e
  puts e.message.include?("Invalid host_name")
end
