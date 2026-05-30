# banzai smoke — exercises Filter and Pipeline with plain string transforms

# Base Filter just returns input unchanged
puts Banzai::Filter.call("hello")

# Subclass that upcases
class UpFilter < Banzai::Filter
  def call(input)
    input.upcase
  end
end

puts UpFilter.call("world")

# Subclass that appends "!"
class BangFilter < Banzai::Filter
  def call(input)
    input + "!"
  end
end

puts BangFilter.call("foo")

# Pipeline chaining UpFilter then BangFilter
pipeline = Banzai::Pipeline.new(UpFilter.new, BangFilter.new)
puts pipeline.call("banzai")

# Pipeline with a single filter
pipeline2 = Banzai::Pipeline.new(UpFilter.new)
puts pipeline2.call("simple")
