require 'ip_ranger'

# Exercise IPRanger::IPRange#cidrs — convert an IP range to CIDR list
range1 = IPRanger::IPRange.new('192.168.0.0', '192.168.0.255')
puts range1.cidrs.map(&:to_cidr).sort.join(', ')

# Asymmetric range that spans multiple CIDRs
range2 = IPRanger::IPRange.new('10.0.0.1', '10.0.0.10')
puts range2.cidrs.map(&:to_cidr).sort.join(', ')

# IPv4 range boundaries
range3 = IPRanger::IPRange.new('172.16.0.0', '172.16.3.255')
puts range3.cidrs.map(&:to_cidr).sort.join(', ')

# first and last helpers
puts range1.first.class
puts range1.last.class
puts range2.first == IPAddr.new('10.0.0.1').to_i
puts range2.last == IPAddr.new('10.0.0.10').to_i
