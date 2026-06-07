require 'cloudmade'

# --- Point ---
p1 = CloudMade::Point.new(51.5, -0.1)
puts p1.to_s
puts p1.to_latlon
puts p1.to_wkt

p2 = CloudMade::Point.new([48.8566, 2.3522])
puts p2.to_s
puts p2 == CloudMade::Point.new(48.8566, 2.3522)

# --- Line ---
line = CloudMade::Line.new([[51.5, -0.1], [51.51, -0.11], [51.52, -0.12]])
puts line.to_s
puts line.to_wkt

# --- Polygon ---
outer = [[0.0, 0.0], [0.0, 1.0], [1.0, 1.0], [1.0, 0.0], [0.0, 0.0]]
hole  = [[0.2, 0.2], [0.2, 0.8], [0.8, 0.8], [0.8, 0.2], [0.2, 0.2]]
poly = CloudMade::Polygon.new([outer, hole])
puts poly.to_wkt

# --- Geometry.parse ---
point_data = { 'type' => 'point', 'coordinates' => [40.7128, -74.0060] }
parsed = CloudMade::Geometry.parse(point_data)
puts parsed.class
puts parsed.lat
puts parsed.lon

line_data = { 'type' => 'line', 'coordinates' => [[10.0, 20.0], [30.0, 40.0]] }
parsed_line = CloudMade::Geometry.parse(line_data)
puts parsed_line.class
puts parsed_line.points.size

# --- BBox ---
bbox = CloudMade::BBox.from_coordinates([[51.0, -1.0], [52.0, 0.0]])
puts bbox.points[0].to_s
puts bbox.points[1].to_s
