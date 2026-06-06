require 'ipaddr'

# IPv4 basic construction and methods
ipv4 = IPAddr.new("192.168.1.2")
puts ipv4.to_s
puts ipv4.to_string
puts ipv4.ipv4?
puts ipv4.ipv6?

# IPv4 with prefix
net = IPAddr.new("192.168.2.0/24")
puts net.to_s
puts net.include?(IPAddr.new("192.168.2.100"))
puts net.include?(IPAddr.new("192.168.3.0"))

# IPv4 reverse DNS
puts ipv4.reverse

# IPv4 mapped to IPv6
mapped = ipv4.ipv4_mapped
puts mapped.to_s
puts mapped.ipv4_mapped?
puts mapped.native.to_s

# IPv6 construction
ipv6 = IPAddr.new("3ffe:505:2::1")
puts ipv6.to_s
puts ipv6.to_string
puts ipv6.ipv6?
puts ipv6.ipv4?

# IPv6 network with mask
net6 = IPAddr.new("3ffe:505:2::/48")
puts net6.to_s
puts net6.include?(IPAddr.new("3ffe:505:2::1"))
puts net6.include?(IPAddr.new("3ffe:505:3::"))

# IPv6 reverse DNS
puts IPAddr.new("3ffe:505:2::f").ip6_arpa

# Bitwise AND
a = IPAddr.new("3ffe:505:2::/48")
c = IPAddr.new("ffff:ffff::")
puts (a & c).to_s

# Bitwise OR
b = IPAddr.new("0:0:0:1::")
puts (a | b).to_s

# Successor
puts IPAddr.new("192.168.1.1").succ.to_s

# to_range
r = IPAddr.new("192.168.1.0/30").to_range
puts r.first.to_s
puts r.last.to_s

# new_ntoh round-trip
orig = IPAddr.new("192.168.2.1")
puts IPAddr.new_ntoh(orig.hton).to_s

# Comparison
a1 = IPAddr.new("192.168.1.1")
a2 = IPAddr.new("192.168.1.2")
puts (a1 <=> a2)
puts (a1 == IPAddr.new("192.168.1.1"))
