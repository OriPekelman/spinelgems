require 'finishing_moves'

# String#keyify — converts a string to a symbol key
puts "Hello World".keyify.inspect           # => :hello_world
puts "MyClassName".keyify.inspect           # => :my_class_name
puts "foo-bar-baz".slugify.inspect          # => "foo-bar-baz"
puts "Hello World!".slugify.inspect         # => "hello-world"

# String#nl2br / #newline_to
puts "line1\nline2".newline_to('|')         # => line1|line2
puts "a  b".dedupe(' ')                     # => a b

# Array#to_indexed_hash
puts [10, 20, 30].to_indexed_hash.inspect   # => {0=>10, 1=>20, 2=>30}
puts ['a', 'b'].to_hash_keys.inspect        # => {"a"=>0, "b"=>0}
puts ['x', 'y'].to_sym_strict.inspect       # => [:x, :y]

# Object extensions
puts 42.not_nil?.inspect                    # => true
puts nil.not_nil?.inspect                   # => false
puts true.true?.inspect                     # => true
puts false.false?.inspect                   # => true
puts "3.14".numeric?.inspect                # => true
puts "abc".numeric?.inspect                 # => false
puts 42.is_one_of?(String, Integer).inspect # => true
puts 42.same_as("42").inspect               # => true

# Kernel#nil_chain — returns nil if any NoMethodError/NameError inside
result = nil_chain { "hello".upcase }
puts result.inspect                         # => "HELLO"

result = nil_chain { nil.upcase }
puts result.inspect                         # => nil (NoMethodError caught)

# Kernel#bool_chain
puts bool_chain { "hi".length }.inspect     # => 2
puts bool_chain { nil.upcase }.inspect      # => false
