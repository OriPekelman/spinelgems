require 'sms_tools'

# --- GsmEncoding: valid?, double_byte?, from_utf8, to_utf8 ---

puts SmsTools::GsmEncoding.valid?("Hello, World!")          # true
puts SmsTools::GsmEncoding.valid?("Café")             # true (e with acute is in GSM table)
puts SmsTools::GsmEncoding.valid?("中文")          # false (Chinese chars not in GSM)

puts SmsTools::GsmEncoding.double_byte?("{")               # true  (left curly = extension table)
puts SmsTools::GsmEncoding.double_byte?("A")               # false (plain ASCII, base table)

gsm = SmsTools::GsmEncoding.from_utf8("Hi!")
puts gsm.length                                            # 3
back = SmsTools::GsmEncoding.to_utf8(gsm)
puts back                                                  # Hi!

# --- EncodingDetection ---

ascii_msg = SmsTools::EncodingDetection.new("Hello!")
puts ascii_msg.encoding                                    # ascii
puts ascii_msg.length                                      # 6
puts ascii_msg.concatenated?                               # false
puts ascii_msg.concatenated_parts                          # 1

# GSM-only chars (e.g. pound sign £ is GSM)
gsm_msg = SmsTools::EncodingDetection.new("£ price")  # £ price
puts gsm_msg.encoding                                      # gsm
puts gsm_msg.gsm?                                          # true

# Unicode message
unicode_msg = SmsTools::EncodingDetection.new("中文")
puts unicode_msg.encoding                                  # unicode
puts unicode_msg.unicode?                                  # true
puts unicode_msg.length                                    # 2 (both in basic plane)

# Long message that needs concatenation (unicode, each char = 1, limit = 70)
long_unicode = SmsTools::EncodingDetection.new("中" * 80)
puts long_unicode.concatenated?                            # true
puts long_unicode.concatenated_parts                       # 2

# maximum_length_for
puts ascii_msg.maximum_length_for(1)                       # 160
puts ascii_msg.maximum_length_for(2)                       # 306 (2 * 153)

# GSM double-byte extension chars count double in length
# £ forces GSM detection; { and } are extension table (each costs 2)
gsm_ext = SmsTools::EncodingDetection.new("£{b}")    # £{b}: £=1, {=2, b=1, }=2 = 6
puts gsm_ext.encoding                                      # gsm
puts gsm_ext.length                                        # 6
