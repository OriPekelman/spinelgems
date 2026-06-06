require 'xkeys'

# XKeys::Hash — nested hash auto-vivification with multi-key []= and []
root = {}.extend XKeys::Hash

root[:my, :list, :[]] = 'value 1'
root[:my, :list, :[]] = 'value 2'
root[:sparse, 10] = 'value 3'

puts root[:my, :list, 0]         # => value 1
puts root[:my, :list, 1]         # => value 2
puts root[:sparse, 10]           # => value 3
puts root[:missing].inspect      # => nil
puts root[:missing, else: false] # => false

# Default :else => nil for unknown nested keys
puts root[:a, :b, :c].inspect    # => nil

# XKeys::Auto — automatic hash vs array selection by key type
auto = {}.extend XKeys::Auto

auto[:names, :[]] = 'alice'
auto[:names, :[]] = 'bob'
auto[:score, 0]   = 42
auto[:score, 1]   = 99

puts auto[:names, 0]  # => alice
puts auto[:names, 1]  # => bob
puts auto[:score, 0]  # => 42
puts auto[:score, 1]  # => 99

# xfetch with :raise option
begin
  root.xfetch(:no_such_key)
rescue KeyError
  puts 'KeyError raised'
end

# Integer keys auto-vivify hashes under XKeys::Hash (not arrays)
# Use xfetch directly to avoid the Hash#slice ambiguity (2 integer args)
h = {}.extend XKeys::Hash
h[1, 2] = '12'
puts h.xfetch(1, 2)   # => 12
