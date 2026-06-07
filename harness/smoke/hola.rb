require 'hola'

# Exercise the public API: Hola.hi prints "hi"
Hola.hi

# Verify class identity
puts Hola.class
puts Hola.respond_to?(:hi)
puts Hola.ancestors.include?(Hola)
