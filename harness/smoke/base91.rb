puts Base91::AVERAGE_ENCODING_RATIO
puts Base91::ENCODING_TABLE.length
puts Base91.encode("Hello")
puts Base91.encode("test")
puts Base91.encode("abc")
puts Base91.decode(Base91.encode("Hello"))
puts Base91.decode(Base91.encode("abc"))
