# Test SafeConstantize class structure and error-raising path
# (no ActiveSupport needed for these paths)

puts SafeConstantize::IllegalClassToConstantize.ancestors.include?(RuntimeError)
puts SafeConstantize::IllegalClassToConstantize.superclass

begin
  SafeConstantize.constantize("Foo", ["Bar"])
rescue SafeConstantize::IllegalClassToConstantize => e
  puts e.message
rescue => e
  puts "other: #{e.class}"
end

begin
  SafeConstantize.constantize("Baz", [])
rescue SafeConstantize::IllegalClassToConstantize => e
  puts e.message
rescue => e
  puts "other: #{e.class}"
end
