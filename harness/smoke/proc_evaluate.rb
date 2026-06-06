require 'proc_evaluate'

# Activate the refinements in this scope
using ProcEvaluate

# 1. Object#evaluate — non-proc values pass through unchanged
puts 42.evaluate(1, 2, 3)          # => 42
puts "hello".evaluate(:ignored)    # => hello

# 2. Lambda evaluate — trims extra args to match required arity
add = ->(a, b) { a + b }
puts add.evaluate(3, 4, 99)        # => 7  (extra 99 dropped)

# 3. Proc#parameter_type_counts
# In a proc, positional params are :opt (not :req)
variadic = proc {|a, *rest| [a, rest] }
counts = variadic.parameter_type_counts
puts counts[:opt]    # => 1
puts counts[:rest]   # => 1

# 4. has_optional_parameter? and has_key_parameter?
fixed    = ->(x, y) { x * y }
splat    = ->(*args) { args.sum }
kw_proc  = ->(a:, b: 0) { a + b }

puts fixed.has_optional_parameter?    # => false
puts splat.has_optional_parameter?    # => true
puts kw_proc.has_key_parameter?       # => true
puts fixed.has_key_parameter?         # => false

# 5. required_parameter_count and parameter_count
# Lambda ->(x, y) has :req params; parameter_type_count(:req, :opt) = 2
puts fixed.required_parameter_count   # => 2
puts splat.parameter_count            # => Infinity

# 6. Keyword proc evaluate
puts kw_proc.evaluate(10, a: 5, b: 3)  # => 8  (positional ignored by lambda, kw used)
