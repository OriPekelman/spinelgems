require 'guess'

# Test gender detection for clearly male names
james = Guess.gender("James")
puts "James gender: #{james[:gender]}"
puts "James male? #{james[:gender] == 'male'}"
puts "James confidence class: #{james[:confidence].class}"

# Test clearly female name
mary = Guess.gender("Mary")
puts "Mary gender: #{mary[:gender]}"
puts "Mary female? #{mary[:gender] == 'female'}"

# Test "Last, First" format (comma-separated)
result = Guess.gender("Smith, Linda")
puts "Smith, Linda gender: #{result[:gender]}"
puts "Smith, Linda female? #{result[:gender] == 'female'}"

# Test that confidence is a numeric value between 0 and 1
john = Guess.gender("John")
puts "John gender: #{john[:gender]}"
conf = john[:confidence]
puts "John confidence in range: #{conf.is_a?(Float) && conf > 0.5 && conf <= 1.0}"

# Test case insensitivity (names stored lowercase in data)
robert_upper = Guess.gender("ROBERT")
puts "ROBERT gender: #{robert_upper[:gender]}"
puts "ROBERT same as robert: #{Guess.gender('robert')[:gender] == robert_upper[:gender]}"
