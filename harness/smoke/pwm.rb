puts Pwm::VERSION
chars = Pwm.characters
puts chars.length
puts chars.first
puts chars.last
puts chars.include?("I")
puts chars.include?("A")
begin
  Pwm.password(5)
rescue Pwm::TooShortException => e
  puts e.message
end
