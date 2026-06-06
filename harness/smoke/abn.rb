require 'abn'

# Known valid Australian Business Number (ATO's own ABN: 51 824 753 556)
valid_abn_str = "51824753556"
abn_valid = ABN.new(valid_abn_str)
puts abn_valid.valid?       # true
puts abn_valid.to_s         # formatted: "51 824 753 556"

# Class-level valid? shortcut
puts ABN.valid?(valid_abn_str)   # true
puts ABN.valid?("51824753556")   # true (again, same number)

# Invalid ABN — wrong check digit
invalid_abn = ABN.new("51824753557")
puts invalid_abn.valid?     # false
puts invalid_abn.to_s       # empty string

# Wrong length ABN
short_abn = ABN.new("1234567890")
puts short_abn.valid?       # false (only 10 digits)

# ABN with spaces (should strip them)
abn_with_spaces = ABN.new("51 824 753 556")
puts abn_with_spaces.valid? # true
puts abn_with_spaces.to_s   # "51 824 753 556"

# Another known valid ABN: 53 004 085 616 (Australian Taxation Office)
abn2 = ABN.new("53004085616")
puts abn2.valid?            # true
puts abn2.to_s              # "53 004 085 616"

# Version constants
puts ABN::Version::Major    # 2
puts ABN::Version::String   # 2.1.1
