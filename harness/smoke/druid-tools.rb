# frozen_string_literal: true

require 'druid-tools'

# Test 1: validate? for valid and invalid druids
puts DruidTools::Druid.valid?('druid:bc123df4567')   # true
puts DruidTools::Druid.valid?('bc123df4567')          # true (no prefix)
puts DruidTools::Druid.valid?('druid:invalid')        # false
puts DruidTools::Druid.valid?('zz999zz9999')          # false (strict: has vowels, but non-strict should pass)

# Test 2: strict validation rejects vowels
puts DruidTools::Druid.valid?('bb123bb1234', false)   # true  (no vowels)
puts DruidTools::Druid.valid?('ab123cd1234', true)    # false (a is in aeioul)

# Test 3: id and tree from a Druid instance
d = DruidTools::Druid.new('druid:bc123df4567', '/tmp')
puts d.id          # bc123df4567
puts d.tree.inspect  # ["bc", "123", "df", "4567", "bc123df4567"]

# Test 4: path building
puts d.path        # /tmp/bc/123/df/4567/bc123df4567

# Test 5: AccessDruid tree (no id suffix) and path
ad = DruidTools::AccessDruid.new('druid:bc123df4567', '/purl')
puts ad.tree.inspect  # ["bc", "123", "df", "4567"]
puts ad.path          # /purl/bc/123/df/4567

# Test 6: pattern and glob helpers
puts DruidTools::Druid.glob
puts DruidTools::Druid.strict_glob
