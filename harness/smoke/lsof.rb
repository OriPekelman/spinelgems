require 'lsof'

# Test find_pids_cmd: pure string construction, no side effects
puts Lsof.find_pids_cmd(3000)
puts Lsof.find_pids_cmd(8080)
puts Lsof.find_pids_cmd(65535)

# Test running? on a port that is almost certainly not in use (unlikely ephemeral port)
# running? returns false when no listener — verify the boolean logic path
result = Lsof.running?(19473)
puts result == false ? "not_running_false_ok" : "unexpected_true"

# Test listener_pids on a port with no listener — should return []
pids = Lsof.listener_pids(19473)
puts pids.inspect

# Test running? returns true when we ourselves are listening
require 'socket'
server = TCPServer.new('127.0.0.1', 19474)
begin
  result2 = Lsof.running?(19474)
  puts result2 == true ? "running_true_ok" : "unexpected_false"
  pids2 = Lsof.listener_pids(19474)
  puts pids2.include?(Process.pid) ? "pid_found_ok" : "pid_not_found"
ensure
  server.close
end
