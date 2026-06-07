# encoding: utf-8
require 'utf8_validator'

v = UTF8::Validator.new

# Valid ASCII
puts v.valid_encoding?("hello world")

# Valid multi-byte UTF-8: 2-byte (é), 3-byte (€), 4-byte (𝄞 musical symbol)
puts v.valid_encoding?("café")
puts v.valid_encoding?("price: €100")
puts v.valid_encoding?("𝄞 music")

# Invalid: lone continuation byte (0x80)
bad1 = [0x80].pack('C*')
puts v.valid_encoding?(bad1)

# Invalid: overlong two-byte sequence (0xC0 0x80, not a valid start byte)
bad2 = [0xC0, 0x80].pack('C*')
puts v.valid_encoding?(bad2)

# Invalid: truncated three-byte sequence (only two bytes given)
bad3 = [0xE2, 0x82].pack('C*')
puts v.valid_encoding?(bad3)

# Valid: empty string
puts v.valid_encoding?("")

# raise_on_error mode: valid string should return true
puts v.valid_encoding?("ok string", true)

# raise_on_error mode: invalid string should raise UTF8::ValidationError
begin
  v.valid_encoding?([0xFF].pack('C*'), true)
  puts "no error raised"
rescue UTF8::ValidationError => e
  puts "ValidationError raised"
end
