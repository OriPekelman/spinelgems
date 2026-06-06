require 'silva'

# Test 1: WGS84 (GPS) coordinates -> OS grid reference
# Using Buckingham Palace approx: lat=51.5014, lon=-0.1419
wgs84 = Silva::Location.from(:wgs84, lat: 51.5014, long: -0.1419)
gridref = wgs84.to(:gridref, digits: 6)
puts "WGS84 to gridref: #{gridref}"

# Test 2: WGS84 -> eastings/northings
en = wgs84.to(:en)
puts "WGS84 to easting: #{en.easting.round}"
puts "WGS84 to northing: #{en.northing.round}"

# Test 3: Eastings/northings -> grid reference
en_loc = Silva::Location.from(:en, easting: 530268, northing: 179545)
gr = en_loc.to(:gridref, digits: 8)
puts "EN to gridref: #{gr}"

# Test 4: Grid reference round-trip -> WGS84
gr_loc = Silva::Location.from(:gridref, gridref: 'TQ302795')
wgs = gr_loc.to(:wgs84)
puts "Gridref to lat: #{wgs.lat.round(4)}"
puts "Gridref to long: #{wgs.long.round(4)}"

# Test 5: Error handling for invalid system
begin
  Silva::Location.from(:invalid_system, lat: 0, long: 0)
  puts "ERROR: should have raised"
rescue Silva::InvalidSystemError => e
  puts "InvalidSystemError: #{e.message[0..40]}"
end
