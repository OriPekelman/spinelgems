require 'transparent_nil'

# NilClass extensions: empty collection / string-like behaviour
puts nil.empty?.inspect        # true
puts nil.length.inspect        # 0
puts nil.size.inspect          # 0
puts nil.count.inspect         # 0
puts nil.include?(:x).inspect  # false
puts (nil << 42).inspect       # [42]
puts nil.split(",").inspect    # []
puts nil.gsub("a", "b").inspect # nil
puts nil.downcase.inspect      # nil
puts nil.strip.inspect         # nil
puts (nil + "foo").inspect     # nil
puts (nil - 1).inspect         # nil
puts nil.compact.inspect       # nil
puts nil.to_sym.inspect        # nil
puts nil.keys.inspect          # nil
puts nil.join.inspect          # nil
puts nil.uniq.inspect          # nil

# Numeric extensions
puts 0.to_nil.inspect          # nil
puts 5.to_nil.inspect          # 5
puts 3.14.to_nil.inspect       # 3.14
puts 0.0.to_nil.inspect        # nil
puts 10.substract(3).inspect   # 7
puts 10.substract(nil).inspect # nil
