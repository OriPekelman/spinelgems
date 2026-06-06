require 'hash_base'

# Hash#apply — applies a block to deepest (non-Hash) values, returns new hash
h = { a: 1, b: { c: 2, d: 3 }, e: 4 }
result = h.apply { |v| v * 10 }
puts result[:a]          # 10
puts result[:b][:c]      # 20
puts result[:b][:d]      # 30
puts result[:e]          # 40

# Hash#apply! — in-place version
h2 = { x: "foo", y: { z: "bar" } }
h2.apply! { |v| v.upcase }
puts h2[:x]              # FOO
puts h2[:y][:z]          # BAR

# Hash#deep_values — flatten nested hash to array of leaf values
nested = { a: 1, b: { c: 2, d: { e: 3 } }, f: 4 }
puts nested.deep_values.sort.inspect   # [1, 2, 3, 4]

# Hash#max_depth — returns deepest nesting level
puts nested.max_depth    # 3
puts({}.max_depth)       # 1
puts({ a: { b: 1 } }.max_depth)  # 2

# Hash#deep_diff — compares two hashes, returns only differing keys
h_a = { a: 1, b: 2, c: { d: 3, e: 4 } }
h_b = { a: 1, b: 9, c: { d: 3, e: 99 } }
diff = h_a.deep_diff(h_b)
puts diff.keys.sort.inspect          # [:b, :c]
puts diff[:b].inspect                # [2, 9]
puts diff[:c][:e].inspect            # [4, 99]

# Hash#expand — reverse of group_by_positions: unfolds nested hash to array of rows
tree = { "A" => { "X" => [1, 2], "Y" => [3] }, "B" => { "Z" => [4] } }
rows = tree.expand
puts rows.length          # 4
puts rows.map(&:first).sort.inspect   # ["A", "A", "A", "B"]
