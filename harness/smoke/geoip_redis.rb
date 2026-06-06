require 'geoip_redis'
require 'geoip_redis/ip_range'
require 'geoip_redis/blocks_parser'

# IpRange: build from CIDR network
range = GeoipRedis::IpRange.build_from_network('192.168.1.0/24', 'loc-1')
puts range.location_id
puts range.min_ip_num
puts range.max_ip_num

# encode / decode round-trip
encoded = range.encode
decoded = GeoipRedis::IpRange.decode(encoded)
puts decoded.location_id
puts decoded.min_ip_num == range.min_ip_num
puts decoded.max_ip_num == range.max_ip_num

# member? checks
ip_inside  = IPAddr.new('192.168.1.100').to_i
ip_outside = IPAddr.new('10.0.0.1').to_i
puts range.member?(ip_inside)
puts range.member?(ip_outside)

# BlocksParser derives location + ip_range from CSV row data
parser = GeoipRedis::BlocksParser.new
ip_range2 = parser.ip_range(['203.0.113.0/24', 'loc-2', nil, nil, nil, nil, nil, nil, nil])
puts ip_range2.location_id
loc = parser.location(['203.0.113.0/24', 'loc-2', nil, nil, nil, nil, '90210', '34.0522', '-118.2437'])
puts loc[:location_id]
puts loc[:postal_code]
puts loc[:latitude]
puts loc[:longitude]

# VERSION constant
puts GeoipRedis::VERSION
