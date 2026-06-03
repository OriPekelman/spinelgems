require 'fnv'

# FNV-1 32-bit
puts Fnv::Hash.fnv_1("hello")
puts Fnv::Hash.fnv_1("world")

# FNV-1a 32-bit
puts Fnv::Hash.fnv_1a("hello")
puts Fnv::Hash.fnv_1a("world")

# FNV-1 64-bit
puts Fnv::Hash.fnv_1("hello", size: 64)

# FNV-1a 64-bit
puts Fnv::Hash.fnv_1a("hello", size: 64)

# FNV-1a 128-bit
puts Fnv::Hash.fnv_1a("hello", size: 128)

# empty string — offset basis returned unchanged
puts Fnv::Hash.fnv_1a("")
