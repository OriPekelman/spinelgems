# Smoke test for rodash 4.0.0
# Tests Rodash.get, Rodash.set, Rodash.unset

object = { 'a' => [{ 'b' => { 'c' => 3 } }] }

puts Rodash.get(object, 'a[0].b.c')
puts Rodash.get(object, ['a', '0', 'b', 'c'])
puts Rodash.get(object, 'a.b.c', 'default')

Rodash.set(object, 'a[0].b.c', 42)
puts Rodash.get(object, 'a[0].b.c')

Rodash.set(object, 'x.y.z', 99)
puts Rodash.get(object, 'x.y.z')

puts Rodash.unset(object, 'a[0].b.c')
puts Rodash.get(object, 'a[0].b.c', 'gone')
