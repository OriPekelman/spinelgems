require 'flatten'

# smash: flatten a deeply nested hash into dot-separated keys
nested = { 'foo' => { 'bar' => 'bingo', 'baz' => 42 }, 'top' => 'val' }
smashed = Flatten.smash(nested)
puts smashed.sort.map { |k, v| "#{k}=#{v}" }.join(', ')

# smash_get: access a nested key via dot-path
deep = { 'a' => { 'b' => { 'c' => 'found' } } }
puts Flatten.smash_get(deep, 'a.b.c')
puts Flatten.smash_get(deep, 'a.b.missing').inspect

# smash_fetch with default
puts Flatten.smash_fetch(deep, 'a.b.c', 'default')
puts Flatten.smash_fetch(deep, 'x.y.z', 'fallback')

# smash_each: iterate yielding dot-key + value
data = { 'x' => { 'y' => 1 }, 'z' => 2 }
pairs = []
Flatten.smash_each(data) { |k, v| pairs << "#{k}:#{v}" }
puts pairs.sort.join(' ')

# smash with custom separator
alt = { 'a' => { 'b' => 'sep_test' } }
puts Flatten.smash(alt, separator: '/').keys.first
