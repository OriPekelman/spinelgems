# frozen_string_literal: true
# smoke: ssrf_filter — SSRF protection library
# Tests: constants, error class hierarchy, IP blacklist membership, exception raising

require 'ssrf_filter'

# 1. Version
puts SsrfFilter::VERSION

# 2. Error class hierarchy
puts SsrfFilter::Error.ancestors.include?(StandardError)
puts SsrfFilter::PrivateIPAddress.ancestors.include?(SsrfFilter::Error)
puts SsrfFilter::InvalidUriScheme.ancestors.include?(SsrfFilter::Error)
puts SsrfFilter::UnresolvedHostname.ancestors.include?(SsrfFilter::Error)
puts SsrfFilter::TooManyRedirects.ancestors.include?(SsrfFilter::Error)
puts SsrfFilter::CRLFInjection.ancestors.include?(SsrfFilter::Error)

# 3. IPV4_BLACKLIST membership checks
private_ips = %w[10.0.0.1 172.16.5.5 192.168.1.1 127.0.0.1 169.254.1.1]
private_ips.each do |ip|
  addr = IPAddr.new(ip)
  result = SsrfFilter::IPV4_BLACKLIST.any? { |range| range.include?(addr) }
  puts "#{ip} private=#{result}"
end

public_ips = %w[8.8.8.8 1.1.1.1 93.184.216.34]
public_ips.each do |ip|
  addr = IPAddr.new(ip)
  result = SsrfFilter::IPV4_BLACKLIST.any? { |range| range.include?(addr) }
  puts "#{ip} private=#{result}"
end

# 4. PrivateIPAddress raised when resolver returns only private IP
begin
  SsrfFilter.get('http://example.com', resolver: ->(_host) { [IPAddr.new('10.0.0.1')] })
  puts 'no exception'
rescue SsrfFilter::PrivateIPAddress => e
  puts "PrivateIPAddress: #{e.message.split("'").first.strip}"
rescue => e
  puts "other: #{e.class}"
end

# 5. InvalidUriScheme raised for non-http(s) scheme
begin
  SsrfFilter.get('ftp://example.com', resolver: ->(_host) { [IPAddr.new('8.8.8.8')] })
  puts 'no exception'
rescue SsrfFilter::InvalidUriScheme => e
  puts "InvalidUriScheme: #{e.message.split("'")[1]}"
rescue => e
  puts "other: #{e.class}"
end

# 6. UnresolvedHostname raised when resolver returns empty
begin
  SsrfFilter.get('http://nxdomain.example', resolver: ->(_host) { [] })
  puts 'no exception'
rescue SsrfFilter::UnresolvedHostname => e
  puts "UnresolvedHostname: #{e.message.split("'")[1]}"
rescue => e
  puts "other: #{e.class}"
end

# 7. DEFAULT_SCHEME_WHITELIST
puts SsrfFilter::DEFAULT_SCHEME_WHITELIST.sort.join(',')

# 8. IPV6_BLACKLIST: loopback ::1 should be blocked
loopback6 = IPAddr.new('::1')
puts SsrfFilter::IPV6_BLACKLIST.any? { |range| range.include?(loopback6) }

# 9. VERB_MAP keys
puts SsrfFilter::VERB_MAP.keys.map(&:to_s).sort.join(',')
