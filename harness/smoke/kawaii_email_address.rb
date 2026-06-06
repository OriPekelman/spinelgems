require 'kawaii_email_address'

# Test 1: basic valid email
v1 = KawaiiEmailAddress::Validator.new('user@example.com')
puts v1.valid?        ? 'valid' : 'invalid'   # valid
puts v1.local_part                              # user
puts v1.domain_part                             # example.com
puts v1.to_s                                    # user@example.com

# Test 2: invalid - missing @
v2 = KawaiiEmailAddress::Validator.new('nodomain')
puts v2.valid?        ? 'valid' : 'invalid'   # invalid
puts v2.both_part_present? ? 'both' : 'missing' # missing

# Test 3: invalid - starts with period
v3 = KawaiiEmailAddress::Validator.new('.invalid@example.com')
puts v3.valid?        ? 'valid' : 'invalid'   # invalid

# Test 4: valid - with plus sign and subdomain
v4 = KawaiiEmailAddress::Validator.new('user+tag@sub.domain.org')
puts v4.valid?        ? 'valid' : 'invalid'   # valid

# Test 5: domain literal (IP address) - valid
v5 = KawaiiEmailAddress::Validator.new('user@[192.168.1.1]')
puts v5.valid?        ? 'valid' : 'invalid'   # valid

# Test 6: invalid - consecutive dots in local part
v6 = KawaiiEmailAddress::Validator.new('us..er@example.com')
puts v6.valid?        ? 'valid' : 'invalid'   # invalid

# Test 7: docomo domain allows consecutive dots
v7 = KawaiiEmailAddress::Validator.new('us..er@docomo.ne.jp')
puts v7.valid?        ? 'valid' : 'invalid'   # valid

# Test 8: both_part_present? on valid
v8 = KawaiiEmailAddress::Validator.new('a@b.co')
puts v8.both_part_present? ? 'both' : 'missing' # both

# Test 9: class-level period restriction domains
puts KawaiiEmailAddress::Validator.period_restriction_violate_domains.include?('docomo.ne.jp') ? 'docomo-listed' : 'not-listed'
puts KawaiiEmailAddress::Validator.period_restriction_violate_domains.include?('ezweb.ne.jp')  ? 'ezweb-listed'  : 'not-listed'

# Test 10: invalid domain literal - bad IP
v10 = KawaiiEmailAddress::Validator.new('user@[999.999.999.999]')
puts v10.valid?       ? 'valid' : 'invalid'   # invalid
