# Encode a set of lat/lng points
encoded = Polylines::Encoder.encode_points([[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]])
puts encoded

# Decode back to points
decoded = Polylines::Decoder.decode_polyline(encoded)
decoded.each do |point|
  puts "#{point[0].round(5)},#{point[1].round(5)}"
end

# Encode a single coordinate value
puts Polylines::Encoder.encode(38.5)
puts Polylines::Encoder.encode(-120.2)
puts Polylines::Encoder.encode(0.0)
