# Exercise Coordinates module from coordinate-converter gem
result = Coordinates.utm_to_lat_long("WGS-84", 4649776.22, 582844.0, "32N")
puts result[:lat].round(6)
puts result[:long].round(6)

result2 = Coordinates.utm_to_lat_long("GRS 1980", 5000000.0, 500000.0, "33N")
puts result2[:lat].round(6)
puts result2[:long].round(6)

# Access constants
puts Coordinates::ELLIPSOID["WGS-84"].first
puts Coordinates::ELLIPSOID["WGS-84"].last
puts Coordinates::RAD_TO_DEG.round(8)
