# frozen_string_literal: true
require 'rfauxfactory'

# Seed for reproducibility
srand(42)

# 1. gen_alpha: length matches, all alpha chars
alpha = RFauxFactory.gen_alpha(8)
puts "alpha length: #{alpha.length}"
puts "alpha all alpha: #{alpha.chars.all? { |c| c =~ /[a-zA-Z]/ }}"

# 2. gen_numeric_string: length matches, all digits
numeric = RFauxFactory.gen_numeric_string(6)
puts "numeric length: #{numeric.length}"
puts "numeric all digits: #{numeric.chars.all? { |c| c =~ /[0-9]/ }}"

# 3. gen_alphanumeric: length matches, all alphanumeric
alnum = RFauxFactory.gen_alphanumeric(12)
puts "alnum length: #{alnum.length}"
puts "alnum all alnum: #{alnum.chars.all? { |c| c =~ /[a-zA-Z0-9]/ }}"

# 4. gen_string dispatch works
srand(42)
s = RFauxFactory.gen_string(:alpha, 5)
puts "gen_string alpha length: #{s.length}"
puts "gen_string alpha all alpha: #{s.chars.all? { |c| c =~ /[a-zA-Z]/ }}"

# 5. gen_netmask returns a valid dotted-quad
nm = RFauxFactory.gen_netmask(min_cidr: 8, max_cidr: 24)
puts "netmask octets: #{nm.split('.').length}"
puts "netmask valid: #{RFauxFactory::VALID_NETMASKS.include?(nm)}"

# 6. gen_mac: format check with colon delimiter
mac = RFauxFactory.gen_mac(delimiter: ':', multicast: false, locally: false)
parts = mac.split(':')
puts "mac parts: #{parts.length}"
puts "mac hex: #{parts.all? { |p| p =~ /\A[0-9a-f]{2}\z/ }}"
# first octet must have bit0=0 (unicast) and bit1=0 (globally unique)
first = parts[0].to_i(16)
puts "mac unicast: #{(first & 0x01) == 0}"
puts "mac globally unique: #{(first & 0x02) == 0}"

# 7. gen_ipaddr ip4: 4 octets
ip4 = RFauxFactory.gen_ipaddr(protocol: :ip4)
puts "ip4 octets: #{ip4.split('.').length}"

# 8. gen_strings returns hash with expected keys
srand(42)
strings = RFauxFactory.gen_strings(5, exclude: [:html, :cjk, :cyrillic, :utf8])
puts "strings keys: #{strings.keys.sort.inspect}"
puts "strings alpha length: #{strings[:alpha].length}"
puts "strings numeric all digits: #{strings[:numeric].chars.all? { |c| c =~ /[0-9]/ }}"

# 9. gen_boolean returns true or false
srand(1)
bools = 10.times.map { RFauxFactory.gen_boolean }
puts "boolean values valid: #{bools.all? { |b| b == true || b == false }}"
puts "boolean has both: #{bools.include?(true) && bools.include?(false)}"
