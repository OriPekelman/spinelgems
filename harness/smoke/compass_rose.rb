require 'compass_rose'

# compass_rose uses Fixnum (removed in Ruby 2.4) in CompassRose::Direction.validate_bearing.
# Under Ruby >= 2.4, any call to Direction.calculate / Compass::Rose.direction raises
# NameError: uninitialized constant CompassRose::Direction::Fixnum.
# The gem is incompatible with modern CRuby; smoke limited to constant inspection.

puts CompassRose::ROSE[:north][:full]     # North
puts CompassRose::ROSE[:east][:abbr]      # E
puts CompassRose::ROSE[:southwest][:wind_pt]  # Libeccio
puts CompassRose::ROSE[:north_northeast][:abbr]  # NNE
puts CompassRose::ROSE.keys.length        # total directions count

# RANGES constant is computed at load time
puts CompassRose::RANGES.keys.sort.inspect  # [:eight, :four, :sixteen, :thirtytwo]
puts CompassRose::RANGES[:four][:north][:low]   # >= 337.51 (wraps around)
puts CompassRose::RANGES[:four][:east][:high]   # 135.0

# Confirm direction call raises due to Fixnum removal
begin
  Compass::Rose.direction(0, 4)
  puts "unexpected success"
rescue NameError => e
  puts "NameError: #{e.message[0, 60]}"
end
