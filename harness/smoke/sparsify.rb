require 'sparsify'

# Exercise Sparsify.sparse: flatten a nested hash
nested = { 'a' => { 'b' => 1, 'c' => { 'd' => 2 } }, 'e' => 3 }
sparse = Sparsify.sparse(nested)
puts sparse.sort.map { |k, v| "#{k}=#{v}" }.join(', ')
# => a.b=1, a.c.d=2, e=3

# Exercise Sparsify.unsparse: reconstruct nested hash
flat = { 'x.y.z' => 10, 'x.y.w' => 20, 'x.v' => 30 }
restored = Sparsify.unsparse(flat)
puts restored['x']['y']['z']
puts restored['x']['y']['w']
puts restored['x']['v']

# Exercise sparse with custom separator
nested2 = { 'foo' => { 'bar' => 'baz', 'qux' => 99 } }
sparse2 = Sparsify.sparse(nested2, separator: '/')
puts sparse2.sort.map { |k, v| "#{k}=#{v}" }.join(', ')
# => foo/bar=baz, foo/qux=99

# Exercise sparse_fetch on a nested hash
hsh = { 'level1' => { 'level2' => { 'leaf' => 'found' } } }
puts Sparsify.sparse_fetch(hsh, 'level1.level2.leaf')

# Exercise sparse_get (returns nil for missing)
puts Sparsify.sparse_get(hsh, 'level1.missing').inspect

# Exercise sparse_each enumeration
collected = []
Sparsify.sparse_each({ 'p' => { 'q' => 42 } }) do |k, v|
  collected << "#{k}->#{v}"
end
puts collected.join('; ')
