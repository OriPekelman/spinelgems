# Smoke test for vindicator gem - VIN validation
puts Vindicator.valid_vin?('1GNEC233X9R191831')
puts Vindicator.valid_vin?('1HGCM82633A004352')
puts Vindicator.valid_vin?('1111111111111111X')
puts Vindicator.valid_vin?('INVALIDVIN')
puts Vindicator.valid_vin?('00000000000000000')
