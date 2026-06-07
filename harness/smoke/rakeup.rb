# Smoke test for rakeup gem
# rakeup provides Rake tasks for managing Rack servers.
# The main entry (lib/rakeup.rb) loads rake (external gem), so we smoke
# the standalone utilities which only use stdlib (socket, timeout).

require 'rakeup/utilities/port_check'
require 'rakeup/utilities/process_check'
require 'rakeup/status'
require 'rakeup/shell'

# --- PortCheck: closed port (nothing listens on 19999) ---
pc = RakeUp::Utilities::PortCheck.new('127.0.0.1', 19999)
pc.run
puts "port 19999 open? #{pc.open?}"          # => false
puts "port 19999 closed? #{pc.closed?}"       # => true
puts "port_check to_s starts: #{pc.to_s[0, 24]}" # => "Unable to connect to pro"

# --- ProcessCheck: our own pid should be running ---
our_pid = Process.pid.to_s
pchk = RakeUp::Utilities::ProcessCheck.new(our_pid)
pchk.run
puts "own pid running? #{pchk.running?}"      # => true
puts "process_check to_s: #{pchk.to_s[0, 17]}" # => "Found process run"

# ProcessCheck with bogus pid (very high, almost certainly absent)
bad = RakeUp::Utilities::ProcessCheck.new('999999999')
bad.run
puts "bogus pid running? #{bad.running?}"     # => false

# --- Status: wraps both checks ---
status = RakeUp::Status.new(our_pid, '127.0.0.1', 19999)
status.check
puts "status up? #{status.up?}"              # => false (port not open)
puts "status running? #{status.running?}"    # => true
puts "status listening? #{status.listening?}"# => false
puts "host_and_port: #{status.host_and_port}"# => 127.0.0.1:19999

# status.to_s when not up should include both process and port lines
s = status.to_s
puts "status to_s has 2 lines: #{s.lines.length == 2}" # => true
puts "status to_s has pid: #{s.include?(our_pid)}"     # => true

# --- Shell: echo_commands flag ---
RakeUp::Shell.echo_commands = false
puts "echo off: #{RakeUp::Shell.echo_commands?}" # => false
RakeUp::Shell.echo_commands = true
puts "echo on: #{RakeUp::Shell.echo_commands?}"  # => true
