require 'net_http_unix'

# Exercise NetX::HTTPUnix.new with a unix:// address — tests the initialize
# branch that parses the socket path and rewrites address/port to localhost:80.
h1 = NetX::HTTPUnix.new('unix:///var/run/docker.sock')
puts h1.address          # => localhost
puts h1.port             # => 80
puts h1.instance_variable_get(:@socket_type)  # => unix
puts h1.instance_variable_get(:@socket_path)  # => /var/run/docker.sock

# A plain TCP address should fall through to the inet branch.
h2 = NetX::HTTPUnix.new('example.com', 8080)
puts h2.address          # => example.com
puts h2.port             # => 8080
puts h2.instance_variable_get(:@socket_type)  # => inet

# UNIX_REGEXP constant is case-insensitive — verify it matches both cases.
puts NetX::HTTPUnix::UNIX_REGEXP === 'unix:///tmp/s'   # => true
puts NetX::HTTPUnix::UNIX_REGEXP === 'UNIX:///tmp/s'   # => true
puts NetX::HTTPUnix::UNIX_REGEXP === 'http://example'  # => false

# VERSION constant (still exercised but not the sole focus)
puts NetHttpUnix::VERSION  # => 0.2.2
