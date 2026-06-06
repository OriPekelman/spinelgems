require 'opener'

# Verify the OS-specific command is determined correctly
cmd = Opener.command
puts "command: #{cmd}"
puts "command frozen: #{cmd.frozen?}"

# Verify caching: second call returns the same object
cmd2 = Opener.command
puts "cached: #{cmd.equal?(cmd2)}"

# Verify insert_command_into_arguments! logic via spawn (without actually spawning)
# We exercise it indirectly: the private method is tested by checking command is prepended.
# We can also verify the kind_of? Hash branch by inspecting the method behavior.
# Since we can't safely spawn, we test the command string logic directly.
puts "is string: #{cmd.is_a?(String)}"

# Verify the platform detection coverage
host_os = RbConfig::CONFIG['host_os']
expected = case host_os
           when /darwin/i then 'open'
           when /cygwin/i then 'cygstart'
           when /linux|bsd/i then 'xdg-open'
           when /mswin|mingw/i then 'start'
           when /sunos|solaris/i then '/usr/dt/bin/sdtwebclient'
           end
puts "expected: #{expected}"
puts "match: #{cmd == expected}"
