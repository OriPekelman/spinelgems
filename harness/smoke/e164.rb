# Smoke test for e164 gem
puts E164.normalize('+12125551234')
puts E164.normalize('2125551234')
puts E164.normalize('01142012345678')
result = E164.parse('+12125551234')
puts result.length
puts result[0]
puts result[1]
puts result[2]
puts E164::DefaultCountryCode
puts E164::DefaultIdentifier
