require 'approximately'

# DeltaFloat basic construction and to_s/inspect
df = Approximately::DeltaFloat.new(3.14159, 0.001)
puts df.to_s
puts df.inspect

# approx module_function
a = Approximately.approx(1.0)
b = Approximately.approx(1.005)
c = Approximately.approx(1.02)

# Equality within default delta (0.01)
puts (a == b).inspect        # true: |1.005 - 1.0| = 0.005 < 0.01
puts (a == c).inspect        # false: |1.02 - 1.0| = 0.02 >= 0.01

# Comparable: less-than / greater-than
puts (a < c).inspect         # true
puts (c > a).inspect         # true

# Custom delta
tight = Approximately.approx(2.0, 0.001)
near  = Approximately.approx(2.0005, 0.001)
far   = Approximately.approx(2.002, 0.001)
puts (tight == near).inspect  # true: 0.0005 < 0.001
puts (tight == far).inspect   # false: 0.002 >= 0.001

# to_f passthrough
puts Approximately.approx(2.71828).to_f
