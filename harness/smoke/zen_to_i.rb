# frozen_string_literal: true
# smoke: zen_to_i — converts kanji/zen numerals to integers via String#zen_to_i

require 'zen_to_i'

# Full-width digits (zen → han)
puts "１２３".zen_to_i          # => 123
puts "４５６".zen_to_i          # => 456
puts "０".zen_to_i              # => 0

# Kanji numerals — basic
puts "三".zen_to_i              # => 3
puts "十五".zen_to_i            # => 15
puts "百二十三".zen_to_i        # => 123
puts "千九百九十九".zen_to_i    # => 1999

# Kanji numerals — larger units
puts "一万".zen_to_i            # => 10000
puts "三万二千五百".zen_to_i    # => 32500

# Mixed string: kanji number embedded in text
result = "合計三千円です".zen_to_i
puts result                     # => "合計3000円です"

# Alternate kanji forms
puts "壱".zen_to_i              # => 1
puts "参".zen_to_i              # => 3
