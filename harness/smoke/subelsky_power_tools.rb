puts SubelskyPowerTools.name
puts SubelskyPowerTools.is_a?(Module)
require_relative "lib/subelsky_power_tools/ext/hash"
h = {a: 1, b: 2, c: 3}
puts h.except(:a).keys.sort.inspect
puts h.only(:b, :c).values.sort.inspect
h2 = {x: 10, y: 20, z: 30}
removed = h2.except!(:x)
puts removed.inspect
puts h2.keys.sort.inspect
