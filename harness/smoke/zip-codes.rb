# frozen_string_literal: true

require 'zip-codes'

# Look up several well-known US ZIP codes
result90210 = ZipCodes.identify('90210')
puts result90210[:city]
puts result90210[:state_code]
puts result90210[:state_name]
puts result90210[:time_zone]

result10001 = ZipCodes.identify('10001')
puts result10001[:city]
puts result10001[:state_code]

# Non-existent ZIP code returns nil
puts ZipCodes.identify('99999').nil?

# Puerto Rico ZIP
result00601 = ZipCodes.identify('00601')
puts result00601[:city]
puts result00601[:state_code]

puts ZipCodes::VERSION
