# Loc gem smoke — Haversine distance + basic Location API
loc1 = Loc::Location.new(48.8566, 2.3522)   # Paris
loc2 = Loc::Location.new(51.5074, -0.1278)  # London

puts loc1.lat
puts loc1.lng
puts loc1.to_s
puts loc1 == Loc::Location[48.8566, 2.3522]

dist = loc1.distance_to(loc2)
puts dist.round(0)

loc3 = Loc::Location.from_array([40.7128, -74.0060])  # New York
puts loc3.to_a.inspect

col = Loc::LocationCollection.new([[48.8566, 2.3522], [51.5074, -0.1278]])
puts col.size
puts col.distance.round(0)
