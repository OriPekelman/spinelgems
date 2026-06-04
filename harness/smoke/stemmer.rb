require 'stemmer'

# Exercise the Porter stemmer via String#stem and String#stem_porter
# These are canonical Porter stemmer examples with known outputs.

words = %w[caresses ponies ties caress cats]
words.each { |w| puts "#{w} -> #{w.stem}" }

# Longer words exercising multiple suffix steps
words2 = %w[generalization electrically hopeful goodness revival allowance]
words2.each { |w| puts "#{w} -> #{w.stem}" }

# stem_porter and stem should produce identical results
%w[running runner troubles].each do |w|
  raise "mismatch on #{w}" unless w.stem == w.stem_porter
  puts "#{w} stem=#{w.stem}"
end

# Words shorter than 3 chars are returned unchanged
puts "by -> #{" by".strip.stem}"
puts "ok -> #{"ok".stem}"
