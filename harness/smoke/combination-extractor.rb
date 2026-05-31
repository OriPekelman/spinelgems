require_relative "lib/combination_extractor"

puts CombinationExtractor::VERSION

puts CombinationExtractor.name_for({fruit: 'apple', city: 'NewYork'})
puts CombinationExtractor.name_for({a: 1, b: 2})
puts CombinationExtractor.name_for(nil).inspect
