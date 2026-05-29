# RVincenty.distance returns the geodesic distance in metres between two lat/lon points.
# Using well-known fixed coordinate pairs so output is deterministic.

# Coincident points → 0
puts RVincenty.distance([0.0, 0.0], [0.0, 0.0])

# Flinders Peak to Buninyong (the classic Vincenty example, ~54972.271 m)
d = RVincenty.distance([-37.9510334, 144.4248679], [-37.6528178, 143.9264977])
puts d.round(3)

# New York to London (approx 5570km)
d2 = RVincenty.distance([40.7128, -74.0060], [51.5074, -0.1278])
puts d2.round(0)

# Same latitude, short hop
d3 = RVincenty.distance([48.8566, 2.3522], [48.8566, 2.4522])
puts d3.round(3)
