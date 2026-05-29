# Daemon gem smoke: exercise class hierarchy and LockError message
puts Daemon.class
puts Daemon::LockError.superclass
puts Daemon::LockError.ancestors.include?(RuntimeError)
puts Daemon::LockError.ancestors.include?(StandardError)

# Test LockError message construction via a mock pid_file
mock_pf = Object.new
mock_pf.define_singleton_method(:path) { "/var/run/test.pid" }
mock_pf.define_singleton_method(:read) { "12345\n" }

begin
  raise Daemon::LockError.new(mock_pf)
rescue Daemon::LockError => e
  puts e.message
  puts e.is_a?(RuntimeError)
end
