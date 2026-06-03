# frozen_string_literal: true
# Smoke test for hashdiff gem — exercises diff, best_diff, patch!, unpatch!

require 'hashdiff'

# 1. Basic hash diff — added, removed, and changed keys
a = { 'a' => 1, 'b' => 2, 'c' => { 'x' => 10, 'y' => 20 } }
b = { 'a' => 1, 'b' => 3, 'c' => { 'x' => 10, 'z' => 30 } }

diff = Hashdiff.diff(a, b)
# Sort for deterministic output
diff.sort_by { |d| [d[0], d[1].to_s] }.each do |d|
  puts d.inspect
end

puts '---'

# 2. Diff with array values — uses LCS by default
c = { 'items' => [1, 2, 3], 'name' => 'foo' }
d = { 'items' => [1, 3, 4], 'name' => 'bar' }

diff2 = Hashdiff.diff(c, d)
diff2.sort_by { |x| [x[0], x[1].to_s] }.each do |x|
  puts x.inspect
end

puts '---'

# 3. best_diff — finds the smallest changeset for nested hashes in arrays
e = { 'x' => [{ 'a' => 1, 'c' => 3 }, { 'y' => 4 }] }
f = { 'x' => [{ 'a' => 1, 'b' => 2 }] }

best = Hashdiff.best_diff(e, f)
best.sort_by { |x| [x[0], x[1].to_s] }.each do |x|
  puts x.inspect
end

puts '---'

# 4. patch! — apply diff to reconstruct the target
original = { 'a' => 1, 'b' => 2 }
target   = { 'a' => 1, 'b' => 99, 'c' => 3 }
changes  = Hashdiff.diff(original, target)
patched  = Hashdiff.patch!(original.dup, changes)
puts patched.sort.map { |k, v| "#{k}=#{v}" }.join(',')

puts '---'

# 5. unpatch! — reverse the patch to get back to original
restored = Hashdiff.unpatch!(patched.dup, changes)
puts restored.sort.map { |k, v| "#{k}=#{v}" }.join(',')
