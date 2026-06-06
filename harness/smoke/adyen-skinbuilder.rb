# Smoke test for adyen-skinbuilder
# The main require only loads version; hash.rb is a standalone extension.
require 'adyen-skinbuilder'
require 'hash'

# Exercise the VERSION constant
puts Adyen::Skinbuilder::VERSION

# Exercise Hash#symbolize_keys! with string keys
h = { 'name' => 'adyen', 'version' => 42, 'nested' => { 'key' => 'value' } }
h.symbolize_keys!
puts h[:name]
puts h[:version]
puts h[:nested][:key]

# Verify the method returns self (mutates in place)
h2 = { 'a' => 1, 'b' => 2 }
result = h2.symbolize_keys!
puts result.equal?(h2)
puts h2[:a]
puts h2[:b]
