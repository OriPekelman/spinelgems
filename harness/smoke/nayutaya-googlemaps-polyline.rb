require 'stringio'
require 'googlemaps_polyline'

# Test encode_polyline: lat/lng in degrees + level
records = [
  [35.6895,  139.6917, 3],
  [34.6937,  135.5023, 2],
  [43.0642,  141.3469, 1],
]

encoded_points, encoded_levels = GoogleMapsPolyline.encode_polyline(records)
puts "encoded_points=#{encoded_points.inspect}"
puts "encoded_levels=#{encoded_levels.inspect}"

# Round-trip: decode back to 1e5 integers, then to floats
decoded = GoogleMapsPolyline.decode_polyline(encoded_points, encoded_levels)
decoded.each_with_index do |(lat, lng, level), i|
  orig = records[i]
  lat_ok  = (lat  - orig[0]).abs < 1e-4
  lng_ok  = (lng  - orig[1]).abs < 1e-4
  lvl_ok  = level == orig[2]
  puts "record #{i}: lat_ok=#{lat_ok} lng_ok=#{lng_ok} level_ok=#{lvl_ok}"
end

# Test encode/decode at the 1e5 integer level directly
points_1e5 = [[3568950, 13969170], [3469370, 13550230]]
levels_1    = [2, 1]
ep, el = GoogleMapsPolyline.encode_points_and_levels(points_1e5, levels_1)
puts "1e5 encoded_points=#{ep.inspect}"
puts "1e5 encoded_levels=#{el.inspect}"
dp, dl = GoogleMapsPolyline.decode_points_and_levels(ep, el)
puts "1e5 decoded_points=#{dp.inspect}"
puts "1e5 decoded_levels=#{dl.inspect}"
