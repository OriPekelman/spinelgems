require 'ip'

# IPv4 parsing and basic attributes
ip4 = IP.new("192.168.1.42/24")
puts ip4.to_s           # 192.168.1.42/24
puts ip4.proto          # v4
puts ip4.pfxlen         # 24
puts ip4.size           # 256
puts ip4.to_hex         # c0a8012a

# Network and broadcast
puts ip4.network.to_s   # 192.168.1.0/24
puts ip4.broadcast.to_s # 192.168.1.255/24
puts ip4.netmask.to_s   # 255.255.255.0

# offset? and offset
puts ip4.offset?        # true
puts ip4.offset         # 42

# ARPA for reverse DNS
puts ip4.to_arpa        # 42.1.168.192.in-addr.arpa.

# IPv4 via array form
ip4b = IP.new(["v4", 0x0a000001, 8])
puts ip4b.to_s          # 10.0.0.1/8
puts ip4b.network.to_s  # 10.0.0.0/8

# IPv6 parsing
ip6 = IP.new("2001:db8::1/32")
puts ip6.to_s           # 2001:db8::1/32
puts ip6.proto          # v6
puts ip6.pfxlen         # 32
puts ip6.size           # large bignum — skip, just confirm class
puts ip6.class          # IP::V6

# IPv4-mapped IPv6
mapped = IP.new("::ffff:192.168.1.1")
puts mapped.ipv4_mapped? # true
puts mapped.native.to_s  # 192.168.1.1

# Comparison
a = IP.new("10.0.0.1/24")
b = IP.new("10.0.0.2/24")
puts (a <=> b)          # -1
puts a < b              # true
