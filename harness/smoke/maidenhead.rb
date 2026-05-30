# Maidenhead locator smoke test
puts Maidenhead.valid_maidenhead?("AA00")
puts Maidenhead.valid_maidenhead?("FN31pr")
puts Maidenhead.valid_maidenhead?("invalid")
puts Maidenhead.valid_maidenhead?("ZZ99")

result = Maidenhead.to_latlon("FN31pr")
puts result[0]
puts result[1]

puts Maidenhead.to_maidenhead(40.7128, -74.0060, 3)
puts Maidenhead.to_maidenhead(51.5074, -0.1278, 2)
