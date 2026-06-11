# text_parser 0.3.0 — smoke test
# TextParser is mixed into String; call .parse on string literals

puts TextParser::VERSION

result = "hello world hello ruby world hello".parse
sorted = result.sort_by { |h| h[:word] }
sorted.each { |h| puts "#{h[:word]}:#{h[:hits]}" }

result2 = "foo bar baz foo foo bar".parse(order: :hits, order_direction: :desc)
result2.each { |h| puts "#{h[:word]}:#{h[:hits]}" }

result3 = "apple orange apple".parse(negative_dictionary: ["orange"])
result3.each { |h| puts "#{h[:word]}:#{h[:hits]}" }

puts "one two".parse(minimum_length: 3).map { |h| h[:word] }.join(",")
