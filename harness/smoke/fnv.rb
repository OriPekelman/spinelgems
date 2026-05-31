fnv = FNV.new
puts fnv.fnv1_32("hello")
puts fnv.fnv1_64("hello")
puts fnv.fnv1a_32("hello")
puts fnv.fnv1a_64("hello")
puts fnv.fnv1_32("")
puts fnv.fnv1a_32("abc")
puts FNV::INIT32
puts FNV::PRIME64
