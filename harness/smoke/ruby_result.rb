s = RubyResult::Success.new(42)
puts s.success?
puts s.failure?
puts s.value

f = RubyResult::Failure.new("oops")
puts f.success?
puts f.failure?
puts f.value

puts RubyResult::Success === s
puts RubyResult::Failure === s
puts RubyResult::Failure === f
