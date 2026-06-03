# rash_alt: Hashie::Mash::Rash — a Mash subclass that auto-underscores camelCase keys
# so camelCased JSON/API responses are accessed as Ruby-idiomatic snake_case.
# Entry point is lib/rash.rb (gem name does not match file name; use -Ilib).
require 'hashie/mash/rash'

# 1. Basic camelCase -> snake_case key normalisation
r = Hashie::Mash::Rash.new(
  "varOne"       => 1,
  "fiveHumpHumps" => 5,
  "CamelCase"    => "cc",
  :plain         => "ok"
)
puts r.var_one          # 1
puts r.five_hump_humps  # 5
puts r.camel_case       # cc
puts r.plain            # ok

# 2. Spaced / trailing-space / extra-space keys are normalised
r2 = Hashie::Mash::Rash.new(
  "spaced Key"      => "spaced",
  "trailing spaces " => "trail",
  "extra   spaces"  => "extra"
)
puts r2.spaced_key      # spaced
puts r2.trailing_spaces # trail
puts r2.extra_spaces    # extra

# 3. Nested Hash is converted to a Rash (not plain Mash)
r3 = Hashie::Mash::Rash.new("outerKey" => { "innerVal" => 42, "deepNested" => "yes" })
puts r3.outer_key.class        # Hashie::Mash::Rash
puts r3.outer_key.inner_val    # 42
puts r3.outer_key.deep_nested  # yes

# 4. Array of hashes: each element converted to Rash
r4 = Hashie::Mash::Rash.new("items" => [{ "itemName" => "alpha" }, { "itemName" => "beta" }])
puts r4.items[0].class      # Hashie::Mash::Rash
puts r4.items[0].item_name  # alpha
puts r4.items[1].item_name  # beta

# 5. Merge with a plain Hash preserves Rash type and normalises keys
merged = r.merge("newKey" => "new_val")
puts merged.new_key         # new_val
puts merged.class           # Hashie::Mash::Rash
