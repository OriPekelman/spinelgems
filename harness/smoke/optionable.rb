puts Optionable::VERSION

any_int = Optionable::Any.new(Integer)
puts any_int.inspect
puts(any_int == 42)
puts(any_int == "hello")

class MyOptions
  include Optionable
  option(:mode).allow(:fast, :slow)
  option(:level).allow(1, 2, 3)
end

obj = MyOptions.new
begin
  obj.validate_strict(mode: :fast, level: 2)
  puts "valid ok"
rescue => e
  puts "unexpected: #{e.message}"
end

begin
  obj.validate_strict(mode: :bad)
  puts "should not reach"
rescue Optionable::Invalid => e
  puts e.message
end

begin
  obj.validate_strict(unknown_key: 1)
  puts "should not reach"
rescue Optionable::Unknown => e
  puts e.message
end
