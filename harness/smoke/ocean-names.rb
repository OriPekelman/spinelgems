require_relative "lib/ocean_names/polygon"

# Exercise OceanNames::Polygon directly (pure Ruby, no external deps)
# A simple square polygon
points = [[-1.0, -1.0], [1.0, -1.0], [1.0, 1.0], [-1.0, 1.0]]
poly = OceanNames::Polygon.new(points)

puts poly.contains?(lat: 0.0, lng: 0.0)
puts poly.contains?(lat: 2.0, lng: 2.0)
puts poly.contains?(lat: 0.5, lng: 0.5)
puts poly.contains?(lat: -0.5, lng: -0.5)
puts poly.is_a?(OceanNames::Polygon)
