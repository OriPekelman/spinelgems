require 'spliner'

# Exercise 1: Basic cubic spline interpolation via array constructor
spline = Spliner::Spliner.new [0.0, 1.0, 2.0, 3.0], [0.0, 1.0, 0.5, 1.5]

# Single value interpolation via [] alias
y_mid = spline[0.5]
puts "y at 0.5: #{y_mid.round(6)}"

y_one = spline[1.0]
puts "y at 1.0: #{y_one.round(6)}"

y_two = spline[2.0]
puts "y at 2.0: #{y_two.round(6)}"

# Exercise 2: Range of interpolated values
values = spline[(0.0..3.0).step(1.0)]
puts "range values: #{values.map { |v| v.round(6) }.join(', ')}"

# Exercise 3: Hash-based constructor
hash_spline = Spliner::Spliner.new({ 0.0 => 0.0, 1.0 => 2.0, 2.0 => 1.0 })
puts "hash spline at 0.5: #{hash_spline[0.5].round(6)}"
puts "hash spline at 1.5: #{hash_spline[1.5].round(6)}"

# Exercise 4: Class-method shortcut
y_shortcut = Spliner::Spliner[[0.0, 1.0, 2.0], [0.0, 1.0, 0.5], 0.5]
puts "shortcut at 0.5: #{y_shortcut.round(6)}"

# Exercise 5: sections count
puts "sections: #{spline.sections}"

# Exercise 6: range accessor
puts "range: #{spline.range}"

# Exercise 7: Discontinuous spline (duplicate X)
disc_spline = Spliner::Spliner.new [0.0, 1.0, 1.0, 2.0], [0.0, 1.0, 2.0, 3.0]
puts "discontinuous sections: #{disc_spline.sections}"
puts "discontinuous at 0.5: #{disc_spline[0.5].round(6)}"
puts "discontinuous at 1.5: #{disc_spline[1.5].round(6)}"
