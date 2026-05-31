# The gem entry is lib/haversine.rb (not lib/haversine_distance.rb),
# so the harness entrypoint auto-detect finds nothing — load it here.
require_relative "lib/haversine"

puts Haversine::EARTH_RADIUS_KM
puts Haversine::EARTH_RADIUS_MI
puts Haversine.distance(51.885, 0.235, 49.008, 2.549).round(6)
puts Haversine.distance_in_mile(51.885, 0.235, 49.008, 2.549).round(6)
puts Haversine.distance(0.0, 0.0, 0.0, 0.0).round(6)
puts Haversine.distance(40.7128, -74.0060, 34.0522, -118.2437).round(4)
