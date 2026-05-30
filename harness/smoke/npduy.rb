puts Npduy.class
puts Npduy.respond_to?(:process)

# Exercise the same gsub patterns used in Npduy.process
s = "hello\nbinding.pry\nworld\n"
puts s.gsub(/binding.pry/, "\s")

s2 = "foo\nbyebug\nbar\n"
puts s2.gsub(/byebug/, "\s")

s3 = "line1   \n\nline2\n"
result = s3.gsub(/[\s]+[\n]+/, "\n")
puts result
