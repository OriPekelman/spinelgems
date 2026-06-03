require 'find_a_port'

# available_port must return an Integer in the valid ephemeral range
port = FindAPort.available_port
puts port.is_a?(Integer) ? "port_is_integer: true" : "port_is_integer: false"
puts (port > 0 && port < 65536) ? "port_in_range: true" : "port_in_range: false"

# Calling it twice should give valid ports (may or may not be equal, both valid)
port2 = FindAPort.available_port
puts port2.is_a?(Integer) ? "port2_is_integer: true" : "port2_is_integer: false"
puts (port2 > 0 && port2 < 65536) ? "port2_in_range: true" : "port2_in_range: false"

# The ports should be in a reasonable ephemeral range (>= 1024)
puts (port >= 1024) ? "port_ephemeral: true" : "port_ephemeral: false"
puts (port2 >= 1024) ? "port2_ephemeral: true" : "port2_ephemeral: false"

puts "smoke: ok"
