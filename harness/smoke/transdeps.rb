require_relative "lib/transdeps/specification"

# VERSION constant
puts Transdeps::VERSION

# Specification: constructor and to_s
s1 = Transdeps::Specification.new("rails", "7.0.0", "/projects/app")
puts s1.to_s
puts s1.name
puts s1.version

# from_lock class method
s2 = Transdeps::Specification.from_lock("sinatra (3.1.0)", "/projects/other")
puts s2.to_s
puts s2.name

# Comparison methods (=~ operator triggers the codegen bug)
puts s1.same_gem_as?(Transdeps::Specification.new("rails", "7.0.1", "/projects/other"))
puts (s1 =~ Transdeps::Specification.new("rails", "7.0.0", "/any"))
puts (s1 =~ Transdeps::Specification.new("rails", "8.0.0", "/any"))
