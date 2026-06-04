require 'keepass-password-generator'

# 1. Pattern validation (deterministic: valid/invalid)
puts KeePass::Password.validate_pattern('lud')          # => true  (lower, upper, digit)
puts KeePass::Password.validate_pattern('d{8}')         # => true  (8 digits)
puts KeePass::Password.validate_pattern('')              # => false (empty)
puts KeePass::Password.validate_pattern('Q')            # => false (invalid char set id)

# 2. Generated password length from pattern (non-deterministic content but length is fixed)
pw = KeePass::Password.generate('l{6}d{2}')
puts pw.length                                          # => 8

pw2 = KeePass::Password.generate('H{4}')
puts pw2.length                                         # => 4

# 3. CharSet construction and membership (fully deterministic)
cs = KeePass::Password::CharSet.new
cs.add_from_strings('abc')
puts cs.include?('a')   # => true
puts cs.include?('z')   # => false
puts cs.size            # => 3

cs2 = KeePass::Password::CharSet.new
cs2.add_from_char_set_id('d')  # digits
puts cs2.include?('5')   # => true
puts cs2.include?('a')   # => false
puts cs2.size            # => 10

# 5. remove_lookalikes option: generated password must not contain lookalike chars
LOOKALIKE_CHARS = "O0l1I|".chars
500.times do
  pw3 = KeePass::Password.generate('L{20}', remove_lookalikes: true)
  found = pw3.chars.any? { |c| LOOKALIKE_CHARS.include?(c) }
  if found
    puts "FAIL: lookalike found in #{pw3}"
    exit 1
  end
end
puts "no_lookalikes_ok"
