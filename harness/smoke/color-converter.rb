require_relative "lib/color_converter"
# ColorConverter smoke — pure color-space conversions, no external deps
puts ColorConverter.hex(255, 255, 255)
puts ColorConverter.hex(0, 0, 0)
puts ColorConverter.hex(255, 0, 128)
puts ColorConverter.rgb('#FF0080').inspect
puts ColorConverter.rgb(0, 0, 0, 0).inspect
puts ColorConverter.cmyk(255, 255, 255).inspect
puts ColorConverter.cmyk(255, 0, 128).inspect
