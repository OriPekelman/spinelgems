require 'timeout'
require 'tcpsocket-wait'

# Verify the methods were added to TCPSocket
puts TCPSocket.respond_to?(:wait_for_service_with_timeout)       # true
puts TCPSocket.respond_to?(:wait_for_service_termination_with_timeout) # true
puts TCPSocket.respond_to?(:listening_service?)                  # true

# Test listening_service? on a port that is definitely not open (port 1 on loopback)
# With a tiny timeout so it fails fast
result = TCPSocket.listening_service?(host: '127.0.0.1', port: 1, timeout: 1)
puts result  # false — connection refused

# Test wait_for_service_with_timeout raises SocketError when service is not up
begin
  TCPSocket.wait_for_service_with_timeout(host: '127.0.0.1', port: 1, timeout: 1)
  puts "no error"
rescue SocketError => e
  puts e.message.start_with?("Socket did not open within")  # true
rescue => e
  puts "unexpected: #{e.class}"
end

# Test wait_for_service_termination_with_timeout: port not listening → loop exits immediately
# (while listening_service? → false means loop body never runs, returns nil)
result2 = TCPSocket.wait_for_service_termination_with_timeout(host: '127.0.0.1', port: 1, timeout: 1)
puts result2.nil?  # true
