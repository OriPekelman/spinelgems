a = SemanticPuppet::Version.parse("1.2.3")
b = SemanticPuppet::Version.parse("1.10.0")
puts "a<b=#{a < b}"
puts "major=#{a.major} minor=#{a.minor} patch=#{a.patch}"
puts "str=#{a}"
