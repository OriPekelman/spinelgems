# ColorMath smoke: pure class-method colour conversions
puts ColorMath.rgb_to_hex(255, 0, 0)
puts ColorMath.rgb_to_hex(0, 128, 255)
puts ColorMath.hex_to_rgb("#FF8040").inspect
puts ColorMath.rgb_to_hsl(255, 0, 0).inspect
puts ColorMath.rgb_to_hsl(0, 255, 0).inspect
c = ColorMath.new(100, 150, 200)
puts c.to_hex
puts c.to_hsl.inspect
