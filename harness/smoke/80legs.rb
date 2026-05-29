require_relative "lib/eighty_legs"

puts EightyLegs::EightyError.name
puts EightyLegs::EightyError.superclass.name
puts EightyLegs::EightyError.ancestors.include?(StandardError)
e = EightyLegs::EightyError.new("test message")
puts e.message
puts e.is_a?(StandardError)
